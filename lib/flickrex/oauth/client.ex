defmodule Flickrex.OAuth.Client do
  @moduledoc """
  Provide a wrapper for OAuther request methods.
  """

  @behaviour Flickrex.OAuth

  @type token :: Flickrex.OAuth.token
  @type signed_params :: [{String.t, String.Chars.t}]

  @doc """
  Send request with get method.
  """
  @spec request(:get | :post, binary, Keyword.t, token, token, token, token) :: tuple
  def request(:get, url, params, consumer_key, consumer_secret, access_token, access_token_secret) do
    oauth_get(url, params, consumer_key, consumer_secret, access_token, access_token_secret, [])
  end

  @doc """
  Send request with post method.
  """
  def request(:post, url, params, consumer_key, consumer_secret, access_token, access_token_secret) do
    oauth_post(url, params, consumer_key, consumer_secret, access_token, access_token_secret, [])
  end

  @doc """
  Send async request with get method.
  """
  @spec request_async(:get | :post, binary, Keyword.t, token, token, token, token) :: tuple
  def request_async(:get, url, params, consumer_key, consumer_secret, access_token, access_token_secret) do
    oauth_get(url, params, consumer_key, consumer_secret, access_token, access_token_secret, stream_option())
  end

  @doc """
  Send async request with post method.
  """
  def request_async(:post, url, params, consumer_key, consumer_secret, access_token, access_token_secret) do
    oauth_post(url, params, consumer_key, consumer_secret, access_token, access_token_secret, stream_option())
  end

  @spec oauth_get(binary, Keyword.t, token, token, token, token, list) :: tuple
  def oauth_get(url, params, consumer_key, consumer_secret, access_token, access_token_secret, options) do
    signed_params = get_signed_params(
      "get", url, params, consumer_key, consumer_secret, access_token, access_token_secret)
    encoded_params = URI.encode_query(signed_params)
    request = {to_char_list(url <> "?" <> encoded_params), []}
    send_httpc_request(:get, request, options)
  end

  @spec oauth_post(binary, Keyword.t, token, token, token, token, list) :: tuple
  def oauth_post(url, params, consumer_key, consumer_secret, access_token, access_token_secret, options) do
    signed_params = get_signed_params(
      "post", url, params, consumer_key, consumer_secret, access_token, access_token_secret)
    encoded_params = URI.encode_query(signed_params)
    request = {to_char_list(url), [], 'application/x-www-form-urlencoded', encoded_params}
    send_httpc_request(:post, request, options)
  end

  @spec send_httpc_request(atom, tuple, list) :: tuple
  def send_httpc_request(method, request, options) do
    :httpc.request(method, request, [{:autoredirect, false}] ++ proxy_option(), options)
  end

  @spec get_signed_params(binary, binary, Keyword.t, token, token, token, token) :: signed_params
  defp get_signed_params(method, url, params, consumer_key, consumer_secret, access_token, access_token_secret) do
    credentials = OAuther.credentials(
        consumer_key: consumer_key,
        consumer_secret: consumer_secret,
        token: access_token,
        token_secret: access_token_secret
    )
    OAuther.sign(method, url, params, credentials)
  end

  @spec stream_option :: list
  defp stream_option do
    [{:sync, false}, {:stream, :self}]
  end

  @spec proxy_option :: list
  defp proxy_option do
    []
  end
end
