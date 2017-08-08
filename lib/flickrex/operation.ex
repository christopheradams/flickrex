defprotocol Flickrex.Operation do
  def prepare(operation, config)
  def perform(operation, request)
end
