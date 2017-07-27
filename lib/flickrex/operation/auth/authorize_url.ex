defmodule Flickrex.Operation.Auth.AuthorizeUrl do
  @moduledoc """
  Holds data necessary for an operation to get an authorization URL.
  """

  @type t :: %__MODULE__{}

  defstruct [
    path: "services/oauth/authorize",
    oauth_token: nil,
    params: %{},
    service: :api,
  ]

  defimpl Flickrex.Operation do

    def prepare(operation, config) do
      http_method = "get"

      uri =
        config.url
        |> URI.parse()
        |> URI.merge(operation.path)

      query =
        operation.params
        |> Map.put(:oauth_token, operation.oauth_token)
        |> URI.encode_query

      url =
        uri
        |> Map.put(:query, query)
        |> to_string()

      %Flickrex.Request{method: http_method, url: url}
    end

    def perform(_operation, request) do
      request.url
    end
  end
end
