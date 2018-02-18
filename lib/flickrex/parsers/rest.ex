defmodule Flickrex.Parsers.Rest do
  @moduledoc false

  alias Flickrex.{Config, Request}

  @type decoder :: atom
  @type headers :: Request.HttpClient.headers()
  @type results :: {:ok, map} | {:error, term}

  @spec parse(results, Config.t()) :: results
  def parse(results, config \\ %Config{})

  def parse({:error, _} = results, _), do: results

  def parse({:ok, %{status_code: code} = response}, _) when code >= 400 do
    {:error, response}
  end

  def parse({:ok, response}, config) do
    {stat, body} = parse_content(response, config)

    {stat, %{response | body: body}}
  end

  def parse(result, _config) do
    result
  end

  defp parse_content(response, config) do
    content_type = get_content_type(response.headers)
    parse_type(response, content_type, config)
  end

  defp parse_type(response, "text/xml" <> _rest, config) do
    decode(response, config.rest_decoder)
  end

  defp parse_type(response, "application/json" <> _rest, config) do
    decode(response, config.json_decoder)
  end

  # Body has a "jsonFlickrApi(...)" callback
  defp parse_type(response, "text/javascript" <> _rest, config) do
    body = String.slice(response.body, 14..-2)
    decode(%{response | body: body}, config.json_decoder)
  end

  defp parse_type(response, _type, _config) do
    {:ok, response.body}
  end

  defp decode(response, decoder) do
    decoder.decode(response.body)
  end

  defp get_content_type(headers) do
    {_, ct} = List.keyfind(headers, "content-type", 0, List.keyfind(headers, "Content-Type", 0))
    ct
  end
end
