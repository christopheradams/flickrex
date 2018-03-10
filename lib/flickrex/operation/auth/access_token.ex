defmodule Flickrex.Operation.Auth.AccessToken do
  @moduledoc """
  Holds data necessary for an operation to request an access token.
  """

  alias Flickrex.{
    Operation,
    Parsers
  }

  @type t :: %__MODULE__{}

  defstruct parser: &Parsers.Auth.parse_access_token/1,
            path: "services/oauth/access_token",
            oauth_token: nil,
            oauth_token_secret: nil,
            oauth_verifier: nil,
            http_headers: %{},
            service: :api

  defimpl Operation do
    alias Flickrex.{
      Config,
      OAuth,
      Operation,
      Request
    }

    @spec perform(Operation.Auth.AccessToken.t(), Config.t()) :: term
    def perform(operation, config) do
      http_method = :get
      http_headers = Map.to_list(operation.http_headers)
      params = [oauth_verifier: operation.oauth_verifier]

      key = config.consumer_key
      secret = config.consumer_secret
      token = operation.oauth_token
      token_secret = operation.oauth_token_secret

      uri =
        config.url
        |> URI.parse()
        |> URI.merge(operation.path)

      signed_params = OAuth.sign(http_method, uri, params, key, secret, token, token_secret)

      query = URI.encode_query(signed_params)

      url =
        uri
        |> Map.put(:query, query)
        |> to_string()

      request = %Request{
        method: http_method,
        headers: http_headers,
        url: url
      }

      request
      |> Request.request(config)
      |> operation.parser.()
    end
  end
end
