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
  @spec get_request_token(Config.t, Keyword.t) :: RequestToken.t
  def get_request_token(config, params \\ []) do
    params = Keyword.merge([oauth_callback: @oauth_callback], params)
    body = request(config, :get, auth_url(:request_token), params)
    token = URI.decode_query(body, %{})
    %RequestToken{oauth_callback_confirmed: token["oauth_callback_confirmed"],
                  oauth_token: token["oauth_token"],
                  oauth_token_secret: token["oauth_token_secret"]}
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
    access_token = get_access_token(config, request_token, oauth_verifier)
    put_access_token(config, access_token)
  end

  @spec get_access_token(Config.t, RequestToken.t, binary) :: AccessToken.t
  defp get_access_token(config, request_token, oauth_verifier) do
    config = put_access_token(config, request_token)
    params = [oauth_verifier: oauth_verifier]
    body = request(config, :get, auth_url(:access_token), params)
    token = URI.decode_query(body, %{})
    %AccessToken{fullname: token["fullname"],
                 oauth_token: token["oauth_token"],
                 oauth_token_secret: token["oauth_token_secret"],
                 user_nsid: token["user_nsid"],
                 username: token["username"]}
  end

  @spec put_access_token(Config.t, AccessToken.t | RequestToken.t) :: Config.t
  defp put_access_token(config, %{oauth_token: token, oauth_token_secret: secret}) do
    config |> Config.put(:access_token, token) |> Config.put(:access_token_secret, secret)
  end
end
