defmodule Flickrex.Support.Config do
  def flickr_config(_) do
    port = 567_432

    config = [
      consumer_key: "CONSUMER_KEY",
      consumer_secret: "CONSUMER_SECRET",
      oauth_token: "TOKEN",
      oauth_token_secret: "TOKEN_SECRET",
      url: "http://localhost:#{port}",
      http_client: Flickrex.Support.MockHTTPClient,
      http_opts: []
    ]

    [config: config]
  end
end
