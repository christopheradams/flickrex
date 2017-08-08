defmodule Flickrex.Request.Hackney do
  @moduledoc """
  Hackney HTTP client.
  """

  @behaviour Flickrex.Request.HttpClient

  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    opts = http_opts ++ [:with_body]

    case :hackney.request(method, url, headers, body, opts) do
      {:ok, status, headers} ->
        {:ok, %{status_code: status, headers: headers}}
      {:ok, status, headers, body} ->
        {:ok, %{status_code: status, headers: headers, body: body}}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end
end
