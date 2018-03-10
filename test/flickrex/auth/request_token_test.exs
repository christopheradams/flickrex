defmodule Flickrex.Auth.RequestTokenTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.{Config, Fixtures}

  alias Flickrex.Response

  @request_token request_token()

  setup [:flickr_config]

  test "request a request token", %{config: opts} do
    operation = Flickrex.Auth.request_token()

    {:ok, response} = Flickrex.request(operation, opts)

    assert %Response{body: @request_token, status_code: 200} = response
  end
end
