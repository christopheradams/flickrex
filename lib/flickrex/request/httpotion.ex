defmodule Flickrex.Request.HTTPotion do
  @behaviour Flickrex.Request.HttpClient

  def request(method, url, body, headers, http_opts) do
    resp = HTTPotion.request(method, url, [body: body, headers: headers, ibrowse: http_opts])
    {:ok, %{status_code: resp.status_code, body: resp.body, headers: resp.headers.hdrs}}
  end
end
