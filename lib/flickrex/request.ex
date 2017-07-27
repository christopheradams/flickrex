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

  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    opts = http_opts ++ [:with_body]

    case :hackney.request(method, url, headers, body, opts) do
      {:ok, status, headers} ->
        {:ok, %{status_code: status, headers: headers}}
      {:ok, status, headers, body} ->
        {:ok, %{status_code: status, headers: headers, body: body}}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end
end
