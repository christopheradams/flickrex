defmodule Flickrex.API.BaseTest do
  use ExUnit.Case

  import Flickrex.API.Base
  alias Flickrex.Client

  test "call get" do
    client = Client.new
    {:ok, response} = call(client, :get, "TEST", [param: "PARAM"])
    assert response == "{\"verb\":\"get\",\"param\":\"param:PARAM\",\"nojsoncallback\":1,\"method\":\"TEST\",\"format\":\"json\",\"stat\":\"ok\"}"
  end

  test "call post" do
    client = Client.new
    {:ok, response} = call(client, :post, "TEST", [param: "PARAM"])
    assert Regex.match?(~r/post/, response)
  end

  test "call error" do
    client = Client.new
    {:error, reason} = call(client, :post, "ERROR", [param: "PARAM"])
    assert reason == "Bad Request: call error"
  end

  test "request token but sign with access keys" do
    config = [consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS"]
    client = Client.new(config)
    {:error, reason} = request(client.consumer, client.access, :get, auth_url(:request_token), [oauth_callback: "oob"])
    assert Regex.match?(~r/Unauthorized/, reason)
  end

  test "request token with no oauth_callback" do
    config = [consumer_key: "CK", consumer_secret: "CS", access_token: nil, access_token_secret: nil]
    client = Client.new(config)
    {:error, reason} = request(client.consumer, client.access, :get, auth_url(:request_token), [])
    assert reason == "Bad Request: oauth_problem=parameter_absent&oauth_parameters_absent=oauth_callback"
  end

  test "request" do
    config = [consumer_key: "CK", consumer_secret: "CS", access_token: "AC", access_token_secret: "ATS"]
    client = Client.new(config)
    {:ok, body} = request(client.consumer, client.access, :method, "URL", param: "PARAM")
    assert body == "method=method&url=URL&ck=CK&cs=CS&at=AC&ats=ATS&param=PARAM"
  end

  test "request error" do
    client = Client.new
    {:error, reason} = request(client.consumer, client.access, :get, "HTTP_ERROR", [])
    assert reason == "Bad Request: service error"
  end

  test "httpc error" do
    client = Client.new
    assert_raise Flickrex.ConnectionError, fn ->
      request(client.consumer, client.access, :get, "HTTPC_ERROR", [])
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
