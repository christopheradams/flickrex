defmodule Flickrex.Mixfile do
  use Mix.Project

  @project_description """
  Flickr API client library for Elixir
  """

  @version "0.4.0"
  @source_url "https://github.com/christopheradams/flickrex"

  def project do
    [app: :flickrex,
     version: @version,
     elixir: "~> 1.3 or ~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     dialyzer: [
       plt_add_apps: [:mix, :eex],
       ignore_warnings: "dialyzer.ignore-warnings"
     ],
     docs: docs(),
     description: @project_description,
     source_url: @source_url,
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:inets, :logger, :oauther, :poison, :hackney, :parsexml],
     mod: {Flickrex.Application, []}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [{:oauther, "~> 1.0"},
     {:hackney, "~> 1.8.6 or ~> 1.9"},
     {:parsexml, "~> 1.0"},
     {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
     {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
     {:ex_doc, ">= 0.0.0", only: :dev},
     {:poison, "~> 3.0"}]
  end

  defp docs() do
    [
      source_ref: "v#{@version}",
      logo: "logo.png",
      main: "readme",
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
