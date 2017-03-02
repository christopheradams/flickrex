defmodule Flickrex.OAuth do
  @moduledoc """
  Specifies OAuther client behaviour.
  """

  @type consumer_key :: String.t
  @type consumer_secret :: String.t
  @type token :: nil | String.t
  @type token_secret :: nil | String.t
  @type signed_params :: [{String.t, String.Chars.t}]

  @callback request(:get | :post, binary, Keyword.t, consumer_key, consumer_secret, token, token_secret) :: tuple
end
