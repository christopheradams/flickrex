defmodule Flickrex.Decoder.JSON do
  @moduledoc false

  @behaviour Flickrex.Decoder

  alias Flickrex.Decoder

  @type data :: Decoder.data()
  @type result :: Decoder.result()
  @type success_t :: Decoder.success_t()
  @type error_t :: Decoder.error_t()
  @type parse_error_t :: Decoder.parse_error_t()

  @spec decode(data()) :: success_t() | error_t()
  def decode(data) do
    case Jason.decode(data) do
      {:ok, result} ->
        {stat(result), result}

      _ ->
        {:error, :badarg}
    end
  end

  defp stat(%{"stat" => "fail"}), do: :error
  defp stat(_), do: :ok
end
