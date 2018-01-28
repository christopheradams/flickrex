defmodule Flickrex.Operation.Auth.AuthorizeUrl do
  @moduledoc """
  Holds data necessary for an operation to get an authorization URL.
  """

  alias Flickrex.Operation

  @type t :: %__MODULE__{}

  defstruct path: "services/oauth/authorize",
            oauth_token: nil,
            params: %{},
            service: :api

  defimpl Operation do
    alias Flickrex.{
      Config,
      Operation
    }

    @spec perform(Operation.Auth.AuthorizeUrl.t(), Config.t()) :: term
    def perform(operation, %Config{} = config) do
      uri =
        config.url
        |> URI.parse()
        |> URI.merge(operation.path)

      query =
        operation.params
        |> Map.put(:oauth_token, operation.oauth_token)
        |> URI.encode_query()

      url =
        uri
        |> Map.put(:query, query)
        |> to_string()

      {:ok, url}
    end
  end
end
