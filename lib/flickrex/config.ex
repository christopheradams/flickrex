defmodule Flickrex.Config do
  @moduledoc false

  alias __MODULE__, as: Config

  @type t :: %Config{}

  @defaults %{
    api: %{
      url: "https://api.flickr.com/"
    },
    upload: %{
      url: "https://up.flickr.com/"
    }
  }

  defstruct [
    :consumer_key,
    :consumer_secret,
    :oauth_token,
    :oauth_token_secret,
    :url,
    http_client: Flickrex.Request.Hackney,
    http_opts: []
  ]

  @spec new(atom, Keyword.t()) :: t
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

    unless is_nil(Application.get_env(:flickrex, :oauth)) do
      IO.warn("""
      Application :flickrex, :oauth is deprecated in favor of :flickrex, :config.
      See the Flickrex package README for configuration options.
      """)
    end

    application_config =
      :flickrex
      |> Application.get_env(:config, [])
      |> Map.new()

    service_config =
      :flickrex
      |> Application.get_env(service, [])
      |> Map.new()

    config
    |> Map.merge(oauth_config)
    |> Map.merge(application_config)
    |> Map.merge(service_config)
  end

  defp cast_keys(env) do
    Map.new(env, &cast_key/1)
  end

  defp cast_key({:access_token, t}), do: {:oauth_token, t}
  defp cast_key({:access_token_secret, s}), do: {:oauth_token_secret, s}
  defp cast_key(kv), do: kv
end
