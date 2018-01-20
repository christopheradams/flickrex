defmodule Flickrex.Auth.RequestTokenTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  setup [:flickr_config]

  test "request a request token", %{config: opts} do
    operation = Flickrex.Auth.request_token()

    {:ok, response} = Flickrex.request(operation, opts)

    expected_response = %{
      body: %{
        oauth_callback_confirmed: true,
        oauth_token_secret: "TOKEN_SECRET",
        oauth_token: "TOKEN"
      },
      headers: [],
      status_code: 200
    }

    assert response == expected_response
  end
end
