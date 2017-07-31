defmodule Flickrex do
  @moduledoc ~S"""
  Flickr client library for Elixir.

  ## Configuration

      config :flickrex, :oauth, [
        consumer_key:    "...",
        consumer_secret: "...",
      ]

  The configuration also accepts `access_token` and `access_token_secret` keys,
  but it is highly recommended to store these values separately for each
  authenticated user, rather than setting them globally.

  ## Examples

      flickrex = Flickrex.new
      {:ok, photos} = Flickrex.get(flickrex, "flickr.photos.getRecent", per_page: 5)

  Instead of using `get/3` and `post/3` directly, refer to the `Flickr` Module API.

  ## Authentication

  Certain Flickr methods require authorization from a user account. You must
  present an authorizaton URL to the user, and obtain a verification code that
  can be exchanged for access tokens. You can store and re-use the access tokens
  without having to repeat the authorization step.

  ### Manual Verification

      flickrex = Flickrex.new
      {:ok, request} = Flickrex.fetch_request_token(flickrex)
      auth_url = Flickrex.get_authorize_url(request)

      # Open the URL in your browser, authorize the app, and get the verify token
      verify = "..."
      {:ok, access} = Flickrex.fetch_access_token(flickrex, request, verify)
      flickrex = Flickrex.put_access_token(flickrex, access)

      # Test that the login was successful
      {:ok, login} = Flickr.Test.login(flickrex)

  ### Callback Verification

  Specify a callback URL when generating the request token:

      flickrex = Flickrex.new
      url = "https://example.com/check"
      {:ok, request} = Flickrex.fetch_request_token(flickrex, oauth_callback: url)
      auth_url = Flickrex.get_authorize_url(request)

  Present the `auth_url` to the user and ask them to complete the authorization
  process. Save the `request.token` and the `request.secret`.

  After following the `auth_url` and authorizing your app, the user will be re-directed to:

  ```sh
  https://example.com/check?oauth_token=FOO&oauth_verifier=BAZ
  ```

  The `oauth_token` in the URL query corresponds to the `request.token` from the
  previous step, which you will need to recall the request token `secret`.

      # use `oauth_token` to look up the request token and secret
      {:ok, access} = Flickrex.fetch_access_token(flickrex, request_token, request_secret, oauth_verifier)
      flickrex = Flickrex.put_access_token(flickrex, access)

  Finally, save `flickrex.access.token` and `flickrex.access.secret` for this
  user, which you can re-use.

  ## Re-authenticating

  Look up the `access_token` and `access_token_secret` you have saved for the
  user, and use them to generate a new client:

      flickrex = Flickrex.new |> Flickrex.put_access_token(access_token, access_token_secret)
  """

  alias Flickrex.API
  alias Flickrex.API.Auth
  alias Flickrex.Client
  alias Flickrex.Parser
  alias Flickrex.XmlParser
  alias Flickrex.Schema

  @type response :: Parser.response

  @doc """
  Performs a Flickr request.

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

  @doc """
  Creates a Flickrex client using the application config
  """
  @spec new :: Client.t
  def new do
    new(Application.get_env(:flickrex, :oauth))
  end

  @doc """
  Creates a Flickrex client using the provided config

  The accepted parameters are:

    * `:consumer_token` - Flickr API key
    * `:consumer_secret` - Flicrkr API shared secret
    * `:access_token` - Per-user access token
    * `:access_token_secret` - Per-user access token secret
  """
  @spec new(Keyword.t) :: Client.t
  defdelegate new(config), to: Client

  @doc """
  Updates a Flickrex client with a config value
  """
  @spec update(Client.t, atom, String.t) :: Client.t
  defdelegate update(client, key, value), to: Client, as: :put

  @doc """
  Adds an access token to a client
  """
  @spec put_access_token(Client.t, Schema.Access.t) :: Client.t
  def put_access_token(client, %Schema.Access{oauth_token: token, oauth_token_secret: secret}) do
    put_access_token(client, token, secret)
  end

  @doc """
  Adds an access token and secret to a client
  """
  @spec put_access_token(Client.t, String.t, String.t) :: Client.t
  def put_access_token(client, token, secret) do
    client |> Client.put(:access_token, token) |> Client.put(:access_token_secret, secret)
  end

  @doc """
  Fetches a temporary token to authenticate the user to your application

  ## Options

  * `oauth_callback` - For web apps, the URL to redirect the user to after completing the
    authorization sequence. The URL will include query params `oauth_token`
    and `oauth_verifier`. If this option is not set, the user will be presented with
    a verification code that they must present to your application manually.
  """
  @spec fetch_request_token(Client.t, Keyword.t) :: {:ok, Client.Request.t} | {:error, binary}
  def fetch_request_token(client, params \\ []) do
    Auth.fetch_request_token(client, params)
  end

  @doc """
  Generates a Flickr authorization page URL for a user

  ## Examples:

      {:ok, request} = Flickrex.fetch_request_token(flickrex)
      auth_url = Flickrex.get_authorize_url(request, perms: "delete")

  ## Options

  * `perms` - Ask for "read", "write", or "delete" privileges. Overrides the
    setting defined in your application's authentication flow.
  """
  @spec get_authorize_url(Client.Request.t, Keyword.t) :: binary
  def get_authorize_url(request_token, params \\ []) do
    Auth.get_authorize_url(request_token, params)
  end

  @doc """
  Fetches an access token from Flickr

  The function takes an existing Flickrex client, a request token struct, and a
  verify token generated by the Flickr authorization step.

  ## Examples:

      {:ok, access} = Flickrex.fetch_access_token(flickrex, token, verify)
  """
  @spec fetch_access_token(Client.t, Client.Request.t, binary) :: Schema.Access.t | {:error, term}
  defdelegate fetch_access_token(client, request_token, verify), to: API.Auth

  @doc """
  Fetches an access token from Flickr

  The function takes an existing Flickrex client, a request token and secret,
  and a verify token generated by the Flickr authorization step.
  """
  @spec fetch_access_token(Client.t, String.t, String.t, binary) :: Schema.Access.t | {:error, term}
  def fetch_access_token(client, token, secret, verify) do
    fetch_access_token(client, %Client.Request{token: token, secret: secret}, verify)
  end

  @doc """
  Makes a GET request to the Flickr REST endpoint

  ## Examples:

      {:ok, response} = Flickrex.get(flickrex, "flickr.photos.getRecent", per_page: 5)
  """
  @spec get(Client.t, binary, Keyword.t) :: response
  def get(client, method, args \\ []) do
    call(client, :get, method, args)
  end

  @doc """
  Makes a POST request to the Flickr REST endpoint

  ## Examples:

      {:ok, response} =
        Flickrex.post(flickrex, "flickr.photos.addTags",
          photo_id: photo_id, tags: "tag1,tag2")
  """
  @spec post(Client.t, binary, Keyword.t) :: response
  def post(client, method, args \\ []) do
    call(client, :post, method, args)
  end

  @spec call(Client.t, :get | :post, binary, Keyword.t) :: response
  defp call(client, http_method, method, args) do
    case API.Base.call(client, http_method, method, args) do
      {:ok, result} -> Parser.parse(result)
      result -> result
    end
  end

  @doc """
  Upload a photo to the Flickr API

  This method requires authentication with write permission.

  ## Examples:

      photo = "/path/to/photo.png"
      {:ok, response} = Flickrex.upload(flickrex, photo: photo, is_public: 0)

  ## Arguments

  * `photo` - The file to upload. <small>**(required)**</small>
  * `title` - The title of the photo.
  * `description` - A description of the photo. May contain some limited HTML.
  * `tags` - A space-seperated list of tags to apply to the photo.
  * `is_public`, `is_friend`, `is_family` - Set to 0 for no, 1 for
    yes. Specifies who can view the photo. If omitted permissions will be set to
    user's default
  * `safety_level` - Set to 1 for Safe, 2 for Moderate, or 3 for Restricted. If
    omitted or an invalid value is passed, will be set to user's default
  * `content_type` - Set to 1 for Photo, 2 for Screenshot, or 3 for Other. If
    omitted , will be set to user's default
  * `hidden` - Set to 1 to keep the photo in global search results, 2 to hide from
    public searches. If omitted, will be set based to user's default
  """
  @spec upload(Client.t, Keyword.t) :: {:ok | :error, binary}
  def upload(client, args \\ []) do
    client |> API.Base.upload_photo(args) |> photo_result()
  end

  @doc """
  Replace a photo on the Flickr API

  This method requires authentication with write permission.

  ## Examples:

      photo = "/path/to/new.png"
      {:ok, response} = Flickrex.replace(flickrex, photo: photo, photo_id: "...")


  ## Arguments

  * `photo` - The file to upload. <small>**(required)**</small>
  * `photo_id` - The ID of the photo to replace. <small>**(required)**</small>
  * `async`
  """
  @spec replace(Client.t, Keyword.t) :: {:ok | :error, binary}
  def replace(client, args \\ []) do
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
