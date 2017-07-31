defmodule Flickrex.Support.MockHTTPClient do
  @moduledoc """
  Mock HTTP client.
  """

  @behaviour Flickrex.Request.HttpClient

  @json_headers [{"content-type", "application/json; charset=utf-8"}]

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

  def do_request("get", %{path: "/services/rest"} = uri, _, _, _) do
    status = 200
    headers = @json_headers

    query = URI.decode_query(uri.query)

    %{"format" => "json", "method" => method, "nojsoncallback" => "1"} = query

    doc =
      case method do
        "flickr.photos.getInfo" -> :photo
        _ -> :fail
      end

    body = fixture(doc)

    {:ok, %{status_code: status, headers: headers, body: body}}
  end

  defp fixture(doc) do
    File.read!("test/fixtures/#{doc}.json")
  end
end
