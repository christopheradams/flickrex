defmodule Flickrex.Rest do
  @moduledoc """
  Operations on Flickr REST Service.

  Supports all methods listed in the [Flickr API](https://www.flickr.com/services/api/) docs.

  Prefer to use the `Flickrex.Flickr` modules instead of calling these functions
  directly.

  ## Examples

      operation = Flickrex.Rest.get("flickr.photos.getInfo", photo_id: id)
      {:ok, resp} = Flickrex.request(operation)
  """

  alias Flickrex.Operation

  @typedoc "Name of the Flickr API Method"
  @type method :: Flickrex.Operation.Rest.method()

  @typedoc "Arguments for the Flickr API Method"
  @type args :: Keyword.t()

  @doc """
  Creates a GET operation for the Flickr API.
  """
  @spec get(method(), args()) :: Operation.Rest.t()
  def get(method, args \\ []) do
    call(:get, method, args)
  end

  @doc """
  Creates a POST operation for the Flickr API.
  """
  @spec post(method(), args()) :: Operation.Rest.t()
  def post(method, args \\ []) do
    call(:post, method, args)
  end

  defp call(http_method, method, args) do
    %Operation.Rest{
      http_method: http_method,
      method: method,
      params: Map.new(args)
    }
  end
end
