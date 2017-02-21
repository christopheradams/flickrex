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
  def get_request_token(%Config{consumer_key: consumer_key, consumer_secret: consumer_secret}, params \\ []) do
    params = Keyword.merge([oauth_callback: @oauth_callback], params)
    result = @oauther.request(:get, @flickr_oauth_request_token, params, consumer_key,
      consumer_secret, nil, nil)
    {:ok, {_response, _header, body}} = result
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

  def get_access_token(%Config{consumer_key: consumer_key, consumer_secret: consumer_secret},
      %RequestToken{oauth_token: access_token, oauth_token_secret: access_token_secret},
      oauth_verifier) do
    params = [oauth_verifier: oauth_verifier]
    result = @oauther.request(:get, @flickr_oauth_access_token, params, consumer_key,
      consumer_secret, access_token, access_token_secret)
    {:ok, {_response, _header, body}} = result
    token = URI.decode_query(to_string(body), %{})
    %AccessToken{fullname: token["fullname"],
                 oauth_token: token["oauth_token"],
                 oauth_token_secret: token["oauth_token_secret"],
                 user_nsid: token["user_nsid"],
                 username: token["username"]}
  end

  def put_access_token(%Config{} = auth, %AccessToken{oauth_token: token, oauth_token_secret: secret}) do
    auth |> Config.put(:access_token, token) |> Config.put(:access_token_secret, secret)
  end

  def call(%Config{consumer_key: consumer_key, consumer_secret: consumer_secret, access_token: access_token,
                   access_token_secret: access_token_secret}, method, args \\ []) do
    params = Keyword.merge([method: method, format: "json", nojsoncallback: 1], args)
    result = @oauther.request(:get, @rest_path_secure, params, consumer_key,
      consumer_secret, access_token, access_token_secret)
    {:ok, {_response, _header, body}} = result
    Poison.decode!(body)
  end
end
