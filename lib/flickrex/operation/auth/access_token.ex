defmodule Flickrex.Operation.Auth.AccessToken do
  @moduledoc """
  Holds data necessary for an operation to request an access token.
  """

  alias Flickrex.{
    OAuth,
    Operation,
    Parsers,
    Request,
  }

  @type t :: %__MODULE__{}

  defstruct [
    parser: &Parsers.Auth.parse_access_token/1,
    path: "services/oauth/access_token",
    oauth_token: nil,
    oauth_token_secret: nil,
    verifier: nil,
    service: :api,
  ]

  defimpl Operation do
    def prepare(operation, config) do
      http_method = "get"
      params = [oauth_verifier: operation.verifier]

      key = config.consumer_key
      secret = config.consumer_secret
      token = operation.oauth_token
      token_secret = operation.oauth_token_secret

      uri =
        config.url
        |> URI.parse()
        |> URI.merge(operation.path)

      signed_params = OAuth.sign(http_method, to_string(uri), params,
        key, secret, token, token_secret)

      query = URI.encode_query(signed_params)

      url =
        uri
        |> Map.put(:query, query)
        |> to_string()

      %Request{method: http_method, url: url}
    end

    def perform(operation, request) do
      request
      |> Request.request()
      |> operation.parser.()
    end
  end
end
