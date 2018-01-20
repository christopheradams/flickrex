defprotocol Flickrex.Operation do
  alias Flickrex.{Config, Request}

  @spec prepare(t, Config.t()) :: Request.t()
  def prepare(operation, config)

  @spec perform(t, Request.t()) :: term
  def perform(operation, request)
end
