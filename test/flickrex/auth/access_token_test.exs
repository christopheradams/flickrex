defmodule Flickrex.Auth.AccessTokenTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  setup [:flickr_config]

  test "prepare an access token request", %{config: opts} do
    operation = Flickrex.Auth.access_token("TOKEN", "SECRET", "VERIFIER")

    config = Flickrex.Config.new(operation.service, opts)
    request = Flickrex.Operation.prepare(operation, config)

    %Flickrex.Request{body: "", headers: [], http_opts: [], method: "get", url: url} = request

    uri = URI.parse(url)
    query = URI.decode_query(uri.query)

    assert uri.path == "/services/oauth/access_token"

    assert %{"oauth_consumer_key" => "CONSUMER_KEY", "oauth_verifier" => "VERIFIER"} = query
  end
end
