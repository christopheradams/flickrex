defmodule Flickrex.Parsers.IdentityTest do
  use ExUnit.Case

  alias Flickrex.Parsers

  @json_headers [{"content-type", "application/json; charset=utf-8"}]
  @json_doc "{}"

  test "parse/1 returns identical value" do
    response = {:ok, %{body: @json_doc, headers: @json_headers, status_code: 200}}

    assert Parsers.Identity.parse(response) == response
  end
end
