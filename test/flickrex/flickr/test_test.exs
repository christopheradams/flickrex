defmodule Flickrex.Flickr.TestTest do
  use ExUnit.Case

  @moduletag :flickr_api

  test "test echo/1" do
    {:ok, resp} =
      [test: "test"]
      |> Flickrex.Flickr.Test.echo()
      |> Flickrex.request()

    assert %{status_code: 200, headers: _headers, body: body} = resp

    assert %{
             "format" => %{"_content" => "json"},
             "method" => %{"_content" => "flickr.test.echo"},
             "nojsoncallback" => %{"_content" => "1"},
             "stat" => "ok",
             "test" => %{"_content" => "test"}
           } = body
  end
end
