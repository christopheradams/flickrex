defmodule Flickrex.Parser do
  @moduledoc """
  Parsers Flickr API JSON responses.
  """

  @spec parse(binary | map) :: {:error, binary} | map
  def parse(response) when is_binary(response) do
    response |> Poison.decode! |> parse
  end

  def parse(%{"stat" => "fail"} = response) do
    {:error, response["message"]}
  end

  def parse(%{"stat" => "ok"} = response) do
    Map.delete(response, "stat")
  end
end
