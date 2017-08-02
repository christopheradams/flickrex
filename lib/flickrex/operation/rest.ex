defmodule Flickrex.Operation.Rest do
  @moduledoc """
  Holds data necessary for an operation on the Flickr REST service.
  """

  @json_params %{nojsoncallback: 1}

  @type t :: %__MODULE__{}

  defstruct [
    path: "services/rest",
    parser: &Flickrex.Parsers.Rest.parse/1,
    params: %{},
    method: nil,
    http_method: nil,
    format: "json",
    extra_params: @json_params,
    service: :api,
  ]

  defimpl Flickrex.Operation do
    def prepare(operation, config) do
      http_method = operation.http_method

      params =
        operation.extra_params
        |> Map.put(:method, operation.method)
        |> Map.put(:format, operation.format)
        |> Map.merge(operation.params)
        |> Keyword.new()

      key = config.consumer_key
      secret = config.consumer_secret
      token = config.oauth_token
      token_secret = config.oauth_token_secret

      uri =
        config.url
        |> URI.parse()
        |> URI.merge(operation.path)

      signed_params = Flickrex.OAuth.sign(http_method, to_string(uri), params,
        key, secret, token, token_secret)

      query = URI.encode_query(signed_params)

      url =
        uri
        |> Map.put(:query, query)
        |> to_string()

      %Flickrex.Request{method: http_method, url: url}
    end

    def perform(operation, request) do
      request
      |> Flickrex.Request.request()
      |> operation.parser.()
    end
  end
end
