defmodule FlickrexTest do
  use ExUnit.Case

  test "new client" do
    flickrex = Flickrex.new
    assert Map.has_key?(flickrex, :consumer_key)
    assert Map.has_key?(flickrex, :consumer_secret)
    assert Map.has_key?(flickrex, :access_token)
    assert Map.has_key?(flickrex, :access_token_secret)
  end

  test "new client with config" do
    flickrex =
      [consumer_key: "test", consumer_secret: "test"]
      |> Flickrex.new
      |> Flickrex.config([consumer_key: "new"])
    assert flickrex.consumer_key == "new"
    assert flickrex.consumer_secret == "test"
  end

  test "update config" do
    flickrex = Flickrex.new |> Flickrex.config([consumer_key: "test"])
    assert flickrex.consumer_key == "test"
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
end
