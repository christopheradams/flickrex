defmodule Flickrex.Client.Request do
  @moduledoc false

  defstruct [:token, :secret]

  @type t :: %__MODULE__{
    token: String.t | nil,
    secret: String.t | nil
  }
end
