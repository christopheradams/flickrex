defmodule Flickrex.OAuth do
  @moduledoc false

  @type consumer_key :: String.t
  @type consumer_secret :: String.t
  @type token :: nil | String.t
  @type token_secret :: nil | String.t
  @type signed_params :: [{String.t, String.Chars.t}]

  @spec sign(binary, binary, Keyword.t, consumer_key, consumer_secret, token, token_secret) :: signed_params
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
