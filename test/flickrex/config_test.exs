defmodule Flickrex.ConfigTest do
  use ExUnit.Case

  alias Flickrex.Config

  test "new/0 returns a new config" do
    api_config = Config.new(:api)
    assert %Flickrex.Config{url: "https://api.flickr.com/"} = api_config

    up_config = Config.new(:upload)
    assert %Flickrex.Config{url: "https://up.flickr.com/"} = up_config
  end

  test "new/1 returns a custom config" do
    url = "https://localhost:1234"
    config = Config.new(:api, consumer_key: "TOKEN", consumer_secret: "SECRET", url: url)

    assert %Flickrex.Config{} = config

    assert config.consumer_key == "TOKEN"
    assert config.consumer_secret == "SECRET"
    assert config.url == url
  end
end
