defmodule Flickrex.API.Auth do
  alias Flickrex.Config
  alias Flickrex.AccessToken
  alias Flickrex.RequestToken

  @oauther Application.get_env(:flickrex, :oauther) || Flickrex.OAuth

  @oauth_callback "oob"

  @end_point "https://api.flickr.com/services"
  @flickr_oauth_request_token "#{@end_point}/oauth/request_token"
  @flickr_oauth_authorize "#{@end_point}/oauth/authorize"
  @flickr_oauth_access_token "#{@end_point}/oauth/access_token"

  @rest_path_secure "#{@end_point}/rest"

  # token = Flickrex.API.Auth.get_request_token(flickrex, oauth_callback: "http://example.com")
  def get_request_token(config, params \\ []) do
    params = Keyword.merge([oauth_callback: @oauth_callback], params)
    body = request(config, :get, @flickr_oauth_request_token, params)
    token = URI.decode_query(to_string(body), %{})
    %RequestToken{oauth_callback_confirmed: token["oauth_callback_confirmed"],
                  oauth_token: token["oauth_token"],
                  oauth_token_secret: token["oauth_token_secret"]}
  end

  # auth_url = Flickrex.API.Auth.get_authorize_url(request_token, perms: "delete")
  def get_authorize_url(%RequestToken{oauth_token: oauth_token}, params \\ []) do
    query = params |> Map.new |> Map.put(:oauth_token, oauth_token) |> URI.encode_query
    uri = URI.parse(@flickr_oauth_authorize)
    URI.to_string(%{ uri | query: query})
  end

  def fetch_access_token(%Config{} = config, %RequestToken{} = request_token, oauth_verifier) do
    access_token = get_access_token(config, request_token, oauth_verifier)
    put_access_token(config, access_token)
  end

  defp get_access_token(config, request_token, oauth_verifier) do
    config = put_access_token(config, request_token)
    params = [oauth_verifier: oauth_verifier]
    body = request(config, :get, @flickr_oauth_access_token, params)
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

  def call(%Config{} = config, method, args \\ []) do
    params = Keyword.merge([method: method, format: "json", nojsoncallback: 1], args)
    body = request(config, :get, @rest_path_secure, params)
    Poison.decode!(body)
  end

  defp request(config, method, url, params) do
    result = @oauther.request(method, url, params, config.consumer_key,
      config.consumer_secret, config.access_token, config.access_token_secret)
    {:ok, {_response, _header, body}} = result
    body
  end
end
