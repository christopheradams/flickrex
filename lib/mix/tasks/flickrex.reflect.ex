defmodule Mix.Tasks.Flickrex.Reflect do
  use Mix.Task

  import Mix.Generator

  @shortdoc "Saves Flickr API reflection data locally"

  @moduledoc """
  Saves Flickr API method information to the fixture directory

      mix flickrex.reflect

  Requires that Flickr tokens be configured.
  """

  @flickr_dir Path.join(".", "lib/flickr")
  @methods_dir Path.join(@flickr_dir, "getMethodInfo")

  @spec run(any) :: list
  def run(_args) do
    methods_file = Path.join(@flickr_dir, "flickr.reflection.getMethods.json")
    create_directory(@methods_dir)

    flickrex = Flickrex.new
    {:ok, methods_json} = Flickrex.API.Base.call(flickrex, :get, "flickr.reflection.getMethods")
    methods = Poison.decode!(methods_json)
    pretty_methods_json = Poison.encode!(methods, pretty: true)
    File.write(methods_file, pretty_methods_json)

    methods
    |> get_in(["methods", "method"])
    |> Enum.map(fn %{"_content" => m} -> m end)
    |> Enum.map(&reflect/1)
  end

  @spec reflect(binary) :: :ok
  defp reflect(method) do
    info_file = Path.join(@methods_dir, "#{method}.json")
    flickrex = Flickrex.new
    {:ok, info_json} = Flickrex.API.Base.call(flickrex, :get,
      "flickr.reflection.getMethodInfo", method_name: method)
    info = Poison.decode!(info_json)
    pretty_json = Poison.encode!(info, pretty: true)
    Mix.shell.info("Saving #{info_file}")
    File.write(info_file, pretty_json)
  end
end
