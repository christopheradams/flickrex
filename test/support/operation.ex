defmodule Flickrex.Support.Operation do
  defstruct [
    path: nil,
    service: :api
  ]

  defimpl Flickrex.Operation do
    def prepare(operation, config) do
      uri =
        config.url
        |> URI.parse()
        |> URI.merge(operation.path)

      %Flickrex.Request{method: "get", url: to_string(uri)}
    end

    def perform(_operation, request) do
      Flickrex.Request.request(request)
    end
  end
end
