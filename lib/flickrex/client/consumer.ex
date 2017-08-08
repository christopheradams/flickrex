defmodule Flickrex.Client.Consumer do
  @moduledoc false

  defstruct [:key, :secret]

  @type t :: %__MODULE__{
    key: String.t | nil,
    secret: String.t | nil
  }
end
