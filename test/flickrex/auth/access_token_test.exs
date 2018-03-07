defmodule Flickrex.Auth.AccessTokenTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  alias Flickrex.Response

  setup [:flickr_config]

  test "request an access token", %{config: opts} do
    operation = Flickrex.Auth.access_token("TOKEN", "SECRET", "VERIFIER")

    {:ok, response} = Flickrex.request(operation, opts)

    expected_response = %Response{
      body: %{
        fullname: "Jamal Fanaian",
        oauth_token: "72157626318069415-087bfc7b5816092c",
        oauth_token_secret: "a202d1f853ec69de",
        user_nsid: "21207597@N07",
        username: "jamalfanaian"
      },
      headers: [],
      status_code: 200
    }

    assert response == expected_response
  end
end
