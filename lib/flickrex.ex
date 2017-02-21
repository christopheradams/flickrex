defmodule Flickrex do
  @moduledoc """
  Documentation for Flickrex.
  """

  alias Flickrex.API

  @doc """
  Create a Flickrex client using application config
  """
  def new do
    new(Application.get_env(:flickrex, :oauth))
  end

  @doc """
  Create a Flickrex client using the specified config
  """
  defdelegate new(params), to: Flickrex.Config

  @doc """
  TODO
  use this to override application config Flickrex.new |> Flickrex.config(tokens)
  """
  defdelegate config(config, params), to: Flickrex.Config, as: :merge

  defdelegate get_request_token(config), to: API.Auth

  defdelegate get_authorize_url(request_token), to: API.Auth

  defdelegate fetch_access_token(config, request_token, verify), to: API.Auth

  defdelegate call(config, method, args \\ []), to: API.Auth

end
