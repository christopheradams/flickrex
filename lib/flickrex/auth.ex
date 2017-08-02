defmodule Flickrex.Auth do
  @moduledoc """
  Operations on Flickr Auth.
  """

  alias Flickrex.Operation

  @doc """
  Requests a temporary token to authenticate the user to your application
  """
  @spec request_token() :: %Operation.Auth.RequestToken{}
  def request_token() do
    %Operation.Auth.RequestToken{}
  end

  @doc """
  Requests a temporary token to authenticate the user to your application with
  optional callback

  ## Options

  * `oauth_callback` - For web apps, the URL to redirect the user to after completing the
    authorization sequence. The URL will include query params `oauth_token`
    and `oauth_verifier`. If this option is not set, the user will be presented with
    a verification code that they must present to your application manually.
  """
  @spec request_token(Keyword.t) :: %Operation.Auth.RequestToken{}
  def request_token(opts) do
    %Operation.Auth.RequestToken{
      params: Map.new(opts)
    }
  end

  @doc """
  Generates a Flickr authorization URL.

  ## Options

  * `perms` - Ask for "read", "write", or "delete" privileges. Overrides the
    setting defined in your application's authentication flow.
  """
  @spec authorize_url(binary, Keyword.t) :: %Operation.Auth.AuthorizeUrl{}
  def authorize_url(oauth_token, opts \\ []) do
    %Operation.Auth.AuthorizeUrl{
      oauth_token: oauth_token,
      params: Map.new(opts)
    }
  end

  @doc """
  Requests an access token from Flickr.
  """
  @spec access_token(binary, binary, binary) :: %Operation.Auth.AccessToken{}
  def access_token(token, secret, verifier) do
    %Operation.Auth.AccessToken{
      oauth_token: token,
      oauth_token_secret: secret,
      verifier: verifier,
    }
  end
end
