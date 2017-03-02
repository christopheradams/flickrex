defmodule Flickrex.API.Auth do
  @moduledoc """
  Provides authentication access to Flickr API.

  See `Flickrex` for more documentation.
  """

  import Flickrex.API.Base

  alias Flickrex.Client
  alias Flickrex.Schema

  @oauth_callback "oob"

  @doc """
  Fetches a temporary token to authenticate the user to your application

  ## Options

  * `oauth_callback` - For web apps, the URL to redirect the user to after completing the
    authorization sequence. The URL will include query params `oauth_token`
    and `oauth_verifier`. If this option is not set, the user will be presented with
    a verification code that they must present to your application manually.
  """
  @spec fetch_request_token(Client.t, Keyword.t) :: {:ok, Client.Request.t} | {:error, binary}
  def fetch_request_token(%Client{consumer: consumer}, params \\ []) do
    oauth_params = Keyword.merge([oauth_callback: @oauth_callback], params)
    url = auth_url(:request_token)
    case request(consumer, %Client.Access{}, :get, url, oauth_params) do
      {:ok, body} ->
        oauth_token = URI.decode_query(body, %{})
        token = oauth_token["oauth_token"]
        secret = oauth_token["oauth_token_secret"]
        {:ok, %Client.Request{token: token, secret: secret}}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Generates a Flickr authorization page URL for a user
  """
  @spec get_authorize_url(Client.Request.t, Keyword.t) :: binary
  def get_authorize_url(%Client.Request{token: oauth_token}, params \\ []) do
    query = params |> Map.new |> Map.put(:oauth_token, oauth_token) |> URI.encode_query
    uri = :authorize |> auth_url |>  URI.parse
    URI.to_string(%{uri | query: query})
  end

  @doc """
  Fetches an access token from Flickr
  """
  @spec fetch_access_token(Client.t, Client.Request.t, binary) :: Schema.Access.t | {:error, term}
  def fetch_access_token(%Client{consumer: consumer}, request, oauth_verifier) do
    params = [oauth_verifier: oauth_verifier]
    url = auth_url(:access_token)
    case request(consumer, request, :get, url, params) do
      {:ok, body} ->
        token = URI.decode_query(body, %{})
        {:ok, %Schema.Access{fullname: token["fullname"],
                             oauth_token: token["oauth_token"],
                             oauth_token_secret: token["oauth_token_secret"],
                             user_nsid: token["user_nsid"],
                             username: token["username"]}}
      {:error, reason} ->
        {:error, reason}
    end
  end
end
