defmodule FlickrexTest do
  use ExUnit.Case

  alias Flickrex.Client
  alias Flickrex.Schema

  test "new client" do
    flickrex = Flickrex.new
    assert Client.config(flickrex) == Application.get_env(:flickrex, :oauth)
  end

  test "new client with params" do
    flickrex = Flickrex.new(consumer_key: "CK")
    assert flickrex.consumer.key == "CK"
  end

  test "update client" do
    flickrex = Flickrex.new |> Flickrex.update(:consumer_key, "CK")
    assert flickrex.consumer.key == "CK"
  end

  test "add access to client" do
    access = %Schema.Access{oauth_token: "TOKEN", oauth_token_secret: "SECRET"}
    flickrex = Flickrex.new |> Flickrex.put_access_token(access)
    assert flickrex.access.token == access.oauth_token
    assert flickrex.access.secret == access.oauth_token_secret
  end

  test "add access tokens to client" do
    access_token = "TOKEN"
    access_token_secret = "SECRET"
    flickrex = Flickrex.new |> Flickrex.put_access_token(access_token, access_token_secret)
    assert flickrex.access.token == access_token
    assert flickrex.access.secret == access_token_secret
  end

  test "fetch access token with request token and secret" do
    token = "OAUTH_TOKEN"
    secret = "OAUTH_SECRET"
    verifier = "VERIFIER"
    flickrex = Flickrex.new
    {:ok, access} = Flickrex.fetch_access_token(flickrex, token, secret, verifier)
    assert Map.has_key?(access, :oauth_token)
    assert access.oauth_token == "ACCESS_TOKEN"
    assert access.oauth_token_secret == "ACCESS_TOKEN_SECRET"
  end

  test "get authorize url" do
    request_token = %Client.Request{token: "OAUTH_TOKEN"}
    auth_url = Flickrex.get_authorize_url(request_token)
    assert auth_url == "https://api.flickr.com/services/oauth/authorize?oauth_token=OAUTH_TOKEN"
  end

  test "get authorize url with perms" do
    request_token = %Client.Request{token: "OAUTH_TOKEN"}
    auth_url = Flickrex.get_authorize_url(request_token, perms: "delete")
    assert auth_url == "https://api.flickr.com/services/oauth/authorize?oauth_token=OAUTH_TOKEN&perms=delete"
  end

  test "get" do
    flickrex = Flickrex.new
    response = Flickrex.get(flickrex, "TEST", [param: "PARAM"])
    expected = {:ok, %{"method" => "TEST", "param" => "param:PARAM",
                       "format" => "json", "nojsoncallback" => 1,
                       "verb" => "get"}}
    assert response == expected
  end

  test "post" do
    flickrex = Flickrex.new
    response = Flickrex.post(flickrex, "TEST", [param: "PARAM"])
    assert response == {:ok, %{"method" => "TEST", "param" => "param:PARAM",
                               "format" => "json", "nojsoncallback" => 1,
                               "verb" => "post"}}
  end

  test "error" do
    flickrex = Flickrex.new
    response = Flickrex.post(flickrex, "ERROR", [param: "PARAM"])
    assert response == {:error, "Bad Request: call error"}
  end

  test "upload photo" do
    flickrex = Flickrex.new
    photo = "upload.png"
    response = Flickrex.upload(flickrex, photo: photo)

    assert response == {:ok, [{"photoid", [], ["98765432109"]}]}
  end

  test "replace photo" do
    flickrex = Flickrex.new
    photo = "replace.png"
    response = Flickrex.replace(flickrex, photo: photo, photo_id: "98765432109")

    assert response ==
    {:ok, [{"photoid", [{"secret", "3f2ec5297e"}, {"originalsecret", "4b728a2949"}],
              ["98765432109"]}]}
  end

  test "replace no photo specified" do
    flickrex = Flickrex.new
    photo = "replace.png"
    response = Flickrex.replace(flickrex, photo: photo, photo_id: nil)

    assert response ==
      {:error, [{"err", [{"code", "2"}, {"msg", "No photo specified"}], []}]}
  end
end
