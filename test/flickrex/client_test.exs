defmodule Flickrex.ClientTest do
  use ExUnit.Case

  alias Flickrex.Client

  test "new client" do
    client = Client.new
    assert Map.has_key?(client, :consumer)
    assert Map.has_key?(client, :access)
  end

  test "new client with config" do
    config = [consumer_key: "CK", consumer_secret: "CS",
              access_token: "AT", access_token_secret: "AS"]
    client = Client.new(config)
    assert client.consumer.key == config[:consumer_key]
    assert client.consumer.secret == config[:consumer_secret]
    assert client.access.token == config[:access_token]
    assert client.access.secret == config[:access_token_secret]
  end

  test "client config" do
    config = [consumer_key: "CK", consumer_secret: "CS",
              access_token: "AT", access_token_secret: "AS"]
    assert config == config |> Client.new |> Client.config
  end

  test "get client config" do
    client = Client.new(consumer_key: "CK")
    assert Client.get(client, :consumer_key) == "CK"
  end

  test "put client config" do
    client = Client.new(consumer_key: "CK") |> Client.put(:consumer_key, "NEW")
    assert client.consumer.key == "NEW"
  end
end
