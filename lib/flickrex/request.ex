defmodule Flickrex.Request do
  @moduledoc """
  Makes requests to Flickr.
  """

  alias __MODULE__, as: Request
  alias Flickrex.Request.HttpClient

  @type t :: %Request{
    method: String.t,
    url: String.t,
    body: iodata | tuple,
    headers: [{binary, binary}],
    http_opts: Keyword.t,
  }

  @type success_t :: HttpClient.success_t
  @type error_t :: HttpClient.error_t

  defstruct [
    :method,
    :url,
    :http_client,
    body: "",
    headers: [],
    http_opts: [],
  ]

  @spec request(t) :: success_t | error_t
  def request(req) do
    http_client = req.http_client
    http_client.request(req.method, req.url, req.body, req.headers, req.http_opts)
  end
end
