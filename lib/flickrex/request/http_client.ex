defmodule Flickrex.Request.HttpClient do
  @moduledoc ~S"""
  Specifies HTTP client behaviour.

  The client must be able to handle multipart form-data. For photo uploads, the
  body will be a tuple with the following format:

  ```elixir
  {:multipart,
   [
     {"oauth_signature", "6WAWwg6NxMtMb8J/+vEaB6kH8Aw="},
     {"oauth_consumer_key", "CONSUMER_KEY"},
     {"oauth_nonce", "yOY1CvqgzOFaeeDr9lPCGgCfI14PFbTy"},
     {"oauth_signature_method", "HMAC-SHA1"},
     {"oauth_timestamp", "1518934770"},
     {"oauth_version", "1.0"},
     {"oauth_token", "TOKEN"},
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
