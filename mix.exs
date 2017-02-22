defmodule Flickrex.Mixfile do
  use Mix.Project

  def project do
    [app: :flickrex,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
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
     {:poison, "~> 3.0"}]
  end
end
