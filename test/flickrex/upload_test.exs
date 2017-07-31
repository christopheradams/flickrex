defmodule Flickrex.UploadTest do
  use ExUnit.Case

  alias Flickrex.{Upload, Operation}

  test "upload/2 returns an Upload operation" do
    photo = "test/fixtures/photo.png"
    operation = Upload.upload(photo, is_public: 0)

    assert operation == %Operation.Upload{
      params: %{is_public: 0},
      parser: &Flickrex.Parsers.Upload.parse/1,
      path: "services/upload",
      photo: "test/fixtures/photo.png",
      service: :upload
    }
  end

  test "replace/2 returns an Upload operation to replace a photo" do
    photo = "test/fixtures/photo.jpg"
    photo_id = "PHOTO_ID"

    operation = Upload.replace(photo, photo_id: photo_id)

    assert operation == %Operation.Upload{
      params: %{photo_id: photo_id},
      parser: &Flickrex.Parsers.Upload.parse/1,
      path: "services/replace",
      photo: "test/fixtures/photo.jpg",
      service: :upload
    }
  end
end

