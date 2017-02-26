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
    flickrex = Flickrex.new([consumer_key: "test"])
    assert flickrex.consumer_key == "test"
  end

  test "update config" do
    flickrex = Flickrex.new |> Flickrex.config([consumer_key: "test"])
    assert flickrex.consumer_key == "test"
  end

  test "get" do
    flickrex = Flickrex.new
    response = Flickrex.get(flickrex, "TEST", [param: "PARAM"])
    assert response == %{"method" => "TEST", "param" => "param:PARAM",
                         "format" => "json", "nojsoncallback" => 1,
                         "verb" => "get"}
  end

  test "post" do
    flickrex = Flickrex.new
    response = Flickrex.post(flickrex, "TEST", [param: "PARAM"])
    assert response == %{"method" => "TEST", "param" => "param:PARAM",
                         "format" => "json", "nojsoncallback" => 1,
                         "verb" => "post"}
  end
end
