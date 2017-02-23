defmodule Flickrex.OAuth.Mock do
  @moduledoc false

  @behaviour Flickrex.OAuth

  @type token :: Flickrex.OAuth.token

  @spec request(:get | :post, binary, Keyword.t, token, token, token, token) :: tuple
  def request(:get, "https://api.flickr.com/services/oauth/request_token", _, _, _, _, _) do
    body = 'oauth_callback_confirmed=true&oauth_token=REQUEST_TOKEN&oauth_token_secret=REQUEST_TOKEN_SECRET'
    {:ok, {nil, nil, body}}
  end

  def request(:get, "https://api.flickr.com/services/oauth/access_token", _, _, _, _, _) do
    body = 'fullname=FULLNAME&oauth_token=ACCESS_TOKEN&oauth_token_secret=ACCESS_TOKEN_SECRET&user_nsid=USER_NSID&username=USERNAME'
    {:ok, {nil, nil, body}}
  end

  def request(:get, "https://api.flickr.com/services/rest", params, _, _, _, _) do
    method = Keyword.get(params, :method)
    param = Keyword.get(params, :param)
    format = Keyword.get(params, :format)
    no_json = Keyword.get(params, :nojsoncallback)
    body = '{"param":"#{param}","nojsoncallback":#{no_json},"method":"#{method}","format":"#{format}"}'
    {:ok, {nil, nil, body}}
  end

  def request(method, url, params, ck, cs, at, ats) do
    args = [method: method, url: url, ck: ck, cs: cs, at: at, ats: ats]
    query = Keyword.merge(args, params)
    body = URI.encode_query(query)
    {:ok, {nil, nil, body}}
  end
end
