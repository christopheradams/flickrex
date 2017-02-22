defmodule Flickrex.AccessToken do
  @moduledoc """
  A struct to represent Flickr access token.
  """

  defstruct [:fullname, :oauth_token, :oauth_token_secret, :user_nsid, :username]
end
