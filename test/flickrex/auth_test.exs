defmodule Flickrex.AuthTest do
  use ExUnit.Case

  alias Flickrex.{Auth, Operation}

  import Flickrex.Support.Fixtures

  @request_token request_token(:oauth_token)
  @request_secret request_token(:oauth_token_secret)
  @verifier verifier()

  test "request_token/0 returns a RequestToken operation" do
    request = Auth.request_token()

    operation = %Operation.Auth.RequestToken{
      path: "services/oauth/request_token",
      params: %{oauth_callback: "oob"}
    }

    assert request == operation
  end

  test "request_token/1 returns a RequestToken operation" do
    opts = [oauth_callback: "http://example.com/test"]

    request = Auth.request_token(opts)

    operation = %Operation.Auth.RequestToken{
      path: "services/oauth/request_token",
      params: %{oauth_callback: "http://example.com/test"}
    }

    assert request == operation
  end

  test "authorize_url/2 returns an AuthorizeUrl operation" do
    opts = [perms: "write"]

    request = Auth.authorize_url(@request_token, opts)

    operation = %Operation.Auth.AuthorizeUrl{
      path: "services/oauth/authorize",
      params: %{perms: "write"},
      oauth_token: @request_token
    }

    assert request == operation
  end

  test "access_token/3 returns an AccessToken operation" do
    request = Auth.access_token(@request_token, @request_secret, @verifier)

    operation = %Operation.Auth.AccessToken{
      oauth_token: @request_token,
      oauth_token_secret: @request_secret,
      verifier: @verifier
    }

    assert request == operation
  end
end
