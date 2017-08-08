defmodule Flickrex.Auth.AccessTokenTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  setup [:flickr_config]

  test "request an access token", %{config: opts} do
    operation = Flickrex.Auth.access_token("TOKEN", "SECRET", "VERIFIER")

    {:ok, response} = Flickrex.request(operation, opts)

    assert response == %{
      body: %{
        fullname: "FULL NAME",
        oauth_token: "TOKEN",
        oauth_token_secret: "SECRET",
        user_nsid: "NSID",
        username: "USERNAME"
      },
      headers: [],
      status_code: 200
    }
  end
end
