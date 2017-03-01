defmodule Flickrex.API.Auth do
  @moduledoc """
  Provides authentication access to Flickr API.

  See `Flickrex` for more documentation.
  """

  import Flickrex.API.Base

  alias Flickrex.Config
  alias Flickrex.AccessToken
  alias Flickrex.RequestToken

  @oauth_callback "oob"

  @doc """
  Gets a temporary token to authenticate the user to your application

  ## Options

  * `oauth_callback` - For web apps, the URL to redirect the user to after completing the
    authorization sequence. The URL will include query params `oauth_token`
    and `oauth_verifier`. If this option is not set, the user will be presented with
    a verification code that they must present to your application manually.
  """
  @spec get_request_token(Config.t, Keyword.t) :: {:ok, RequestToken.t} | {:error, binary}
  def get_request_token(config, params \\ []) do
    oauth_params = Keyword.merge([oauth_callback: @oauth_callback], params)
    # Make sure the config does not have any access tokens
    config = %Flickrex.Config{consumer_key: config.consumer_key,
                              consumer_secret: config.consumer_secret}
    case request(config, :get, auth_url(:request_token), oauth_params) do
      {:ok, body} ->
        token = URI.decode_query(body, %{})
        {:ok, %RequestToken{oauth_callback_confirmed: token["oauth_callback_confirmed"],
                            oauth_token: token["oauth_token"],
                            oauth_token_secret: token["oauth_token_secret"]}}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Generates a Flickr authorization page URL for a user
  """
  @spec get_authorize_url(RequestToken.t, Keyword.t) :: binary
  def get_authorize_url(%RequestToken{oauth_token: oauth_token}, params \\ []) do
    query = params |> Map.new |> Map.put(:oauth_token, oauth_token) |> URI.encode_query
    uri = :authorize |> auth_url |>  URI.parse
    URI.to_string(%{uri | query: query})
  end

  @doc """
  Fetches an access token from Flickr and updates the config
  """
  @spec fetch_access_token(Config.t, RequestToken.t, binary) :: Config.t
  def fetch_access_token(%Config{} = config, %RequestToken{} = request_token, oauth_verifier) do
    case get_access_token(config, request_token, oauth_verifier) do
      {:error, reason} ->
        {:error, reason}
      access_token -> put_access_token(config, access_token)
    end
  end

  @spec get_access_token(Config.t, RequestToken.t, binary) :: AccessToken.t | {:error, term}
  defp get_access_token(config, request_token, oauth_verifier) do
    config = put_access_token(config, request_token)
    params = [oauth_verifier: oauth_verifier]
    case request(config, :get, auth_url(:access_token), params) do
      {:ok, body} ->
        token = URI.decode_query(body, %{})
        %AccessToken{fullname: token["fullname"],
                     oauth_token: token["oauth_token"],
                     oauth_token_secret: token["oauth_token_secret"],
                     user_nsid: token["user_nsid"],
                     username: token["username"]}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec put_access_token(Config.t, AccessToken.t | RequestToken.t) :: Config.t
  defp put_access_token(config, %{oauth_token: token, oauth_token_secret: secret}) do
    config |> Config.put(:access_token, token) |> Config.put(:access_token_secret, secret)
  end
end
