defmodule Flickrex.Upload.UploadsTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  setup [:flickr_config]

  test "upload a photo", %{config: config} do
    photo = "test/fixtures/photo.png"

    {:ok, %{body: body}} =
      photo
      |> Flickrex.Upload.upload()
      |> Flickrex.request(config)

    expected_body = %{
      "photoid" => %{"_content" => "35467821184"},
      "stat" => "ok"
    }

    assert body == expected_body
  end

  test "replace a photo", %{config: config} do
    photo = "test/fixtures/photo.jpg"

    {:ok, %{body: body}} =
      photo
      |> Flickrex.Upload.replace(photo_id: "35467821184")
      |> Flickrex.request(config)

    expected_body = %{
      "photoid" => %{
        "_content" => "35467821184",
        "originalsecret" => "cd55de71dc",
        "secret" => "ca957348bc"
      },
      "stat" => "ok"
    }

    assert body == expected_body
  end

  test "replace a photo with no photo specified", %{config: config} do
    photo = "test/fixtures/photo.jpg"

    {:error, %{body: body}} =
      photo
      |> Flickrex.Upload.replace()
      |> Flickrex.request(config)

    expected_body = %{
      "err" => %{
        "code" => "2",
        "msg" => "No photo specified"
      },
      "stat" => "fail"
    }

    assert body == expected_body
  end
end
