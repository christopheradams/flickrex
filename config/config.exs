use Mix.Config

config :flickrex, :config,
  consumer_key: System.get_env("FLICKR_CONSUMER_KEY"),
  consumer_secret: System.get_env("FLICKR_CONSUMER_SECRET"),
  oauth_token: System.get_env("FLICKR_ACCESS_TOKEN"),
  oauth_token_secret: System.get_env("FLICKR_ACCESS_SECRET")
