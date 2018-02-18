defmodule Flickrex.Decoder.XML do
  @moduledoc false

  @behaviour Flickrex.Decoder

  alias Flickrex.Decoder

  @type data :: Decoder.data()
  @type result :: Decoder.result()
  @type success_t :: Decoder.success_t()
  @type error_t :: Decoder.error_t()

  @spec decode(data()) :: success_t() | error_t()
  def decode(data) do
    result = parse_data(data)
    {stat(result), result}
  rescue
    _ -> {:error, :badarg}
  end

  defp stat(%{"stat" => "fail"}), do: :error
  defp stat(_), do: :ok

  defp parse_data(data) do
    data
    |> :parsexml.parse()
    |> parse_tag()
    |> extract_resp()
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
