defmodule Flickr do
  @moduledoc false

  # Flickr directory
  flickr_dir = Path.join([__DIR__], "flickr")

  # A local copy of "flickr.reflection.getMethods"
  methods_file = Path.join(flickr_dir, "flickr.reflection.getMethods.json")

  # Directory holding a JSON info file for each method
  methods_dir = Path.join(flickr_dir, "getMethodInfo")
  methods_files = File.ls!(methods_dir)

  # Group Flickr methods based on the module they will be included in
  methods_modules =
    methods_file
    |> File.read!
    |> Poison.decode!
    |> get_in(["methods", "method"])
    |> Enum.map(fn %{"_content" => m} -> m end)
    |> Enum.group_by(fn m -> m |> String.split(".") |> List.delete_at(-1) end)

  for {aliases, methods} <- methods_modules do
    # Generate a module name for each method namespace, e.g.
    # `Flickr.Photos.People` for "flickr.photos.people"
    module =
      aliases
      |> Enum.map(&String.capitalize/1)
      |> Enum.map(&String.to_atom/1)
      |> Module.concat

    defmodule module do
      @moduledoc false
      @type client :: Flickrex.Client.t
      @type args :: Keyword.t
      @type response :: Flickrex.Parser.response

      for method <- methods do
        # Generate the function name from the method, e.g. `get_list` for
        # "flickr.photos.people.getList"
        function =
          method
          |> String.split(".")
          |> Enum.reverse
          |> List.first
          |> Macro.underscore
          |> String.to_atom

        method_file = "#{method}.json"
        method_info =
          case method_file in methods_files do
            true ->
              methods_dir
              |> Path.join(method_file)
              |> File.read!
              |> Poison.decode!
            false ->
              %{}
          end

        description = get_in(method_info, ["method", "description", "_content"])
        needs_login = get_in(method_info, ["method", "needslogin"])

        requiredperms = get_in(method_info, ["method", "requiredperms"])
        permission_code =
          if is_binary(requiredperms) do
            String.to_integer(requiredperms)
          else
            requiredperms
          end

        permission =
          case permission_code do
            0 -> "no"
            1 -> "read"
            2 -> "write"
            3 -> "delete"
          end

        arguments =
          method_info
          |> get_in(["arguments", "argument"])
          |> Enum.reject(fn a -> a["name"] == "api_key" end)
          |> Enum.map(fn a -> case is_binary(a["optional"]) do
              true -> Map.put(a, "optional", String.to_integer(a["optional"]))
              false -> a
            end
          end)

        doc_source = """
        <%= @description %>

        <%= if @needs_login == 1 do %>
        This method requires authentication with "<%= @permission %>" permission.
        <% else %>
        This method does not require authentication.
        <% end %>

        ## Arguments

        <%= for arg <- @arguments do %>
        * `<%= arg["name"] %>` - <%= if arg["optional"] == 0 do %> <small>**(required)**</small> <% end %> <%= String.replace(arg["_content"], "\n", " ") %>
        <% end %>
        """

        assigns = [description: description, arguments: arguments,
                   needs_login: needs_login, permission: permission]

        doc = EEx.eval_string(doc_source, assigns: assigns)

        verb =
          case permission_code do
            0 -> :get
            1 -> :get
            2 -> :post
            3 -> :post
          end

        @doc doc
        @spec unquote(function)(client, args) :: response
        # FIXME: This line crashes Credo.
        def unquote(function)(client, args \\ []) do
          IO.warn("#{unquote(function)} is deprecated.")
          Flickrex.unquote(verb)(client, unquote(method), args)
        end
      end
    end
  end
end
