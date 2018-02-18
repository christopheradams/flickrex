defmodule Flickrex.Decoder do
  @moduledoc """
  Defines the specification for a REST decoder.
  """

  @type data :: String.t()
  @type result :: map()
  @type success_t :: {:ok, result()}
  @type error_t :: {:error, result()}
  @type parse_error_t :: {:error, :badarg}

  @callback decode(data()) :: success_t() | error_t() | parse_error_t()
end
