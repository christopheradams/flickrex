defmodule Flickrex.Operation.Rest do
  @moduledoc """
  Holds data necessary for an operation on the Flickr REST service.

  The `:format` must be one of `:json` or `:rest`, the latter returning XML. The
  default is `:json`.

  The `parser` must be a 1- or 2-arity function, accepting an `:ok` or `:error`
  response, and optionally a `Flickrex.Config` struct.
  """

  alias Flickrex.{
    Config,
    Request.HttpClient,
    Operation,
    Parsers
  }

  @json_params %{nojsoncallback: 1}

  @type success_t :: HttpClient.success_t()
  @type error_t :: HttpClient.error_t()
  @type config :: Config.t()
  @type results :: success_t() | error_t()
  @type path :: String.t()
  @type parser :: (results() -> results()) | (results(), config() -> results())
  @type params :: %{optional(String.Chars.t()) => String.Chars.t()}
  @type method :: String.t()
  @type http_method :: atom
  @type http_headers :: %{optional(String.t()) => String.t()}
  @type format :: :json | :rest
  @type service :: atom

  @type t :: %__MODULE__{
          path: path(),
          parser: parser(),
          params: params(),
          method: method(),
          http_method: http_method(),
          http_headers: http_headers(),
          format: format(),
          default_params: params(),
          service: service()
        }

  defstruct path: "services/rest",
            parser: &Parsers.Rest.parse/2,
            params: %{},
            method: nil,
            http_method: nil,
            http_headers: %{},
            format: :json,
            default_params: @json_params,
            service: :api

  defimpl Operation do
    alias Flickrex.{
      Config,
      OAuth,
      Operation,
      Request
    }

    @spec perform(Operation.Rest.t(), Config.t()) :: term
    def perform(operation, config) do
      http_method = operation.http_method
      http_headers = Map.to_list(operation.http_headers)

      params =
        operation.default_params
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

      query =
        http_method
        |> OAuth.sign(uri, params, key, secret, token, token_secret)
        |> URI.encode_query()

      url =
        uri
        |> Map.put(:query, query)
        |> to_string()

      request = %Request{
        method: http_method,
        headers: http_headers,
        url: url
      }

      response = Request.request(request, config)
      parser = operation.parser

      cond do
        is_function(parser, 1) ->
          parser.(response)

        is_function(parser, 2) ->
          parser.(response, config)

        true ->
          response
      end
    end
  end
end
