defmodule FlickrTest do
  use ExUnit.Case

  test "get method" do
    flickrex = Flickrex.new
    response = Flickr.Photos.get_info(flickrex, photo_id: "1")
    assert response == %{"format" => "json", "method" => "flickr.photos.getInfo",
                         "nojsoncallback" => 1, "param" => "photo_id:1", "verb" => "get"}
  end

  test "post method" do
    flickrex = Flickrex.new
    response = Flickr.Photos.add_tags(flickrex, photo_id: "1", tags: "tag1")
    assert response == %{"format" => "json", "method" => "flickr.photos.addTags",
                         "nojsoncallback" => 1, "param" => "photo_id:1,tags:tag1",
                         "verb" => "post"}
  end
end
