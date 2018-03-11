defprotocol Flickrex.Operation do
  @moduledoc """
  An operation to perform on Flickr

  This module defines a protocol for executing operations via the Flickr
  API. The modules implementing the protocol handle one service, including
  authentication, uploads, and "Rest" methods:

  - `Flickrex.Operation.Auth.AccessToken`
  - `Flickrex.Operation.Auth.RequestToken`
  - `Flickrex.Operation.Auth.AuthorizeUrl`
  - `Flickrex.Operation.Rest`
  - `Flickrex.Operation.Upload`

  The operations are created with the following modules:

  - `Flickrex.Auth`
  - `Flickrex.Rest`
  - `Flickrex.Upload`
  - `Flickrex.Flickr`

  The functions in those modules create a data structure that implements this protocol,
  which can be given to `Flickrex.request/2` to configure and perform the operation.
  """

  alias Flickrex.Config

  @spec perform(t, Config.t()) :: term
  def perform(operation, config)
end
