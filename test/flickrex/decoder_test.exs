defmodule Flickrex.DecoderTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  alias Flickrex.Parsers

  setup [:flickr_config]

  test "request JSON with custom codec", %{config: opts} do
    photo_id = "8436466166"
    method = "flickr.photos.getInfo"

    operation =
      method
      |> Flickrex.Rest.get(photo_id: photo_id)
      |> Map.put(:parser, &Parsers.Rest.parse/2)

    config = Keyword.put(opts, :json_decoder, Flickrex.Support.IdentityDecoder)

    {:ok, response} = Flickrex.request(operation, config)

    assert "{" <> _rest = response.body
  end

  test "request XML with custom codec", %{config: opts} do
    photo_id = "8436466166"
    method = "flickr.photos.getInfo"

    operation =
      method
      |> Flickrex.Rest.get(photo_id: photo_id)
      |> Map.put(:parser, &Parsers.Rest.parse/2)
      |> Map.put(:format, :rest)

    config = Keyword.put(opts, :rest_decoder, Flickrex.Support.IdentityDecoder)

    {:ok, response} = Flickrex.request(operation, config)

    assert "<?xml" <> _rest = response.body
  end
end
