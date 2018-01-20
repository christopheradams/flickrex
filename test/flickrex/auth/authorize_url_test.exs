defmodule Flickrex.Auth.AuthorizeUrlTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  setup [:flickr_config]

  test "get an authorize URL", %{config: config} do
    operation = Flickrex.Auth.authorize_url("OAUTH_TOKEN", perms: "write")

    {:ok, authorize_url} = Flickrex.request(operation, config)

    url = "http://localhost:567432/services/oauth/authorize?oauth_token=OAUTH_TOKEN&perms=write"

    assert authorize_url == url
  end
end
