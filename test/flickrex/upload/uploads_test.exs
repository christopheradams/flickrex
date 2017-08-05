defmodule Flickrex.Upload.UploadsTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  setup [:flickr_config]

  test "set up an upload request", %{config: config} do
    photo = "test/fixtures/photo.png"

    operation = Flickrex.Upload.upload(photo, is_public: 0)

    request = Flickrex.Operation.prepare(operation, Map.new(config))

    {:multipart, parts} = request.body

    file = Enum.find(parts, fn {:file, _, _, _} -> true; _ -> false end)

    assert file == {:file, "test/fixtures/photo.png",
                    {"form-data", [{"name", "\"photo\""},
                                   {"filename", "\"photo.png\""}]}, []}
  end

  test "upload a photo", %{config: config} do
    photo = "test/fixtures/photo.png"

    {:ok, %{body: body}} =
      photo
      |> Flickrex.Upload.upload()
      |> Flickrex.request(config)

    assert body == %{
      "photoid" => %{"_content" => "35467821184"},
      "stat" => "ok"
    }

  end

  test "replace a photo", %{config: config} do
    photo = "test/fixtures/photo.jpg"

    {:ok, %{body: body}} =
      photo
      |> Flickrex.Upload.replace(photo_id: "35467821184")
      |> Flickrex.request(config)

    assert body == %{
      "photoid" => %{
        "_content" => "35467821184",
        "originalsecret" => "cd55de71dc",
        "secret" => "ca957348bc"
      },
      "stat" => "ok"
    }
  end

  test "replace a photo with no photo specified", %{config: config} do
    photo = "test/fixtures/photo.jpg"

    {:ok, %{body: body}} =
      photo
      |> Flickrex.Upload.replace()
      |> Flickrex.request(config)

    assert body == %{
      "err" => %{
        "code" => "2",
        "msg" => "No photo specified"
      },
      "stat" => "fail"
    }
  end
end
