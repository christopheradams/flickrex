defmodule Flickrex.Operation.Upload do
  @moduledoc """
  Holds data necessary for an operation on the Flickr Upload service.

  The `parser` must be a 1- or 2-arity function, accepting an `:ok` or `:error`
  response, and optionally a `Flickrex.Config` struct.
  """

  alias Flickrex.{
    Config,
    Request.HttpClient,
    Operation,
    Parsers
  }

  @type success_t :: HttpClient.success_t()
  @type error_t :: HttpClient.error_t()
  @type config :: Config.t()
  @type results :: success_t() | error_t()
  @type path :: String.t()
  @type parser :: (results() -> results()) | (results(), config() -> results())
  @type params :: map
  @type photo :: String.t()
  @type http_headers :: map
  @type service :: atom

  @type t :: %__MODULE__{
          path: path(),
          parser: parser(),
          params: params(),
          photo: photo(),
          http_headers: http_headers(),
          service: service()
        }

  @upload_path "services/upload"
  @replace_path "services/replace"

  defstruct path: @upload_path,
            parser: &Parsers.Upload.parse/1,
            params: %{},
            photo: nil,
            http_headers: %{},
            service: :upload

  @doc false
  @spec new(:upload, photo, Keyword.t()) :: t
  def new(:upload, photo, opts) do
    build(@upload_path, photo, opts)
  end

  @doc false
  @spec new(:replace, photo, Keyword.t()) :: t
  def new(:replace, photo, opts) do
    build(@replace_path, photo, opts)
  end

  defp build(path, photo, opts) do
    %__MODULE__{
      path: path,
      params: Map.new(opts),
      photo: photo
    }
  end

  defimpl Operation do
    alias Flickrex.{
      Config,
      OAuth,
      Operation,
      Request
    }

    @spec perform(Operation.Upload.t(), Config.t()) :: term
    def perform(operation, config) do
      http_method = :post
      http_headers = Map.to_list(operation.http_headers)

      params = Keyword.new(operation.params)

      key = config.consumer_key
      secret = config.consumer_secret
      token = config.oauth_token
      token_secret = config.oauth_token_secret

      uri =
        config.url
        |> URI.parse()
        |> URI.merge(operation.path)

      signed_params =
        http_method
        |> OAuth.sign(uri, params, key, secret, token, token_secret)
        |> to_strings()

      name = "photo"
      file = operation.photo
      filename = Path.basename(file)
      disposition = {"form-data", [{"name", "\"#{name}\""}, {"filename", "\"#{filename}\""}]}
      file_param = {:file, file, disposition, []}

      parts = signed_params ++ [file_param]

      body = {:multipart, parts}

      url = to_string(uri)

      request = %Request{
        method: http_method,
        headers: http_headers,
        url: url,
        body: body
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

    defp to_strings(params) do
      Enum.map(params, fn {k, v} -> {to_string(k), to_string(v)} end)
    end
  end
end
