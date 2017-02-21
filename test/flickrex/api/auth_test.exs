defmodule Flickrex.API.AuthTest do
  use ExUnit.Case

  alias Flickrex.API.Auth
  alias Flickrex.RequestToken

  test "get request token" do
    flickrex = Flickrex.new
    token = Auth.get_request_token(flickrex)
    assert Map.has_key?(token, :oauth_token)
    assert token.oauth_token == "REQUEST_TOKEN"
  end

  test "get authorize url" do
    request_token = %RequestToken{oauth_token: "OAUTH_TOKEN"}
    auth_url = Auth.get_authorize_url(request_token)
    assert auth_url == "https://api.flickr.com/services/oauth/authorize?oauth_token=OAUTH_TOKEN"
  end

  test "get authorize url with perms" do
    request_token = %RequestToken{oauth_token: "OAUTH_TOKEN"}
    auth_url = Auth.get_authorize_url(request_token, perms: "delete")
    assert auth_url == "https://api.flickr.com/services/oauth/authorize?oauth_token=OAUTH_TOKEN&perms=delete"
  end

  test "fetch access token" do
    request_token = %RequestToken{oauth_token: "OAUTH_TOKEN"}
    verifier = "VERIFIER"
    flickrex = Flickrex.new |> Auth.fetch_access_token(request_token, verifier)
    assert Map.has_key?(flickrex, :access_token)
    assert flickrex.access_token == "ACCESS_TOKEN"
  end
end
