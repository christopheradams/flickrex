defmodule Flickrex.OAuth.Client do
  @moduledoc """
  Provide a wrapper for OAuther request methods.
  """

  @behaviour Flickrex.OAuth

  @type consumer_key :: Flickrex.OAuth.consumer_key
  @type consumer_secret :: Flickrex.OAuth.consumer_secret
  @type token :: Flickrex.OAuth.token
  @type token_secret :: Flickrex.OAuth.token_secret
  @type signed :: Flickrex.OAuth.signed_params

  @doc """
  Send request with get method.
  """
  @spec request(:get | :post, binary, Keyword.t, consumer_key, consumer_secret, token, token_secret) :: tuple
  def request(:get, url, params, consumer_key, consumer_secret, token, token_secret) do
    oauth_get(url, params, consumer_key, consumer_secret, token, token_secret, [])
  end

  @doc """
  Send request with post method.
  """
  def request(:post, url, params, consumer_key, consumer_secret, token, token_secret) do
    oauth_post(url, params, consumer_key, consumer_secret, token, token_secret, [])
  end

  @doc """
  Send async request with get method.
  """
  @spec request_async(:get | :post, binary, Keyword.t, consumer_key, consumer_secret, token, token_secret) :: tuple
  def request_async(:get, url, params, consumer_key, consumer_secret, token, token_secret) do
    oauth_get(url, params, consumer_key, consumer_secret, token, token_secret, stream_option())
  end

  @doc """
  Send async request with post method.
  """
  def request_async(:post, url, params, consumer_key, consumer_secret, token, token_secret) do
    oauth_post(url, params, consumer_key, consumer_secret, token, token_secret, stream_option())
  end

  @spec oauth_get(binary, Keyword.t, consumer_key, consumer_secret, token, token_secret, list) :: tuple
  def oauth_get(url, params, consumer_key, consumer_secret, token, token_secret, options) do
    signed_params = get_signed_params(
      "get", url, params, consumer_key, consumer_secret, token, token_secret)
    encoded_params = URI.encode_query(signed_params)
    request = {to_char_list(url <> "?" <> encoded_params), []}
    send_httpc_request(:get, request, options)
  end

  @spec oauth_post(binary, Keyword.t, consumer_key, consumer_secret, token, token_secret, list) :: tuple
  def oauth_post(url, params, consumer_key, consumer_secret, token, token_secret, options) do
    signed_params = get_signed_params(
      "post", url, params, consumer_key, consumer_secret, token, token_secret)
    encoded_params = URI.encode_query(signed_params)
    request = {to_char_list(url), [], 'application/x-www-form-urlencoded', encoded_params}
    send_httpc_request(:post, request, options)
  end

  @doc """
  Post a file. Only `params` are signed, as per the Flickr API.
  """
  @spec oauth_post_file(binary, binary, binary, Keyword.t, consumer_key, consumer_secret, token, token_secret, list) :: tuple
  def oauth_post_file(url, file, name, params, consumer_key, consumer_secret, token, token_secret, options \\ []) do
    signed_params =
      "post"
      |> get_signed_params(url, params, consumer_key, consumer_secret, token, token_secret)
      |> Enum.map(fn {k, v} -> {to_string(k), to_string(v)} end)

    filename = Path.basename(file)
    disposition = {"form-data", [{"name", "\"#{name}\""}, {"filename", "\"#{filename}\""}]}
    file_param = {:file, file, disposition, []}

    parts = signed_params ++ [file_param]

    body = {:multipart, parts}

    :hackney.post(url, [], body, options)
  end

  @spec send_httpc_request(atom, tuple, list) :: tuple
  def send_httpc_request(method, request, options) do
    :httpc.request(method, request, [{:autoredirect, false}] ++ proxy_option(), options)
  end

  @spec get_signed_params(binary, binary, Keyword.t, consumer_key, consumer_secret, token, token_secret) :: signed
  defp get_signed_params(method, url, params, consumer_key, consumer_secret, token, token_secret) do
    credentials = OAuther.credentials(
        consumer_key: consumer_key,
        consumer_secret: consumer_secret,
        token: token,
        token_secret: token_secret
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
