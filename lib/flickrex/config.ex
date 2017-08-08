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
    :oauth_token,
    :oauth_token_secret,
    :url,
    http_client: Flickrex.Request.Hackney,
  ]

  @spec new(atom, Keyword.t) :: t
  def new(service, opts \\ []) do
    overrides = Map.new(opts)

    config =
      service
      |> get_defaults()
      |> get_env(service)
      |> Map.merge(overrides)

    struct(Config, config)
  end

  # Gets the default configuration for a service.
  for {service, config} <- @defaults do
    defp get_defaults(unquote(service)), do: unquote(Macro.escape(config))
  end

  # Gets the environment configuration.
  defp get_env(config, service) do
    oauth_config =
      :flickrex
      |> Application.get_env(:oauth, [])
      |> cast_keys()

    service_config =
      :flickrex
      |> Application.get_env(service, [])
      |> Map.new()

    client_config =
      case  Application.get_env(:flickrex, :http_client) do
        nil -> %{}
        client -> %{http_client: client}
      end

    config
    |> Map.merge(oauth_config)
    |> Map.merge(service_config)
    |> Map.merge(client_config)
  end

  defp cast_keys(env) do
    Map.new(env, &cast_key/1)
  end

  defp cast_key({:access_token, t}), do: {:oauth_token, t}
  defp cast_key({:access_token_secret, s}), do: {:oauth_token_secret, s}
  defp cast_key(kv), do: kv
end

