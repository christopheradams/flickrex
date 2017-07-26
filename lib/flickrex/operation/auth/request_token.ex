defmodule Flickrex.Operation.Auth.RequestToken do
  @moduledoc """
  Holds data necessary for an operation to request a temporary token.
  """

  @oauth_callback "oob"

  @type t :: %__MODULE__{}

  defstruct [
    path: "services/oauth/request_token",
    params: %{oauth_callback: @oauth_callback},
    service: :api
  ]
end

