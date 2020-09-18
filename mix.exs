defmodule Flickrex.Mixfile do
  use Mix.Project

  @project_description """
  Flickr API client library for Elixir
  """

  @version "0.8.0"
  @source_url "https://github.com/christopheradams/flickrex"

  def project do
    [
      app: :flickrex,
      version: @version,
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      dialyzer: [
        plt_add_apps: [:mix, :eex],
        ignore_warnings: "dialyzer.ignore-warnings"
      ],
      docs: docs(),
      description: @project_description,
      source_url: @source_url,
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:inets, :logger],
      mod: {Flickrex.Application, []}
    ]
  end

  # Exclude lib/mix from paths so that the reflect task is only available for
  # local development, and not for package users.
  @lib_paths ["lib/flickr", "lib/flickrex", "lib/flickrex.ex"]

  defp elixirc_paths(env) when env in [:dev, :docs], do: ["lib/mix" | @lib_paths]
  defp elixirc_paths(:test), do: ["test/support" | @lib_paths]
  defp elixirc_paths(_), do: @lib_paths

  defp deps do
    [
      {:oauther, "~> 1.0"},
      {:hackney, "~> 1.16.0"},
      {:jason, "~> 1.1"},
      {:parsexml, "~> 1.0"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~>  0.22", only: :docs}
    ]
  end

  defp docs() do
    [
      source_ref: "v#{@version}",
      logo: "logo.png",
      main: "readme",
      groups_for_modules: [
        "Flickr API": ~r/Flickrex\.Flickr/
      ],
      extras: [
        "README.md": [title: "README"]
      ]
    ]
  end

  defp package do
    [
      name: :flickrex,
      maintainers: ["Christopher Adams"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end
end
