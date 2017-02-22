defmodule Flickrex.Config do
  @moduledoc """
  Flickrex client configuration.
  """

  alias __MODULE__, as: Config

  defstruct [:consumer_key, :consumer_secret, :access_token, :access_token_secret]

  @type param :: binary | nil

  @type t :: %__MODULE__{
    consumer_key: param,
    consumer_secret: param,
    access_token: param,
    access_token_secret: param
  }

  @doc """
  Create a new Flickrex config
  """
  @spec new :: t
  def new do
    %Config{}
  end

  @doc """
  Create a new Flickrex config from the params
  """
  @spec new(Keyword.t) :: t
  def new(params) do
    struct(Config, params)
  end

  @doc """
  Merge params into a Flickrex config
  """
  @spec merge(t, Keyword.t) :: t
  def merge(config, params) do
    Map.merge(config, struct(Config, params))
  end

  @doc """
  Put a new value in a Flickrex config
  """
  @spec put(t, atom, binary) :: t
  def put(config, key, value) do
    struct(config, [{key, value}])
  end
end

