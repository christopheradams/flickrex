use Mix.Config

config :flickrex, :oauth, [
  consumer_key:        System.get_env("FLICKR_CONSUMER_KEY"),
  consumer_secret:     System.get_env("FLICKR_CONSUMER_SECRET"),
  access_token:        System.get_env("FLICKR_ACCESS_TOKEN"),
  access_token_secret: System.get_env("FLICKR_ACCESS_SECRET")
]
