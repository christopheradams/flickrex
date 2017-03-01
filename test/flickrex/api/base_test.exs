defmodule Flickrex.API.BaseTest do
  use ExUnit.Case

  import Flickrex.API.Base

  test "call get" do
    flickrex = Flickrex.new
    {:ok, response} = call(flickrex, :get, "TEST", [param: "PARAM"])
    assert response == "{\"verb\":\"get\",\"param\":\"param:PARAM\",\"nojsoncallback\":1,\"method\":\"TEST\",\"format\":\"json\",\"stat\":\"ok\"}"
  end

  test "call post" do
    flickrex = Flickrex.new
    {:ok, response} = call(flickrex, :post, "TEST", [param: "PARAM"])
    assert Regex.match?(~r/post/, response)
  end

  test "call error" do
    flickrex = Flickrex.new
    {:error, reason} = call(flickrex, :post, "ERROR", [param: "PARAM"])
    assert reason == "Bad Request: call error"
  end

  test "request token but sign with access keys" do
    config = [consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS"]
    flickrex = Flickrex.new(config)
    {:error, reason} = request(flickrex, :get, auth_url(:request_token), [oauth_callback: "oob"])
    assert Regex.match?(~r/Unauthorized/, reason)
  end

  test "request token with no oauth_callback" do
    config = [consumer_key: "CK", consumer_secret: "CS", access_token: nil, access_token_secret: nil]
    flickrex = Flickrex.new(config)
    {:error, reason} = request(flickrex, :get, auth_url(:request_token), [])
    assert reason == "Bad Request: oauth_problem=parameter_absent&oauth_parameters_absent=oauth_callback"
  end

  test "request" do
    config = [consumer_key: "CK", consumer_secret: "CS", access_token: "AC", access_token_secret: "ATS"]
    flickrex = Flickrex.new(config)
    {:ok, body} = request(flickrex, :method, "URL", param: "PARAM")
    assert body == "method=method&url=URL&ck=CK&cs=CS&at=AC&ats=ATS&param=PARAM"
  end

  test "request error" do
    flickrex = Flickrex.new
    {:error, reason} = request(flickrex, :get, "HTTP_ERROR", [])
    assert reason == "Bad Request: service error"
  end

  test "httpc error" do
    flickrex = Flickrex.new
    assert_raise Flickrex.ConnectionError, fn ->
      request(flickrex, :get, "HTTPC_ERROR", [])
    end
  end

  test "rest URL" do
    assert rest_url() == "https://api.flickr.com/services/rest"
  end

  test "oauth URL" do
    assert auth_url(:request_token) == "https://api.flickr.com/services/oauth/request_token"
    assert auth_url(:authorize) == "https://api.flickr.com/services/oauth/authorize"
    assert auth_url(:access_token) == "https://api.flickr.com/services/oauth/access_token"
  end

  test "request URL" do
    assert request_url("test") == "https://api.flickr.com/services/test"
  end
end
