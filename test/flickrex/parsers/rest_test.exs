defmodule Flickrex.Parsers.RestTest do
  use ExUnit.Case

  import Flickrex.Support.Fixtures

  alias Flickrex.Parsers

  @json_headers [{"Content-Type", "application/json; charset=utf-8"}]
  @html_headers [{"Content-Type", "text/html; charset=utf-8"}]
  @xml_headers [{"Content-Type", "text/xml; charset=utf-8"}]

  @json_doc "{}"
  @html_doc "<!DOCTYPE html><html></html>"
  @xml_doc "<?xml version='1.0'?><_/>"

  @rest_objects [
    {
      ~S(<foo bar="baz" />),
      ~S({"foo": {"bar": "baz"}})
    },
    {
      ~S(<foo bar="baz"> <woo yay="hoopla" /> </foo>),
      ~S({"foo": {"bar": "baz", "woo": {"yay": "hoopla"}}})
    },
    {
      ~S(<foo>text here!</foo>),
      ~S({"foo": {"_content": "text here!"}})
    },
    {
      ~S(<outer> <photo id="1" /> <photo id="2" /> </outer>),
      ~S({"outer": {"photo": [{"id": "1"}, {"id": "2"}]}})
    },
    {
      ~S(<rsp stat="ok"> <photo id="1"> <title>Title</title> </photo> </rsp>),
      ~S({"stat": "ok", "photo": {"id": "1", "title": {"_content": "Title"}}})
    }
  ]

  test "compare REST XML and JSON responses parsing" do
    Enum.each(@rest_objects, fn {xml_doc, json_doc} ->
      json_resp = {:ok, %{body: json_doc, headers: @json_headers, status_code: 200}}
      xml_resp = {:ok, %{body: xml_doc, headers: @xml_headers, status_code: 200}}

      {:ok, %{body: json_body}} = Parsers.Rest.parse(json_resp)
      {:ok, %{body: xml_body}} = Parsers.Rest.parse(xml_resp)

      assert json_body == xml_body
    end)
  end

  test "parse/1 parses a Rest JSON response" do
    response = {:ok, %{body: @json_doc, headers: @json_headers, status_code: 200}}

    {:ok, %{body: body}} = Parsers.Rest.parse(response)

    assert body == %{}

    assert {:ok, %{body: body, headers: @json_headers, status_code: 200}}
  end

  test "parse/1 does not parse html bodies" do
    response = {:ok, %{body: @html_doc, headers: @html_headers, status_code: 200}}
    {:ok, %{body: body}} = Parsers.Rest.parse(response)

    assert body == @html_doc
  end

  test "parse/1 returns an error for 404 response" do
    response = {:ok, %{body: @html_doc, headers: @html_headers, status_code: 404}}
    {:error, %{body: body}} = Parsers.Rest.parse(response)

    assert body == @html_doc
  end

  test "parse/1 parses a REST XML response" do
    response = {:ok, %{body: @xml_doc, headers: @xml_headers, status_code: 200}}
    {:ok, %{body: body}} = Parsers.Rest.parse(response)

    assert body == %{"_" => %{}}
  end

  test "parse/1 passes errors through" do
    response = {:error, %{reason: :error}}

    assert Parsers.Rest.parse(response) == response
  end

  test "parse null" do
    response = do_response(:null, @json_headers, 200)

    {:ok, %{body: body}} = Parsers.Rest.parse(response)

    assert body == %{"stat" => "ok"}
  end

  test "parse fail" do
    response = do_response(:fail, @json_headers, 200)

    {:error, %{body: body}} = Parsers.Rest.parse(response)

    expected_body = %{
      "stat" => "fail",
      "code" => 112,
      "message" => "Method \"flickr.fakeMethod\" not found"
    }

    assert body == expected_body
  end

  test "parse photo" do
    response = do_response(:photo, @json_headers, 200)

    {:ok, %{body: body}} = Parsers.Rest.parse(response)

    assert body["photo"]["id"] == "8436466166"
    assert body["photo"]["title"] == %{"_content" => "Skies over Boston"}
  end

  test "parse photos" do
    response = do_response(:photos, @json_headers, 200)

    {:ok, %{body: body}} = Parsers.Rest.parse(response)

    assert body["photos"]["perpage"] == 2
    assert length(body["photos"]["photo"]) == 2
  end

  test "parse method" do
    response = do_response(:method, @json_headers, 200)

    {:ok, %{body: body}} = Parsers.Rest.parse(response)

    assert Map.keys(body) == ["arguments", "errors", "method", "stat"]
    assert body["arguments"]["argument"] |> List.first() |> Map.has_key?("name")
  end

  def do_response(doc, headers, status_code) do
    {:ok, %{body: fixture(doc), headers: headers, status_code: status_code}}
  end
end
