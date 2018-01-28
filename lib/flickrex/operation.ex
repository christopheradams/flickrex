defprotocol Flickrex.Operation do
  alias Flickrex.Config

  @spec perform(t, Config.t()) :: term
  def perform(operation, request)
end
