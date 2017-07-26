defmodule Flickrex.Operation.Auth.AccessToken do
  @moduledoc """
  Holds data necessary for an operation to request an access token.
  """

  @type t :: %__MODULE__{}

  defstruct [
    path: "services/oauth/access_token",
    request_token: nil,
    request_secret: nil,
    verifier: nil,
    service: :api,
  ]
end
