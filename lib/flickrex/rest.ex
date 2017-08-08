defmodule Flickrex.Rest do
  @moduledoc """
  Operations on Flickr REST Service.

  ## Examples

      operation = Flickrex.Rest.get("flickr.photos.getInfo", photo_id: id)
      {:ok, resp} = Flickrex.request(operation)
  """

  alias Flickrex.Operation

  @doc """
  Creates a GET operation for the Flickr API.
  """
  def get(method, opts \\ []) do
    call("get", method, opts)
  end

  @doc """
  Creates a POST operation for the Flickr API.
  """
  def post(method, opts \\ []) do
    call("post", method, opts)
  end

  defp call(http_method, method, opts) do
    %Operation.Rest{
      http_method: http_method,
      method: method,
      params: Map.new(opts)
    }
  end
end
