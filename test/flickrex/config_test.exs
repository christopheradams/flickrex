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
    config = Config.new([consumer_key: "test"]) |> Config.merge([consumer_key: "new"])
    assert config.consumer_key == "new"
  end

  test "put config" do
    config = Config.new |> Config.put(:consumer_key, "test")
    assert config.consumer_key == "test"
  end
end
