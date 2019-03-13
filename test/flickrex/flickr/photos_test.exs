defmodule Flickrex.Flickr.PhotosTest do
  use ExUnit.Case

  alias Flickrex.{
    Flickr,
    Operation
  }

  @photo_id "8436466166"
  @secret "e2dc3b83de"

  test "get_info/1 creates a photo info operation" do
    assert ExUnit.CaptureIO.capture_io(:stderr, fn ->
             operation = Flickr.Photos.get_info(photo_id: @photo_id, secret: @secret)

             assert %Operation.Rest{params: params, method: method} = operation

             assert method == "flickr.photos.getInfo"
             assert params == %{photo_id: @photo_id, secret: @secret}
           end) =~ "is deprecated"
  end

  test "get_info/2 creates a photo info operation" do
    operation = Flickr.Photos.get_info(@photo_id, secret: @secret)

    assert %Operation.Rest{params: params, method: method} = operation

    assert method == "flickr.photos.getInfo"
    assert params == %{photo_id: @photo_id, secret: @secret}
  end

  @tag :capture_log
  test "add_tags/1 creates an add tags operation" do
    assert ExUnit.CaptureIO.capture_io(:stderr, fn ->
             operation = Flickr.Photos.add_tags(photo_id: @photo_id, tags: "t1,t2")

             assert %Operation.Rest{params: params, method: method} = operation

             assert method == "flickr.photos.addTags"
             assert params == %{photo_id: @photo_id, tags: "t1,t2"}
           end) =~ "is deprecated"
  end

  test "add_tags/3 creates an add tags operation" do
    operation = Flickr.Photos.add_tags(@photo_id, "t1,t2")

    assert %Operation.Rest{params: params, method: method} = operation

    assert method == "flickr.photos.addTags"
    assert params == %{photo_id: @photo_id, tags: "t1,t2"}
  end

  test "get_recent/1 creates a recent photos operation" do
    operation = Flickr.Photos.get_recent(per_page: 5, page: 2)

    assert %Operation.Rest{params: params, method: method} = operation

    assert method == "flickr.photos.getRecent"
    assert params == %{page: 2, per_page: 5}
  end
end
