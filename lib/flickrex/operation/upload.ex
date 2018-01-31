defmodule Flickrex.Operation.Upload do
  @moduledoc """
  Holds data necessary for an operation on the Flickr Upload service.
  """

  alias Flickrex.{
    Operation,
    Parsers
  }

  @type t :: %__MODULE__{}
  @type photo :: String.t()

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
        |> Enum.map(fn {k, v} -> {to_string(k), to_string(v)} end)

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

      request
      |> Request.request(config)
      |> operation.parser.()
    end
  end
end
