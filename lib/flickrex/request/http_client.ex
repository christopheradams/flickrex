defmodule Flickrex.Request.HttpClient do
  @moduledoc """
  Specifies HTTP client behaviour.
  """

  @type method :: atom | binary
  @type url :: binary
  @type body :: binary | nil
  @type headers :: [{binary, binary}]
  @type status :: pos_integer
  @type http_opts :: list
  @type success_content :: %{status_code: pos_integer, headers: headers, body: body}
  @type success_t :: {:ok, success_content}
  @type error_t :: {:error, %{reason: any}}

  @callback request(method, url, body, headers, http_opts) :: success_t | error_t
end
