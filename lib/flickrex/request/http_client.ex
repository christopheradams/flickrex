defmodule Flickrex.Request.HttpClient do
  @moduledoc """
  Specifies HTTP client behaviour.
  """

  @type http_method :: :get | :post | :put | :delete
  @type http_headers :: [{binary, binary}, ...]
  @type http_status :: pos_integer
  @type http_response :: %{status_code: pos_integer, headers: http_headers, body: binary}
  @type success_t :: {:ok, http_response}
  @type error_t :: {:error, %{reason: any}}

  @callback request(method :: http_method, url :: binary, req_body :: binary, headers :: http_headers, http_opts :: term) ::
    success_t | error_t
end
