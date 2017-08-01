defmodule Flickrex do
  @moduledoc ~S"""
  Performs Flickr API requests.

  # Examples

      operation = Flickrex.Flickr.Photos.get_recent(per_page: 5)
      config = [url: "https://flickr-proxy.example.com"]

      {:ok, resp} = Flickrex.request(operation, config)
  """

  alias Flickrex.API
  alias Flickrex.API.Auth
  alias Flickrex.Client
  alias Flickrex.Parser
  alias Flickrex.XmlParser
  alias Flickrex.Schema

  @doc """
  Performs a Flickr API request.

  ## Options

  * `consumer_key` - Flickr API consumer key.
  * `consumer_secret` - Flickr API consumer secret.
  * `oauth_token` - Flicker user access token.
  * `oauth_token_secret` - Flicker user access token secret.
  * `url` - API Endpoint URL.
  * `http_client` - HTTP client function. See `Flickrex.Request.HttpClient`.
  """
  @spec request(Flickrex.Operation.t) :: term
  @spec request(Flickrex.Operation.t, Keyword.t) :: {:ok, term} | {:error, term}
  def request(operation, opts \\ []) do
    config = Flickrex.Config.new(operation.service, opts)

    request =
      operation
      |> Flickrex.Operation.prepare(config)
      |> Map.put(:http_client, config.http_client)

    Flickrex.Operation.perform(operation, request)
  end

  @doc false
  @spec new :: Client.t
  def new do
    IO.warn("Flickrex.new/0 is deprecated.", [])
    new(Application.get_env(:flickrex, :oauth))
  end

  @doc false
  @spec new(Keyword.t) :: Client.t
  def new(config) do
    IO.warn("Flickrex.new/1 is deprecated.", [])
    Client.new(config)
  end

  @doc false
  @spec update(Client.t, atom, String.t) :: Client.t
  def update(client, key, value) do
    IO.warn("Flickrex.update/3 is deprecated.", [])
    Client.put(client, key, value)
  end

  @doc false
  @spec put_access_token(Client.t, Schema.Access.t) :: Client.t
  def put_access_token(client, %Schema.Access{oauth_token: token, oauth_token_secret: secret}) do
    IO.warn("Flickrex.put_access_token/2 is deprecated.", [])
    put_access_token(client, token, secret)
  end

  @doc false
  @spec put_access_token(Client.t, String.t, String.t) :: Client.t
  def put_access_token(client, token, secret) do
    IO.warn("Flickrex.put_access_token/3 is deprecated.", [])
    client |> Client.put(:access_token, token) |> Client.put(:access_token_secret, secret)
  end

  @doc false
  @spec fetch_request_token(Client.t, Keyword.t) :: {:ok, Client.Request.t} | {:error, binary}
  def fetch_request_token(client, params \\ []) do
    IO.warn("Flickrex.fetch_request_token/2 is deprecated.", [])
    Auth.fetch_request_token(client, params)
  end

  @doc false
  @spec get_authorize_url(Client.Request.t, Keyword.t) :: binary
  def get_authorize_url(request_token, params \\ []) do
    IO.warn("Flickrex.get_authorize_url/2 is deprecated.", [])
    Auth.get_authorize_url(request_token, params)
  end

  @doc false
  @spec fetch_access_token(Client.t, Client.Request.t, binary) :: Schema.Access.t | {:error, term}
  def fetch_access_token(client, request_token, verify) do
    IO.warn("Flickrex.fetch_access_token/3 is deprecated.", [])
    API.Auth.fetch_access_token(client, request_token, verify)
  end

  @doc false
  @spec fetch_access_token(Client.t, String.t, String.t, binary) :: Schema.Access.t | {:error, term}
  def fetch_access_token(client, token, secret, verify) do
    IO.warn("Flickrex.fetch_access_token/4 is deprecated.", [])
    fetch_access_token(client, %Client.Request{token: token, secret: secret}, verify)
  end

  @doc false
  @spec get(Client.t, binary, Keyword.t) :: Parser.response
  def get(client, method, args \\ []) do
    IO.warn("Flickrex.get/3 is deprecated.", [])
    call(client, :get, method, args)
  end

  @doc false
  @spec post(Client.t, binary, Keyword.t) :: Parser.response
  def post(client, method, args \\ []) do
    IO.warn("Flickrex.get/3 is deprecated.", [])
    call(client, :post, method, args)
  end

  @spec call(Client.t, :get | :post, binary, Keyword.t) :: Parser.response
  defp call(client, http_method, method, args) do
    case API.Base.call(client, http_method, method, args) do
      {:ok, result} -> Parser.parse(result)
      result -> result
    end
  end

  @doc false
  @spec upload(Client.t, Keyword.t) :: {:ok | :error, binary}
  def upload(client, args \\ []) do
    IO.warn("Flickrex.upload/2 is deprecated.", [])
    client |> API.Base.upload_photo(args) |> photo_result()
  end

  @doc false
  @spec replace(Client.t, Keyword.t) :: {:ok | :error, binary}
  def replace(client, args \\ []) do
    IO.warn("Flickrex.replace/2 is deprecated.", [])
    client |> API.Base.replace_photo(args) |> photo_result()
  end

  defp photo_result(result) do
    case result do
      {:ok, response} ->
        XmlParser.parse(response)
      result ->
        result
    end
  end
end
