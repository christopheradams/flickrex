defmodule Flickrex.API.Base do
  @moduledoc """
  Provides base access to Flickr API.
  """

  alias Flickrex.Config

  @end_point "https://api.flickr.com/services"
  @oauther Application.get_env(:flickrex, :oauther) || Flickrex.OAuth.Client

  @doc """
  Calls Flickr API with an API method and optional arguments

  Example:

    flickrex = Flickrex.new
    list = Flickrex.call(flickrex, "flickr.photos.getRecent", per_page: 5)
  """
  @spec call(Config.t, binary, Keyword.t) :: binary
  def call(%Config{} = config, method, args \\ []) do
    params = Keyword.merge([method: method, format: "json", nojsoncallback: 1], args)
    request(config, :get, rest_url(), params)
  end

  @doc false
  @spec request(Config.t, :get | :post, binary, Keyword.t) :: binary
  def request(%Config{} = config, method, url, params) do
    result = @oauther.request(method, url, params, config.consumer_key,
      config.consumer_secret, config.access_token, config.access_token_secret)
    {:ok, {_response, _header, body}} = result
    IO.iodata_to_binary(body)
  end

  @doc false
  @spec rest_url :: binary
  def rest_url do
    request_url("rest")
  end

  @doc false
  @spec auth_url(atom | binary) :: binary
  def auth_url(path) do
    request_url("oauth/#{path}")
  end

  @doc false
  @spec request_url(atom | binary) :: binary
  def request_url(path) do
    "#{@end_point}/#{path}"
  end
end
