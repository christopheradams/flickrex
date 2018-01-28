defmodule Flickrex.Request do
  @moduledoc """
  Makes requests to Flickr.
  """

  alias __MODULE__, as: Request
  alias Flickrex.Config
  alias Flickrex.Request.HttpClient

  @type t :: %Request{
          method: String.t(),
          url: String.t(),
          body: iodata | tuple,
          headers: [{binary, binary}]
        }

  @type success_t :: HttpClient.success_t()
  @type error_t :: HttpClient.error_t()

  defstruct [
    :method,
    :url,
    body: "",
    headers: []
  ]

  @spec request(t, Config.t()) :: success_t | error_t
  def request(req, config) do
    http_client = config.http_client
    http_client.request(req.method, req.url, req.body, req.headers, config.http_opts)
  end
end
