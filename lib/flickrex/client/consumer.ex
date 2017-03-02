defmodule Flickrex.Client.Consumer do
  @moduledoc """
  A struct to represent Flickr consumer key and secret
  """

  defstruct [:key, :secret]

  @type t :: %__MODULE__{
    key: String.t | nil,
    secret: String.t | nil
  }
end
