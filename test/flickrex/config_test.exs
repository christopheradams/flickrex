defmodule Flickrex.ConfigTest do
  use ExUnit.Case

  alias Flickrex.Config

  test "new config" do
    config = Config.new
    assert Map.has_key?(config, :consumer_key)
    assert Map.has_key?(config, :consumer_secret)
    assert Map.has_key?(config, :access_token)
    assert Map.has_key?(config, :access_token_secret)
  end

  test "new config with params" do
    config = Config.new([consumer_key: "test"])
    assert config.consumer_key == "test"
  end

  test "merge config" do
    config =
      [consumer_key: "test", consumer_secret: "test"]
      |> Config.new
      |> Config.merge([consumer_key: "new"])
    assert config.consumer_key == "new"
    assert config.consumer_secret == "test"
  end

  test "put config" do
    config =
      Config.new
      |> Config.put(:consumer_key, "key")
      |> Config.put(:consumer_secret, "secret")
    assert config.consumer_key == "key"
    assert config.consumer_secret == "secret"
  end
end
