defmodule Flickrex.Request.Hackney do
  @moduledoc """
  Hackney HTTP client.
  """

  @behaviour Flickrex.Request.HttpClient

  alias Flickrex.Request.HttpClient
  alias Flickrex.Response

  @type method :: HttpClient.method()
  @type url :: HttpClient.url()
  @type body :: HttpClient.body()
  @type headers :: HttpClient.headers()
  @type http_opts :: HttpClient.http_opts()
  @type success_t :: HttpClient.success_t()
  @type error_t :: HttpClient.error_t()

  @spec request(method, url, body, headers, any) :: success_t | error_t
  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    opts = http_opts ++ [:with_body]

    case :hackney.request(method, url, headers, body, opts) do
      {:ok, status, headers} ->
        {:ok, %Response{status_code: status, headers: headers}}

      {:ok, status, headers, body} ->
        {:ok, %Response{status_code: status, headers: headers, body: body}}

      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end
end
