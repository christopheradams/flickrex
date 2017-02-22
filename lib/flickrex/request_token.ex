defmodule Flickrex.RequestToken do
  @moduledoc """
  A struct to represent Flickr request token.
  """

  defstruct [:oauth_callback_confirmed, :oauth_token, :oauth_token_secret]

  @type param :: binary | nil

  @type t :: %__MODULE__{
    oauth_callback_confirmed: param,
    oauth_token: param,
    oauth_token_secret: param
  }
end
