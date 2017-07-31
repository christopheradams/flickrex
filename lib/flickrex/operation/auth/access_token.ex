defmodule Flickrex.Operation.Auth.AccessToken do
  @moduledoc """
  Holds data necessary for an operation to request an access token.
  """

  @type t :: %__MODULE__{}

  defstruct [
    parser: &Flickrex.Parsers.Auth.parse_access_token/1,
    path: "services/oauth/access_token",
    request_token: nil,
    request_secret: nil,
    verifier: nil,
    service: :api,
  ]

  defimpl Flickrex.Operation do
    def prepare(operation, config) do
      http_method = "get"
      params = [oauth_verifier: operation.verifier]

      key = config.consumer_key
      secret = config.consumer_secret
      token = operation.request_token
      token_secret = operation.request_secret

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
