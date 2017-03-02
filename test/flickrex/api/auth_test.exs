defmodule Flickrex.API.AuthTest do
  use ExUnit.Case

  alias Flickrex.API.Auth
  alias Flickrex.Client

  test "fetch request token" do
    client = Client.new([consumer_key: "CT", consumer_secret: "CY"])
    {:ok, request} = Auth.fetch_request_token(client)
    assert Map.has_key?(request, :token)
    assert request.token == "REQUEST_TOKEN"
  end

  test "fetch request token with access keys already set" do
    config = [consumer_key: "CT", consumer_secret: "CY", access_token: "AT",
              access_token_secret: "AS"]
    client = Client.new(config)
    {:ok, request} = Auth.fetch_request_token(client)
    assert Map.has_key?(request, :token)
    assert request.token == "REQUEST_TOKEN"
    assert request.secret == "REQUEST_TOKEN_SECRET"
  end

  test "fetch request token with unknown keys" do
    client = Client.new([consumer_key: "BAD_KEY", consumer_secret: "BAD_SECRET"])
    {:error, reason} = Auth.fetch_request_token(client)
    assert reason == "Unauthorized: oauth_problem=consumer_key_unknown"
  end

  test "get authorize url" do
    request_token = %Client.Request{token: "OAUTH_TOKEN"}
    auth_url = Auth.get_authorize_url(request_token)
    assert auth_url == "https://api.flickr.com/services/oauth/authorize?oauth_token=OAUTH_TOKEN"
  end

  test "get authorize url with perms" do
    request_token = %Client.Request{token: "OAUTH_TOKEN"}
    auth_url = Auth.get_authorize_url(request_token, perms: "delete")
    assert auth_url == "https://api.flickr.com/services/oauth/authorize?oauth_token=OAUTH_TOKEN&perms=delete"
  end

  test "fetch access token" do
    request_token = %Client.Request{token: "OAUTH_TOKEN"}
    verifier = "VERIFIER"
    client = Client.new
    {:ok, access} = Auth.fetch_access_token(client, request_token, verifier)
    assert Map.has_key?(access, :oauth_token)
    assert access.oauth_token == "ACCESS_TOKEN"
    assert access.oauth_token_secret == "ACCESS_TOKEN_SECRET"
  end

  test "get an access token with unknown keys" do
    client = Client.new([consumer_key: "BAD_KEY", consumer_secret: "BAD_SECRET"])
    request_token = %Client.Request{token: "OAUTH_TOKEN"}
    verifier = "VERIFIER"
    {:error, reason} = Auth.fetch_access_token(client, request_token, verifier)
    assert reason == "Unauthorized: oauth_problem=consumer_key_unknown"
  end

  test "fetch access token with bad verifier" do
    request_token = %Client.Request{token: "OAUTH_TOKEN"}
    verifier = "BAD_VERIFIER"
    {:error, reason} = Client.new |> Auth.fetch_access_token(request_token, verifier)
    assert reason == "Bad Request: oauth_problem=parameter_absent&oauth_parameters_absent=oauth_token"
  end
end
