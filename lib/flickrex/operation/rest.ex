defmodule Flickrex.Operation.Rest do
  @moduledoc """
  Holds data necessary for an operation on the Flickr REST service.
  """

  @json_params %{nojsoncallback: "1", jsoncallback: "jsonFlickrApi"}

  @type t :: %__MODULE__{}

  defstruct [
    path: "/rest",
    parser: nil,
    params: %{},
    method: nil,
    http_method: nil,
    format: "json",
    extra_params: @json_params,
    service: :api,
  ]
end
