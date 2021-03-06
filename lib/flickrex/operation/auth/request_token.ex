defmodule Flickrex.Operation.Auth.RequestToken do
  @moduledoc """
  Holds data necessary for an operation to request a temporary token.
  """

  alias Flickrex.{
    Operation,
    Parsers
  }

  @out_of_band "oob"
  @default_params %{oauth_callback: @out_of_band}

  @type t :: %__MODULE__{}

  defstruct parser: &Parsers.Auth.parse_request_token/1,
            path: "services/oauth/request_token",
            params: @default_params,
            http_headers: %{},
            service: :api

  @doc false
  @spec new(Keyword.t()) :: t()
  def new(opts \\ []) do
    %__MODULE__{
      params: Map.merge(@default_params, Map.new(opts))
    }
  end

  defimpl Operation do
    alias Flickrex.{
      Config,
      OAuth,
      Operation,
      Request
    }

    @spec perform(Operation.Auth.RequestToken.t(), Config.t()) :: term
    def perform(operation, config) do
      http_method = :get
      http_headers = Map.to_list(operation.http_headers)
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
