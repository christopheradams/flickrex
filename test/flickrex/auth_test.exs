defmodule Flickrex.AuthTest do
  use ExUnit.Case

  alias Flickrex.{Auth, Operation}

  test "request_token/0 returns a RequestToken operation" do
    request = Auth.request_token()

    operation = %Operation.Auth.RequestToken{
      path: "services/oauth/request_token",
      params: %{oauth_callback: "oob"},
    }

    assert request == operation
  end

  test "request_token/1 returns a RequestToken operation" do
    opts = [oauth_callback: "http://example.com/test"]

    request = Auth.request_token(opts)

    operation = %Operation.Auth.RequestToken{
      path: "services/oauth/request_token",
      params: %{oauth_callback: "http://example.com/test"},
    }

    assert request == operation
  end

  test "authorize_url/2 returns an AuthorizeUrl operation" do
    opts = [perms: "write"]

    request = Auth.authorize_url("OAUTH_TOKEN", opts)

    operation = %Operation.Auth.AuthorizeUrl{
      path: "services/oauth/authorize",
      params: %{perms: "write"},
      oauth_token: "OAUTH_TOKEN",
    }

    assert request == operation
  end

  test "access_token/3 returns an AccessToken operation" do
    request = Auth.access_token("REQUEST_TOKEN", "REQUEST_SECRET", "VERIFIER")

    operation = %Operation.Auth.AccessToken{
      oauth_token: "REQUEST_TOKEN",
      oauth_token_secret: "REQUEST_SECRET",
      verifier: "VERIFIER",
    }

    assert request == operation
  end
end
