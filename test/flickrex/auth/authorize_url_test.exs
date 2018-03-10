defmodule Flickrex.Auth.AuthorizeUrlTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.{Config, Fixtures}

  @token access_token(:oauth_token)

  setup [:flickr_config]

  test "get an authorize URL", %{config: config} do
    operation = Flickrex.Auth.authorize_url(@token, perms: "write")

    {:ok, authorize_url} = Flickrex.request(operation, config)

    url = "http://localhost:567432/services/oauth/authorize?oauth_token=#{@token}&perms=write"

    assert authorize_url == url
  end
end
