defmodule FlickrexTest do
  use ExUnit.Case

  test "new client" do
    assert %Flickrex.Config{} = Flickrex.new
  end

  test "update config" do
    flickrex = Flickrex.new |> Flickrex.config([consumer_key: "test"])
    assert flickrex.consumer_key == "test"
  end
end
