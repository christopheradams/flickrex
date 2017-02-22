defmodule Flickrex.API.Base do
  alias Flickrex.Config

  @end_point "https://api.flickr.com/services"
  @oauther Application.get_env(:flickrex, :oauther) || Flickrex.OAuth

  @doc """
  Call Flickr API with an API method and optional arguments.

  Example:

    flickrex = Flickrex.new
    list = Flickrex.call(flickrex, "flickr.photos.getRecent", per_page: 5)
  """
  def call(%Config{} = config, method, args \\ []) do
    params = Keyword.merge([method: method, format: "json", nojsoncallback: 1], args)
    body = request(config, :get, rest_url(), params)
    Poison.decode!(body)
  end

  @doc false
  def request(%Config{} = config, method, url, params) do
    result = @oauther.request(method, url, params, config.consumer_key,
      config.consumer_secret, config.access_token, config.access_token_secret)
    {:ok, {_response, _header, body}} = result
    body
  end

  @doc false
  def rest_url do
    request_url("rest")
  end

  @doc false
  def auth_url(path) do
    request_url("oauth/#{path}")
  end

  @doc false
  def request_url(path) do
    "#{@end_point}/#{path}"
  end
end
