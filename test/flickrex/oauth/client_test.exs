defmodule Flickrex.OAuth.ClientTest do
  use ExUnit.Case

  import Flickrex.OAuth.Client

  @moduletag :flickr_api
  @rest_url Flickrex.API.Base.rest_url()

  test "test echo" do
    f = Flickrex.new
    params = ([method: "flickr.test.echo", format: "json", nojsoncallback: 1])
    response = request(:get, @rest_url, params, f.consumer.key, f.consumer.secret,
      f.access.token, f.access.secret)
    {:ok, {_, _, body}} = response
    echo = IO.iodata_to_binary(body)
    assert echo =~ "flickr.test.echo"
    assert echo =~ "\"stat\":\"ok\""
  end
end
