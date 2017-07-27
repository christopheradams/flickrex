defmodule Flickrex.Auth.RequestTokenTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  setup [:flickr_config]

  test "prepare a request token request", %{config: opts} do
    operation = Flickrex.Auth.request_token()

    config = Flickrex.Config.new(operation.service, opts)
    request = Flickrex.Operation.prepare(operation, config)

    %Flickrex.Request{body: "", headers: [], http_opts: [], method: "get", url: url} = request

    uri = URI.parse(url)
    query = URI.decode_query(uri.query)

    assert uri.path == "/services/oauth/request_token"

    assert %{"oauth_callback" => "oob", "oauth_consumer_key" => "CONSUMER_KEY",
             "oauth_nonce" => _oauth_nonce,
             "oauth_signature" => _oauth_signature,
             "oauth_signature_method" => "HMAC-SHA1",
             "oauth_timestamp" => _oauth_timestamp,
             "oauth_version" => "1.0"} = query
  end
end
