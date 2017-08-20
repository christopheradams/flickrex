defmodule Flickrex.Operation.Auth.RequestToken do
  @moduledoc """
  Holds data necessary for an operation to request a temporary token.
  """

  @oauth_callback "oob"

  @type t :: %__MODULE__{}

  defstruct [
    parser: &Flickrex.Parsers.Auth.parse_request_token/1,
    path: "services/oauth/request_token",
    params: %{oauth_callback: @oauth_callback},
    service: :api
  ]

  defimpl Flickrex.Operation do

    def prepare(operation, config) do
      http_method = "get"
      params = Keyword.new(operation.params)

      uri =
        config.url
        |> URI.parse()
        |> URI.merge(operation.path)

      signed_params = Flickrex.OAuth.sign(http_method, to_string(uri),
        params, config.consumer_key, config.consumer_secret, nil, nil)

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
