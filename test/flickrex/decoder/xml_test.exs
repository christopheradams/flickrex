defmodule Flickrex.Decoder.XMLTest do
  use ExUnit.Case, async: true

  alias Flickrex.Decoder

  @xml_doc "<?xml version='1.0'?><_/>"
  @xml_parse %{"_" => %{}}

  @ok_doc """
  <?xml version="1.0" encoding="utf-8" ?><rsp stat="ok"></rsp>
  """
  @ok_parse %{"stat" => "ok"}

  @error_doc """
  <?xml version="1.0" encoding="utf-8" ?> <rsp stat="fail"> </rsp>
  """
  @error_parse %{"stat" => "fail"}

  test "decode/1 decodes XML" do
    assert Decoder.XML.decode(@xml_doc) == {:ok, @xml_parse}
    assert Decoder.XML.decode(@ok_doc) == {:ok, @ok_parse}
  end

  test "decode/1 returns an error on stat fail" do
    assert Decoder.XML.decode(@error_doc) == {:error, @error_parse}
  end

  test "decode/1 returns an error on parse error" do
    assert Decoder.XML.decode("") == {:error, :badarg}
  end
end
