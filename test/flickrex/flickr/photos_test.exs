defmodule Flickrex.Flickr.PhotosTest do
  use ExUnit.Case

  alias Flickrex.Operation

  @photo_id "8436466166"
  @secret "e2dc3b83de"

  test "get_info/1 creates a photo info operation" do
    operation = Flickrex.Flickr.Photos.get_info(photo_id: @photo_id, secret: @secret)

    assert %Operation.Rest{params: params, method: method} = operation

    assert method == "flickr.photos.getInfo"
    assert params == %{photo_id: @photo_id, secret: @secret}
  end

  test "add_tags/1 creates an add tags operation" do
    operation = Flickrex.Flickr.Photos.add_tags(photo_id: @photo_id, tags: "t1,t2")

    assert %Operation.Rest{params: params, method: method} = operation

    assert method == "flickr.photos.addTags"
    assert params == %{photo_id: @photo_id, tags: "t1,t2"}
  end

  test "get_recent/1 creates a recent photos operation" do
    operation = Flickrex.Flickr.Photos.get_recent(per_page: 5, page: 2)

    assert %Operation.Rest{params: params, method: method} = operation

    assert method == "flickr.photos.getRecent"
    assert params == %{page: 2, per_page: 5}
  end
end
