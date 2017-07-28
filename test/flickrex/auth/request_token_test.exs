defmodule Flickrex.Auth.RequestTokenTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  setup [:flickr_config]

  test "request a request token", %{config: opts} do
    operation = Flickrex.Auth.request_token()

    {:ok, response} = Flickrex.request(operation, opts)

    assert response == %{
      body: %{callback_confirmed: true, secret: "TOKEN_SECRET", token: "TOKEN"},
      headers: [],
      status_code: 200
    }
  end
end
