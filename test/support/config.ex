defmodule Flickrex.Support.Config do

  def flickr_config(_) do
    port = 567432

    config = [
      consumer_key: "CONSUMER_KEY",
      consumer_secret: "CONSUMER_SECRET",
      access_token: "TOKEN",
      access_token_secret: "TOKEN_SECRET",
      url: "http://localhost:#{port}",
    ]

    [config: config]
  end
end
