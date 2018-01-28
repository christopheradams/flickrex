defmodule Flickrex.Support.Operation do
  defstruct path: nil,
            service: :api

  defimpl Flickrex.Operation do
    def perform(operation, config) do
      http_method = "get"

      uri =
        config.url
        |> URI.parse()
        |> URI.merge(operation.path)

      url = to_string(uri)

      request = %Flickrex.Request{
        method: http_method,
        url: url,
        http_client: config.http_client,
        http_opts: config.http_opts
      }

      Flickrex.Request.request(request)
    end
  end
end
