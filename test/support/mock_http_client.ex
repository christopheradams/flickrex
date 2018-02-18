defmodule Flickrex.Support.MockHTTPClient do
  @moduledoc """
  Mock HTTP client.
  """

  @behaviour Flickrex.Request.HttpClient

  import Flickrex.Support.Fixtures

  @json_headers [{"content-type", "application/json; charset=utf-8"}]
  @xml_headers [{"content-type", "text/xml; charset=UTF-8"}]

  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    do_request(method, URI.parse(url), body, headers, http_opts)
  end

  def do_request(:get, %{path: "/test"} = _uri, _, _, _) do
    {:ok, %{status_code: 200, headers: [], body: "Test"}}
  end

  def do_request(:get, %{path: "/opts"} = _uri, _, _, test: value) do
    {:ok, %{status_code: 200, headers: [], body: value}}
  end

  def do_request(:get, %{path: "/error"} = _uri, _, _, _) do
    {:error, %{reason: :error}}
  end

  def do_request(:get, %{path: "/services/oauth/request_token"} = _uri, _, _, _) do
    status = 200
    headers = []
    body = "oauth_callback_confirmed=true&oauth_token=TOKEN&oauth_token_secret=TOKEN_SECRET"

    {:ok, %{status_code: status, headers: headers, body: body}}
  end

  def do_request(:get, %{path: "/services/oauth/access_token"} = _uri, _, _, _) do
    status = 200
    headers = []

    body =
      "fullname=FULL%20NAME&oauth_token=TOKEN&oauth_token_secret=" <>
        "SECRET&user_nsid=NSID&username=USERNAME"

    {:ok, %{status_code: status, headers: headers, body: body}}
  end

  def do_request(:get, %{path: "/services/rest"} = uri, _, _, _) do
    status = 200

    query = URI.decode_query(uri.query)

    %{"format" => format, "method" => method, "nojsoncallback" => "1"} = query

    {doc_format, headers} =
      case format do
        "" ->
          {:xml, @xml_headers}

        "rest" ->
          {:xml, @xml_headers}

        "json" ->
          {:json, @json_headers}
      end

    doc =
      case method do
        "flickr.photos.getInfo" -> :photo
        _ -> :fail
      end

    body = fixture(doc, doc_format)

    {:ok, %{status_code: status, headers: headers, body: body}}
  end

  def do_request(:post, %{path: "/services/upload"} = _uri, req_body, _, _) do
    status = 200
    headers = @xml_headers

    # Check the body is formatted correctly
    {:multipart, parts} = req_body

    file =
      Enum.find(parts, fn
        {:file, _, _, _} -> true
        _ -> false
      end)

    photo = "test/fixtures/photo.png"
    form_data = {"form-data", [{"name", "\"photo\""}, {"filename", "\"photo.png\""}]}

    {:file, ^photo, ^form_data, []} = file

    body = fixture(:upload, :xml)

    {:ok, %{status_code: status, headers: headers, body: body}}
  end

  def do_request(:post, %{path: "/services/replace"} = _uri, req_body, _, _) do
    status = 200
    headers = @xml_headers

    {:multipart, parts} = req_body

    photo_id =
      Enum.find(parts, fn
        {"photo_id", _} -> true
        _ -> false
      end)

    resp_body =
      case photo_id do
        {"photo_id", "35467821184"} ->
          fixture(:replace, :xml)

        nil ->
          fixture(:error, :xml)
      end

    {:ok, %{status_code: status, headers: headers, body: resp_body}}
  end
end
