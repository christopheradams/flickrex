defmodule Flickrex.Config do
  @moduledoc """
  Flickrex client configuration.
  """

  alias __MODULE__, as: Config

  defstruct [:consumer_key, :consumer_secret, :access_token, :access_token_secret]

  @doc """
  Create a new Flickrex config
  """
  def new do
    %Config{}
  end

  @doc """
  Create a new Flickrex config from the params
  """
  def new(params) do
    struct(Config, params)
  end

  @doc """
  Merge params into a Flickrex config
  """
  def merge(config, params) do
    Map.merge(config, struct(Config, params))
  end

  @doc """
  Put a new value in a Flickrex config
  """
  def put(config, key, value) do
    struct(config, [{key, value}])
  end
end

