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

  test "upload photo" do
    client = Client.new
    photo = "upload.png"
    assert {:ok, _body} = upload_photo(client, photo: photo)
  end

  test "replace photo" do
    client = Client.new
    photo = "replace.png"
    assert {:ok, _body} = replace_photo(client, photo: photo, photo_id: "98765432109")
  end

  test "replace no photo specified" do
    client = Client.new
    photo = "replace.png"
    assert {:ok, _body} = replace_photo(client, photo: photo, photo_id: nil)
  end

  test "upload photo error" do
    client = Client.new
    photo = "error.png"
    assert_raise Flickrex.ConnectionError, fn ->
      {:error, _reason} = upload_photo(client, photo: photo)
    end
  end

  test "replace photo error" do
    client = Client.new
    photo = "error.png"
    photo_id = "1234567890"
    assert_raise Flickrex.ConnectionError, fn ->
      {:error, _reason} = upload_photo(client, photo: photo, photo_id: photo_id)
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

  test "upload photo URL" do
    assert upload_photo_url() == "https://up.flickr.com/services/upload/"
  end

  test "replace photo URL" do
    assert replace_photo_url() == "https://up.flickr.com/services/replace/"
  end
end
