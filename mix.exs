defmodule Flickrex.Mixfile do
  use Mix.Project

  @project_description """
  Flickr API client library for Elixir
  """

  @version "0.1.0"
  @source_url "https://github.com/christopheradams/flickrex"

  def project do
    [app: :flickrex,
     version: @version,
     elixir: "~> 1.3 or ~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     docs: docs(),
     description: @project_description,
     source_url: @source_url,
     package: package(),
     deps: deps()]
  end

  def application do
    [extra_applications: [:inets, :logger],
     mod: {Flickrex.Application, []}]
  end

  defp deps do
    [{:oauther, "~> 1.0"},
     {:dialyxir, "~> 0.4", only: [:dev], runtime: false},
     {:credo, "~> 0.5", only: [:dev, :test], runtime: false},
     {:ex_doc, ">= 0.0.0", only: :dev},
     {:poison, "~> 3.0"}]
  end

  defp docs() do
    [
      source_ref: "v#{@version}",
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
