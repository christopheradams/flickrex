defmodule Flickrex.Rest.MethodsTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  setup [:flickr_config]

  test "request photo info", %{config: opts} do
    photo_id = "8436466166"
    method = "flickr.photos.getInfo"

    operation = Flickrex.Rest.get(method, photo_id: photo_id)

    {:ok, response} = Flickrex.request(operation, opts)

    assert get_in(response.body, ["photo", "id"]) == photo_id
  end

  test "request fake method", %{config: opts} do
    method = "flickr.fakeMethod"

    operation = Flickrex.Rest.get(method)

    assert {:error, response} = Flickrex.request(operation, opts)

    assert response.body == %{
      "stat" => "fail",
      "code" => 112,
      "message" => "Method \"flickr.fakeMethod\" not found"
    }
  end
end
