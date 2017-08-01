defmodule Flickrex.Parsers.Upload do

  @moduledoc false

  def parse({:ok, resp}) do
    parsed_body = parse_body(resp)
    {:ok, %{resp | body: parsed_body}}
  end

  def parse(val), do: val

  defp parse_body(%{headers: headers, body: body}) do
    content_type = :hackney_headers.parse("content-type", headers)
    parse_body(content_type, body)
  end

  defp parse_body({"text", "xml", _}, body) do
    :parsexml.parse(body)
  end

  defp parse_body(_content_type, body) do
    body
  end
end
