defmodule Flickrex.Parsers.UploadTest do
  use ExUnit.Case

  alias Flickrex.Parsers

  @xml_headers [{"content-type", "text/xml; charset=UTF-8"}]

  test "parse upload" do
    response = do_response(:upload, @xml_headers, 200)

    {:ok, %{body: body}} = Parsers.Upload.parse(response)

    assert body == {"rsp", [{"stat", "ok"}], [{"photoid", [], ["35467821184"]}]}
  end

  test "parse replace" do
    response = do_response(:replace, @xml_headers, 200)

    {:ok, %{body: body}} = Parsers.Upload.parse(response)

    assert body == {"rsp", [{"stat", "ok"}],
                    [{"photoid", [{"secret", "ca957348bc"},
                                  {"originalsecret", "cd55de71dc"}],
                      ["35467821184"]}]}
  end

  test "parse error" do
    response = do_response(:error, @xml_headers, 200)

    {:ok, %{body: body}} = Parsers.Upload.parse(response)

    assert body == {"rsp", [{"stat", "fail"}],
                    [{"err", [{"code", "2"},
                              {"msg", "No photo specified"}], []}]}
  end

  def do_response(doc, headers, status_code) do
    {:ok, %{body: fixture(doc), headers: headers, status_code: status_code}}
  end

  def fixture(doc) do
    File.read!("test/fixtures/#{doc}.xml")
  end
end
