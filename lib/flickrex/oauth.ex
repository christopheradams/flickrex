defmodule Flickrex.OAuth do
  @moduledoc """
  Specifies OAuther client behaviour.
  """

  @type token :: binary | nil
  @type signed_params :: [{String.t, String.Chars.t}]

  @callback request(:get | :post, binary, Keyword.t, token, token, token, token) :: tuple
end
