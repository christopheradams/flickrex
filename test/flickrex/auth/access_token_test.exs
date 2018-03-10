defmodule Flickrex.Auth.AccessTokenTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.{Config, Fixtures}

  alias Flickrex.Response

  @request_token request_token(:oauth_token)
  @request_secret request_token(:oauth_token_secret)
  @verifier verifier()
  @access_token access_token()

  setup [:flickr_config]

  test "request an access token", %{config: opts} do
    operation = Flickrex.Auth.access_token(@request_token, @request_secret, @verifier)

    {:ok, response} = Flickrex.request(operation, opts)

    assert %Response{body: @access_token, status_code: 200} = response
  end
end
