defmodule Flickrex.OAuth.Mock do
  @moduledoc false

  def request(:get, _url, _params, _consumer_key, _consumer_secret, _access_token, _access_token_secret) do
    body = "oauth_callback_confirmed=true&oauth_token=OAUTH_TOKEN&oauth_token_secret=OAUTH_TOKEN_SECRET"
    {:ok, {nil, nil, body}}
  end
end
