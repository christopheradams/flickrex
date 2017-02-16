defmodule Flickrex.Config do
  alias __MODULE__, as: Config

  defstruct [:consumer_key, :consumer_secret, :access_token, :access_token_secret]

  @doc """
  TODO
  """
  def new do
    new(Application.get_env(:flickrex, :oauth))
  end

  @doc """
  TODO
  """
  def new(params) do
    struct(Config, params)
  end

  @doc """
  TODO
  """
  def merge(config, params) do
    Map.merge(config, struct(Config, params))
  end

  @doc """
  TODO
  """
  def put(config, key, value) do
    struct(config, [{key, value}])
  end
end

