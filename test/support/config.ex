defmodule Flickrex.Support.Config do

  alias Flickrex.Support.Fixtures

  def flickr_config(_) do
    port = 567_432

    config = [
      consumer_key: Fixtures.consumer_key(),
      consumer_secret: Fixtures.consumer_secret(),
      oauth_token: Fixtures.access_token(:oauth_token),
      oauth_token_secret: Fixtures.access_token(:oauth_token_secret),
      url: "http://localhost:#{port}",
      http_client: Flickrex.Support.MockHTTPClient,
      http_opts: []
    ]

    [config: config]
  end
end
