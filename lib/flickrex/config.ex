defmodule Flickrex.Config do

  @moduledoc false

  alias __MODULE__, as: Config

  @type t :: %Config{}

  @defaults %{
    api: %{
      url: "https://api.flickr.com/",
    },
    upload: %{
      url: "https://up.flickr.com/",
    }
  }

  defstruct [
    :consumer_key,
    :consumer_secret,
    :access_token,
    :access_token_secret,
    :url,
  ]

  @spec new(atom, Keyword.t) :: t
  def new(service, opts \\ []) do
    overrides = Map.new(opts)

    config =
      service
      |> get_defaults()
      |> get_env()
      |> Map.merge(overrides)

    struct(Config, config)
  end

  # Gets the default configuration for a service.
  for {service, config} <- @defaults do
    defp get_defaults(unquote(service)), do: unquote(Macro.escape(config))
  end

  # Gets the environment configuration.
  def get_env(config) do
    env =
      :flickrex
      |> Application.get_env(:oauth)
      |> Map.new()

    Map.merge(config, env)
  end
end

