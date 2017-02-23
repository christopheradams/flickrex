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

  test "call" do
    flickrex = Flickrex.new
    response = Flickrex.call(flickrex, "TEST", [param: "PARAM"])
    assert response == %{"method" => "TEST", "param" => "PARAM",
                         "format" => "json", "nojsoncallback" => 1,
                         "stat" => "ok"}
  end
end
