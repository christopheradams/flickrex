defmodule Flickrex.API.AuthTest do
  use ExUnit.Case

  alias Flickrex.API.Auth

  test "get request token" do
    flickrex = Flickrex.new
    token = Auth.get_request_token(flickrex)
    assert Map.has_key?(token, :oauth_token)
    assert token.oauth_token == "OAUTH_TOKEN"
  end
end
