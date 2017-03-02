defmodule Flickrex.Client.Request do
  @moduledoc """
  A struct to represent Flickr temporary request token and secret
  """

  defstruct [:token, :secret]

  @type t :: %__MODULE__{
    token: String.t | nil,
    secret: String.t | nil
  }
end
