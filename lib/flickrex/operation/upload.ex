defmodule Flickrex.Operation.Upload do
  @moduledoc """
  Holds data necessary for an operation on the Flickr Upload service.
  """

  @type t :: %__MODULE__{}

  @upload_path "services/upload"
  @replace_path "services/replace"

  defstruct [
    path: @upload_path,
    parser: &Flickrex.Parsers.Upload.parse/1,
    params: %{},
    photo: nil,
    service: :upload
  ]

  @doc false
  def new(:upload, photo, opts) do
    make(@upload_path, photo, opts)
  end

  @doc false
  def new(:replace, photo, opts) do
    make(@replace_path, photo, opts)
  end

  def make(path, photo, opts) do
    %__MODULE__{
      path: path,
      params: Map.new(opts),
      photo: photo
    }
  end

  defimpl Flickrex.Operation do
    def prepare(operation, config) do
      http_method = "post"

      params = Keyword.new(operation.params)

      key = config.consumer_key
      secret = config.consumer_secret
      token = config.access_token
      token_secret = config.access_token_secret

      uri =
        config.url
        |> URI.parse()
        |> URI.merge(operation.path)

      signed_params =
        http_method
        |> Flickrex.OAuth.sign(to_string(uri), params, key, secret, token, token_secret)
        |> Enum.map(fn {k, v} -> {to_string(k), to_string(v)} end)

      name = "photo"
      file = operation.photo
      filename = Path.basename(file)
      disposition = {"form-data", [{"name", "\"#{name}\""}, {"filename", "\"#{filename}\""}]}
      file_param = {:file, file, disposition, []}

      parts = signed_params ++ [file_param]

      body = {:multipart, parts}

      url = to_string(uri)

      %Flickrex.Request{method: http_method, url: url, body: body}
    end

    def perform(operation, request) do
      request
      |> Flickrex.Request.request()
      |> operation.parser.()
    end
  end
end
