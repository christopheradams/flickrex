defmodule Flickrex.Parsers.Rest do
  @moduledoc false

  @type response :: {:ok, map} | {:error, term}

  @spec parse(response) :: response
  def parse({:ok, resp}) do
    parsed_body = parse_body(resp)
    {:ok, %{resp | body: parsed_body}}
  end

  def parse(val), do: val

  @spec parse_status(response) :: response
  def parse_status({:ok, resp}) do
    parsed_resp = %{resp | body: parse_body(resp)}
    code_ok = parsed_resp.status_code == 200
    stat_ok = parsed_resp.body["stat"] == "ok"

    case code_ok && stat_ok do
      true ->
        {:ok, parsed_resp}

      false ->
        {:error, parsed_resp}
    end
  end

  def parse_status(val), do: val

  defp parse_body(%{headers: headers, body: body}) do
    # TODO: Replace hackney usage.
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
    |> group_by_tag()
    |> Enum.map(&unlist_single_element/1)
    |> Enum.into(%{})
  end

  defp group_by_tag(content) do
    Enum.group_by(content, &hd(Map.keys(&1)), &hd(Map.values(&1)))
  end

  defp unlist_single_element({k, v}) when length(v) == 1, do: {k, List.first(v)}
  defp unlist_single_element(kv), do: kv

  defp extract_resp(%{"rsp" => rsp}), do: rsp
  defp extract_resp(rsp), do: rsp
end
