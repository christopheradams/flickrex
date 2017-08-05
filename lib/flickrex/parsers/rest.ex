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
    |> extract_resp()
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
    |> get_first_tag_as_list()
    |> group_by_tag()
    |> Enum.map(&unlist_single_element/1)
    |> Enum.into(%{})
  end

  defp get_first_tag_as_list(content) do
    Enum.map(content, fn tag -> tag |> Map.to_list() |> List.first() end)
  end

  defp group_by_tag(content) do
    Enum.group_by(content, fn {k, _v} -> k end, fn {_k, v} -> v end)
  end

  defp unlist_single_element({k, v}) when length(v) == 1, do: {k, List.first(v)}
  defp unlist_single_element(kv), do: kv

  defp extract_resp(%{"rsp" => rsp}), do: rsp
  defp extract_resp(rsp), do: rsp
end
