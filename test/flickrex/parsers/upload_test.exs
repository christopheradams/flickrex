defmodule Flickrex.Parsers.UploadTest do
  use ExUnit.Case

  alias Flickrex.Parsers

  @xml_headers [{"content-type", "text/xml; charset=UTF-8"}]
  @xml_doc "<?xml version='1.0'?><_/>"

  test "parse/1 parses a REST XML response" do
    response = {:ok, %{body: @xml_doc, headers: @xml_headers, status_code: 200}}
    {:ok, %{body: body}} = Parsers.Upload.parse(response)

    assert body == %{"_" => %{}}
  end
end
