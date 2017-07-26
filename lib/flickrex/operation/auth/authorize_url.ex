defmodule Flickrex.Operation.Auth.AuthorizeUrl do
  @moduledoc """
  Holds data necessary for an operation to get an authorization URL.
  """

  @type t :: %__MODULE__{}

  defstruct [
    path: "services/oauth/authorize",
    oauth_token: nil,
    params: %{},
    service: :api,
  ]
end
