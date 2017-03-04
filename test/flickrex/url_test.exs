defmodule Flickrex.URLTest do
  use ExUnit.Case

  alias Flickrex.URL

  setup_all do
    sizes_file = "test/fixtures/sizes.json"
    photo_file = "test/fixtures/photo.json"
    photo = photo_file |> File.read! |> Poison.decode! |> get_in(["photo"])
    sizes = sizes_file |> File.read! |> Poison.decode! |> get_in(["sizes", "size"]) |> Enum.into(%{}, fn s -> {s["label"], s["source"]} end)
    {:ok, [photo: photo, sizes: sizes]}
  end

  test "url", context do
    assert URL.url(context[:photo]) == context[:sizes]["Medium"]
  end

  test "url_b", context do
    assert URL.url_b(context[:photo]) == context[:sizes]["Large"]
  end

  test "url_m", context do
    assert URL.url_m(context[:photo]) == context[:sizes]["Small"]
  end

  test "url_o", context do
    assert URL.url_o(context[:photo]) == context[:sizes]["Original"]
  end

  test "url_s", context do
    assert URL.url_s(context[:photo]) == context[:sizes]["Square"]
  end

  test "url_t", context do
    assert URL.url_t(context[:photo]) == context[:sizes]["Thumbnail"]
  end

  test "url_z", context do
    assert URL.url_z(context[:photo]) == context[:sizes]["Medium 640"]
  end

  test "url_profile" do
    assert URL.url_profile("USER_ID") == "https://www.flickr.com/people/USER_ID/"
  end

  test "url_photostream" do
    assert URL.url_photostream("USER_ID") == "https://www.flickr.com/photos/USER_ID/"
  end

  test "url_photopage" do
    assert URL.url_photopage("USER_ID", "PHOTO_ID") == "https://www.flickr.com/photos/USER_ID/PHOTO_ID"
  end

  test "url_photosets" do
    assert URL.url_photosets("USER_ID") == "https://www.flickr.com/photos/USER_ID/sets/"
  end

  test "url_photoset" do
    assert URL.url_photoset("USER_ID", "PHOTOSET_ID") == "https://www.flickr.com/photos/USER_ID/sets/PHOTOSET_ID"
  end
end
