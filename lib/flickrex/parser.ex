defmodule Flickrex.Parser do
  @moduledoc false

  @type response :: {:ok, map} | {:error, binary}

  @spec parse(binary | map) :: response
  def parse(response) when is_binary(response) do
    response |> Poison.decode! |> parse
  end

  def parse(%{"stat" => "fail"} = response) do
    {:error, response["message"]}
  end

  def parse(%{"stat" => "ok"} = response) do
    {:ok, Map.delete(response, "stat")}
  end
end
