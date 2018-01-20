defmodule Flickrex.OAuthTest do
  use ExUnit.Case

  alias Flickrex.OAuth

  test "sign/7 signs request params" do
    method = "get"
    url = "http://example.com/test"
    params = [param: "test"]
    key = "CONSUMER_KEY"
    secret = "CONSUMER_SECRET"
    token = "TOKEN"
    token_secret = "TOKEN_SECRET"

    signed_params = OAuth.sign(method, url, params, key, secret, token, token_secret)

    signed = Map.new(signed_params)

    assert Map.get(signed, :param) == "test"
    assert Map.get(signed, "oauth_token") == "TOKEN"
    assert Map.get(signed, "oauth_consumer_key") == "CONSUMER_KEY"

    assert Map.has_key?(signed, "oauth_signature")
    assert Map.has_key?(signed, "oauth_nonce")
    assert Map.has_key?(signed, "oauth_signature_method")
    assert Map.has_key?(signed, "oauth_timestamp")
    assert Map.has_key?(signed, "oauth_version")
  end
end
