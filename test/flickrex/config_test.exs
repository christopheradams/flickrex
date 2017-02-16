defmodule Flickrex.ConfigTest do
  use ExUnit.Case

  alias Flickrex.Config

  test "new config" do
    assert %Config{} = Config.new
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
