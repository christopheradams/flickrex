defmodule Flickrex.OAuthTest do
  use ExUnit.Case

  alias Flickrex.OAuth

  import Flickrex.Support.Fixtures

  @key consumer_key()
  @secret consumer_secret()
  @token access_token(:oauth_token)
  @token_secret access_token(:oauth_token_secret)

  test "sign/7 signs request params" do
    method = :get
    url = "http://example.com/test"
    params = [param: "test"]

    signed_params = OAuth.sign(method, url, params, @key, @secret, @token, @token_secret)

    signed = Map.new(signed_params)

    assert Map.get(signed, :param) == "test"
    assert Map.get(signed, "oauth_token") == @token
    assert Map.get(signed, "oauth_consumer_key") == @key

    assert Map.has_key?(signed, "oauth_signature")
    assert Map.has_key?(signed, "oauth_nonce")
    assert Map.has_key?(signed, "oauth_signature_method")
    assert Map.has_key?(signed, "oauth_timestamp")
    assert Map.has_key?(signed, "oauth_version")
  end
end
