defmodule Flickrex.Decoder.JSONTest do
  use ExUnit.Case, async: true

  alias Flickrex.Decoder

  @json_doc "{}"
  @json_parse %{}

  @ok_doc """
  {"stat": "ok"}
  """
  @ok_parse %{"stat" => "ok"}

  @error_doc """
  {"stat": "fail"}
  """
  @error_parse %{"stat" => "fail"}

  test "decode/1 decodes JSON" do
    assert Decoder.JSON.decode(@json_doc) == {:ok, @json_parse}
    assert Decoder.JSON.decode(@ok_doc) == {:ok, @ok_parse}
  end

  test "decode/1 returns an error on stat fail" do
    assert Decoder.JSON.decode(@error_doc) == {:error, @error_parse}
  end

  test "decode/1 returns an error on parse error" do
    assert Decoder.JSON.decode("") == {:error, :badarg}
  end
end
