defmodule Flickrex.Operation.Auth.RequestToken do
  @moduledoc """
  Holds data necessary for an operation to request a temporary token.
  """

  alias Flickrex.{
    Operation,
    Parsers
  }

  @oauth_callback "oob"

  @type t :: %__MODULE__{}

  defstruct parser: &Parsers.Auth.parse_request_token/1,
            path: "services/oauth/request_token",
            params: %{oauth_callback: @oauth_callback},
            service: :api

  defimpl Operation do
    alias Flickrex.{
      Config,
      OAuth,
      Operation,
      Request
    }

    @spec prepare(Operation.Auth.RequestToken.t(), Config.t()) :: Request.t()
    def prepare(operation, config) do
      http_method = "get"
      params = Keyword.new(operation.params)

      uri =
        config.url
        |> URI.parse()
        |> URI.merge(operation.path)

      key = config.consumer_key
      secret = config.consumer_secret

      signed_params = OAuth.sign(http_method, uri, params, key, secret, nil, nil)

      query = URI.encode_query(signed_params)

      url =
        uri
        |> Map.put(:query, query)
        |> to_string()

      %Request{method: http_method, url: url}
    end

    @spec perform(Operation.Auth.RequestToken.t(), Request.t()) :: term
    def perform(operation, request) do
      request
      |> Request.request()
      |> operation.parser.()
    end
  end
end
