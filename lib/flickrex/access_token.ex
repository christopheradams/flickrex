defmodule Flickrex.AccessToken do
  @moduledoc """
  A struct to represent Flickr access token.
  """

  defstruct [:fullname, :oauth_token, :oauth_token_secret, :user_nsid, :username]

  @type param :: binary | nil

  @type t :: %__MODULE__{
    fullname: param,
    oauth_token: param,
    oauth_token_secret: param,
    user_nsid: param,
    username: param
  }
end
