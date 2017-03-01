defmodule Flickrex.API.AuthTest do
  use ExUnit.Case

  alias Flickrex.API.Auth
  alias Flickrex.RequestToken

  test "get request token" do
    flickrex = Flickrex.new([consumer_key: "CT", consumer_secret: "CY"])
    {:ok, token} = Auth.get_request_token(flickrex)
    assert Map.has_key?(token, :oauth_token)
    assert token.oauth_token == "REQUEST_TOKEN"
  end

  test "get request token with access keys already set" do
    tokens = [consumer_key: "CT", consumer_secret: "CY", access_token: "AT",
              access_token_secret: "AS"]
    flickrex = Flickrex.new(tokens)
    {:ok, token} = Auth.get_request_token(flickrex)
    assert Map.has_key?(token, :oauth_token)
    assert token.oauth_token == "REQUEST_TOKEN"
  end

  test "get request token with unknown keys" do
    flickrex = Flickrex.new([consumer_key: "BAD_KEY", consumer_secret: "BAD_SECRET"])
    {:error, reason} = Auth.get_request_token(flickrex)
    assert reason == "Unauthorized: oauth_problem=consumer_key_unknown"
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

  test "fetch access token with unknown keys" do
    flickrex = Flickrex.new([consumer_key: "BAD_KEY", consumer_secret: "BAD_SECRET"])
    request_token = %RequestToken{oauth_token: "OAUTH_TOKEN"}
    verifier = "VERIFIER"
    {:error, reason} = Auth.fetch_access_token(flickrex, request_token, verifier)
    assert reason == "Unauthorized: oauth_problem=consumer_key_unknown"
  end

  test "fetch access token with bad verifier" do
    request_token = %RequestToken{oauth_token: "OAUTH_TOKEN"}
    verifier = "BAD_VERIFIER"
    {:error, reason} = Flickrex.new |> Auth.fetch_access_token(request_token, verifier)
    assert reason == "Bad Request: oauth_problem=parameter_absent&oauth_parameters_absent=oauth_token"
  end
end
