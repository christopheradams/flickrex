defmodule Flickrex.API.Auth do
  import Flickrex.API.Base

  alias Flickrex.Config
  alias Flickrex.AccessToken
  alias Flickrex.RequestToken

  @oauth_callback "oob"

  # token = Flickrex.API.Auth.get_request_token(flickrex, oauth_callback: "http://example.com")
  def get_request_token(config, params \\ []) do
    params = Keyword.merge([oauth_callback: @oauth_callback], params)
    body = request(config, :get, auth_url(:request_token), params)
    token = URI.decode_query(to_string(body), %{})
    %RequestToken{oauth_callback_confirmed: token["oauth_callback_confirmed"],
                  oauth_token: token["oauth_token"],
                  oauth_token_secret: token["oauth_token_secret"]}
  end

  # auth_url = Flickrex.API.Auth.get_authorize_url(request_token, perms: "delete")
  def get_authorize_url(%RequestToken{oauth_token: oauth_token}, params \\ []) do
    query = params |> Map.new |> Map.put(:oauth_token, oauth_token) |> URI.encode_query
    uri = :authorize |> auth_url |>  URI.parse
    URI.to_string(%{ uri | query: query})
  end

  def fetch_access_token(%Config{} = config, %RequestToken{} = request_token, oauth_verifier) do
    access_token = get_access_token(config, request_token, oauth_verifier)
    put_access_token(config, access_token)
  end

  defp get_access_token(config, request_token, oauth_verifier) do
    config = put_access_token(config, request_token)
    params = [oauth_verifier: oauth_verifier]
    body = request(config, :get, auth_url(:access_token), params)
    token = URI.decode_query(to_string(body), %{})
    %AccessToken{fullname: token["fullname"],
                 oauth_token: token["oauth_token"],
                 oauth_token_secret: token["oauth_token_secret"],
                 user_nsid: token["user_nsid"],
                 username: token["username"]}
  end

  defp put_access_token(auth, %{oauth_token: token, oauth_token_secret: secret}) do
    auth |> Config.put(:access_token, token) |> Config.put(:access_token_secret, secret)
  end
end
