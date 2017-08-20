defmodule Flickrex.Support.Config do

  def flickr_config(_) do
    port = 567432

    config = [
      consumer_key: "CONSUMER_KEY",
      consumer_secret: "CONSUMER_SECRET",
      oauth_token: "TOKEN",
      oauth_token_secret: "TOKEN_SECRET",
      url: "http://localhost:#{port}",
      http_client: Flickrex.Support.MockHTTPClient,
    ]

    [config: config]
  end
end