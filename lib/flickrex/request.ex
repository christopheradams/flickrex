defmodule Flickrex.Request do
  @moduledoc """
  Makes requests to Flickr.
  """

  alias __MODULE__, as: Request

  @type t :: %Request{
    method: String.t,
    url: String.t,
    body: iodata,
    headers: [{binary, binary}],
    http_opts: Keyword.t,
  }

  defstruct [
    :method,
    :url,
    body: "",
    headers: [],
    http_opts: [],
  ]

  def request(req) do
    request(req.method, req.url, req.body, req.headers, req.http_opts)
  end

  defp request(method, url, body, headers, http_opts) do
    Request.Hackney.request(method, url, body, headers, http_opts)
  end
end
