defmodule Flickrex.HTTPotionTest do
  use ExUnit.Case

  @moduletag :httpotion

  test "test echo/1 in XML" do
    test_format("", %{}, "text/xml; charset=utf-8")
  end

  test "test echo/1 in JSON" do
    test_format("json", %{"_content" => "json"}, "application/json")
  end

  def test_format(req_format, _resp_format_content, _resp_content_type) do
    config = [http_client: Flickrex.Request.HTTPotion]

    {:ok, resp} =
      [test: "test"]
      |> Flickrex.Flickr.Test.echo()
      |> Map.put(:format, req_format)
      |> Map.put(:parser, &Flickrex.Parsers.Identity.parse/1)
      |> Flickrex.request(config)

    assert %{status_code: 200, headers: _headers, body: _body} = resp

  end
end
