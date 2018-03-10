defmodule Flickrex.ConfigTest do
  use ExUnit.Case

  alias Flickrex.Config
  alias Flickrex.Support.Fixtures

  @consumer_key Fixtures.consumer_key()
  @consumer_secret Fixtures.consumer_secret()

  test "new/0 returns a new config" do
    api_config = Config.new(:api)
    assert %Flickrex.Config{url: "https://api.flickr.com/"} = api_config

    up_config = Config.new(:upload)
    assert %Flickrex.Config{url: "https://up.flickr.com/"} = up_config
  end

  test "new/1 returns a custom config" do
    url = "https://localhost:1234"
    opts = [consumer_key: @consumer_key, consumer_secret: @consumer_secret, url: url]
    config = Config.new(:api, opts)

    assert %Flickrex.Config{} = config

    assert config.consumer_key == @consumer_key
    assert config.consumer_secret == @consumer_secret
    assert config.url == url
  end
end
