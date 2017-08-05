defmodule Flickrex.Parsers.Rest do

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

  defp parse_body({"application", "json", _}, body) do
    Poison.decode!(body)
  end

  defp parse_body({"text", "xml", _}, body) do
    body
    |> :parsexml.parse()
    |> parse_tag()
  end

  defp parse_body(_content_type, body) do
    body
  end

  defp parse_tag({tag, attrs, content}) do
    value = parse_content(content)
    values = Enum.into(attrs, value)

    %{tag => values}
  end

  defp parse_tag(content) when is_binary(content) do
    %{"_content" => content}
  end

  defp parse_content(content) do
    content
    |> Enum.map(&parse_tag/1)
    |> Enum.map(fn e -> e |> Map.to_list() |> List.first() end)
    |> Enum.group_by(fn {k, _v} -> k end, fn {_k, v} -> v end)
    |> Enum.map(fn {k, v} when length(v) == 1 -> {k,List.first(v)}; kv -> kv end)
    |> Enum.into(%{})
  end
end
