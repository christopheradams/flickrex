defmodule Flickrex.Support.MockHTTPClient do
  @moduledoc """
  Mock HTTP client.
  """

  @behaviour Flickrex.Request.HttpClient

  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    do_request(method, URI.parse(url), body, headers, http_opts)
  end

  def do_request("get", %{path: "/services/oauth/request_token"} = _uri, _, _, _) do
    status = 200
    headers = []
    body = "oauth_callback_confirmed=true&oauth_token=TOKEN&oauth_token_secret=TOKEN_SECRET"

    {:ok, %{status_code: status, headers: headers, body: body}}
  end

  def do_request("get", %{path: "/services/oauth/access_token"} = _uri, _, _, _) do
    status = 200
    headers = []
    body = "fullname=FULL%20NAME&oauth_token=TOKEN&oauth_token_secret=SECRET&user_nsid=NSID&username=USERNAME"

    {:ok, %{status_code: status, headers: headers, body: body}}
  end
end
