defmodule Flickrex.OAuth do
  @moduledoc false

  @type method :: String.t
  @type url :: String.t | URI.t
  @type params :: Keyword.t
  @type consumer_key :: String.t
  @type consumer_secret :: String.t
  @type token :: nil | String.t
  @type token_secret :: nil | String.t
  @type signed :: [{String.t, String.Chars.t}]

  @spec sign(method, url, params, consumer_key, consumer_secret, token, token_secret) :: signed
  def sign(method, url, params, consumer_key, consumer_secret, token, token_secret) do
    credentials = OAuther.credentials(
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      token: token,
      token_secret: token_secret
    )
    OAuther.sign(method, url, params, credentials)
  end
end
