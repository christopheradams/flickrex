defmodule Flickrex.Flickr.TestTest do
  use ExUnit.Case

  @moduletag :flickr_api

  test "test echo/1 in XML" do
    test_format(nil, %{}, "text/xml; charset=utf-8")
    test_format(:rest, %{"_content" => "rest"}, "text/xml; charset=utf-8")
  end

  test "test echo/1 in JSON" do
    test_format(:json, %{"_content" => "json"}, "application/json")
  end

  test "test echo/1 in JSON with callback" do
    extra_params = %{nojsoncallback: 0}
    test_format(:json, %{"_content" => "json"}, "text/javascript; charset=utf-8", extra_params)
    test_format(:json, %{"_content" => "json"}, "text/javascript; charset=utf-8", %{})
  end

  test "test 404" do
    {:error, resp} =
      [test: "test"]
      |> Flickrex.Flickr.Test.echo()
      |> Map.put(:parser, &Flickrex.Parsers.Rest.parse/2)
      |> Map.put(:path, "services/test")
      |> Flickrex.request()

    assert %{status_code: 404, headers: headers, body: _body} = resp

    new_headers = :hackney_headers_new.new(headers)
    content_type = :hackney_headers_new.get_value("content-type", new_headers)

    assert content_type == "text/html; charset=UTF-8"
  end

  def test_format(req_format, resp_format_content, resp_content_type, extra_params \\ nil) do
    {:ok, resp} =
      [test: "test"]
      |> Flickrex.Flickr.Test.echo()
      |> Map.put(:format, req_format)
      |> Map.update!(:extra_params, fn value ->
        case extra_params do
          nil -> value
          extra -> extra
        end
      end)
      |> Flickrex.request()

    assert %{status_code: 200, headers: headers, body: body} = resp

    new_headers = :hackney_headers_new.new(headers)
    content_type = :hackney_headers_new.get_value("content-type", new_headers)

    assert content_type == resp_content_type

    assert %{
             "format" => ^resp_format_content,
             "method" => %{"_content" => "flickr.test.echo"},
             "stat" => "ok",
             "test" => %{"_content" => "test"}
           } = body
  end
end
