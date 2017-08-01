defmodule Flickrex.Schema.Access do
  @moduledoc false

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
