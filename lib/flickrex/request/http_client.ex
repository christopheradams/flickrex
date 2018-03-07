defmodule Flickrex.Request.HttpClient do
  @moduledoc ~S"""
  Specifies HTTP client behaviour.

  The client must be able to handle multipart form-data. For photo uploads, the
  body will be a tuple with the following format:

  ```elixir
  {:multipart,
   [
     {"oauth_signature", "U6wKLIKO68To+Ay2Z7Sht5EYMWk="},
     {"oauth_consumer_key", "653e7a6ecc1d528c516cc8f92cf98611"},
     {"oauth_nonce", "+I7IVgaOrR18bowgSxDc0EQ6UK6aNumz"},
     {"oauth_signature_method", "HMAC-SHA1"},
     {"oauth_timestamp", "1520426995"},
     {"oauth_version", "1.0"},
     {"oauth_token", "72157626318069415-087bfc7b5816092c"},
     # other upload params with the format {binary(), binary()}
     {:file, "path/to/photo.jpg",
      {"form-data", [{"name", "\"photo\""}, {"filename", "\"photo.jpg\""}]}, []}
   ]}
  ```

  See [Uploading Photos](https://www.flickr.com/services/api/upload.example.html)
  example from the Flickr API documentation.
  """

  alias Flickrex.Response

  @type method :: :get | :post | :put | :delete
  @type url :: binary
  @type body :: iodata | tuple | nil
  @type headers :: [{binary, binary}]
  @type http_opts :: list
  @type success_t :: {:ok, Response.t()}
  @type error_t :: {:error, %{reason: any}}

  @callback request(method, url, body, headers, http_opts) :: success_t | error_t
end
