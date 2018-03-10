defmodule Flickrex.URLTest do
  use ExUnit.Case

  alias Flickrex.URL

  import Flickrex.Support.Fixtures

  @user_id access_token(:user_nsid)

  setup_all do
    sizes_file = "test/fixtures/sizes.json"
    photo_file = "test/fixtures/photo.json"
    photo = photo_file |> File.read!() |> Jason.decode!() |> get_in(["photo"])

    sizes =
      sizes_file
      |> File.read!()
      |> Jason.decode!()
      |> get_in(["sizes", "size"])
      |> Enum.into(%{}, fn s -> {s["label"], s["source"]} end)

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
    assert URL.url_profile(@user_id) == "https://www.flickr.com/people/#{@user_id}/"
  end

  test "url_photostream" do
    assert URL.url_photostream(@user_id) == "https://www.flickr.com/photos/#{@user_id}/"
  end

  test "url_photopage" do
    expected_url = "https://www.flickr.com/photos/#{@user_id}/99999999999"
    assert URL.url_photopage(@user_id, "99999999999") == expected_url
  end

  test "url_photosets" do
    assert URL.url_photosets(@user_id) == "https://www.flickr.com/photos/#{@user_id}/sets/"
  end

  test "url_photoset" do
    expected_url = "https://www.flickr.com/photos/#{@user_id}/sets/99999999999"
    assert URL.url_photoset(@user_id, "99999999999") == expected_url
  end
end
