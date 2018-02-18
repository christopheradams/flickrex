defmodule Flickrex.Request.HttpClient do
  @moduledoc """
  Specifies HTTP client behaviour.
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
