defmodule Flickrex.Client do
  @moduledoc """
  Flickrex Client configuration
  """

  alias __MODULE__, as: Client
  alias Flickrex.Client.Consumer
  alias Flickrex.Client.Access

  defstruct [consumer: %Consumer{}, access: %Access{}]

  @type t :: %__MODULE__{
    consumer: Consumer.t,
    access: Access.t
  }

  @doc """
  Create a new Flickrex client
  """
  @spec new :: t
  def new do
    %Client{}
  end

  @doc """
  Create a new client from the config
  """
  @spec new(Keyword.t) :: t
  def new(config) do
    consumer = %Consumer{key: config[:consumer_key], secret: config[:consumer_secret]}
    access = %Access{token: config[:access_token], secret: config[:access_token_secret]}
    %Client{consumer: consumer, access: access}
  end

  @doc """
  Get the client config
  """
  @spec config(Client.t) :: Keyword.t
  def config(%Client{} = client) do
    [consumer_key: client.consumer.key, consumer_secret: client.consumer.secret,
     access_token: client.access.token, access_token_secret: client.access.secret]
  end

  @doc """
  Get a client config parameter
  """
  @spec get(Client.t, atom) :: String.t
  def get(%Client{} = client, key) do
    client |> config |> Keyword.get(key)
  end

  @doc """
  Set a client config parameter
  """
  @spec put(Client.t, atom, String.t) :: Client.t
  def put(%Client{} = client, key, value) do
    client |> config |> Keyword.put(key, value) |> new
  end
end
