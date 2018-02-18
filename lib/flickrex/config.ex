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
    json_decoder: Flickrex.Decoder.JSON,
    rest_decoder: Flickrex.Decoder.XML,
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
    application_config =
      :flickrex
      |> Application.get_env(:config, [])
      |> Map.new()

    service_config =
      :flickrex
      |> Application.get_env(service, [])
      |> Map.new()

    config
    |> Map.merge(application_config)
    |> Map.merge(service_config)
  end
end
