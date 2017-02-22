defmodule Flickrex.RequestToken do
  @moduledoc """
  A struct to represent Flickr request token.
  """

  defstruct [:oauth_callback_confirmed, :oauth_token, :oauth_token_secret]
end
