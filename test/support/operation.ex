defmodule Flickrex.Support.Operation do
  @moduledoc false

  defstruct path: nil,
            service: :api

  defimpl Flickrex.Operation do
    def perform(operation, config) do
      http_method = :get

      uri =
        config.url
        |> URI.parse()
        |> URI.merge(operation.path)

      url = to_string(uri)

      request = %Flickrex.Request{
        method: http_method,
        url: url
      }

      Flickrex.Request.request(request, config)
    end
  end
end
