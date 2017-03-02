defmodule Flickrex.Client.Access do
  @moduledoc """
  A struct to represent Flickr access token and secret
  """

  defstruct [:token, :secret]

  @type t :: %__MODULE__{
    token: String.t | nil,
    secret: String.t | nil
  }
end
