defmodule Flickrex do
  @moduledoc ~S"""
  Performs Flickr API requests.

  # Examples

      operation = Flickrex.Flickr.Photos.get_recent(per_page: 5)
      config = [url: "https://flickr-proxy.example.com"]

      {:ok, resp} = Flickrex.request(operation, config)
  """

  alias Flickrex.{
    Config,
    Error,
    Operation,
    Response
  }

  @doc """
  Performs a Flickr API request.

  ## Options

  * `consumer_key` - Flickr API consumer key.
  * `consumer_secret` - Flickr API consumer secret.
  * `oauth_token` - Flickr user access token.
  * `oauth_token_secret` - Flickr user access token secret.
  * `url` - API Endpoint URL.
  * `http_client` - HTTP client function. See `Flickrex.Request.HttpClient`.
  * `http_opts` - HTTP client options.
  """
  @spec request(Operation.t()) :: term
  @spec request(Operation.t(), Keyword.t()) :: {:ok, Response.t()} | {:error, term}
  def request(operation, opts \\ []) do
    config = Config.new(operation.service, opts)
    Operation.perform(operation, config)
  end

  @doc """
  Performs a Flickr API request. Raises on failure.

  See `request/2`.
  """
  @spec request!(Operation.t(), Keyword.t()) :: term | no_return
  def request!(operation, opts \\ []) do
    case request(operation, opts) do
      {:ok, result} ->
        result

      error ->
        raise Error, """
        Flickrex Request Error

        #{inspect(error)}
        """
    end
  end
end
