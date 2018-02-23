defmodule Flickrex.Flickr do
  @moduledoc """
  Flickr API Modules.

  These modules and functions map to the methods from the Flickr [API
  Documentation](https://www.flickr.com/services/api/).

  Arguments for the API methods should be strings, or integers (if the API
  method accepts a number). Any additional `opts` will be set as params for the
  Rest operation.

  Each function returns an operation that can be executed with
  `Flickrex.request/2`.

  Some Flickr methods require user access tokens that were granted read, write,
  or delete permissions.

  ## Examples

  Get the five most recent public photos:

      get_recent = Flickrex.Flickr.Photos.get_recent(per_page: 5)
      {:ok, resp} = Flickrex.request(get_recent)

      %{"photos" => photos} = resp.body

  Test logging in as a user, by configuring the tokens for the request:

      config = [oauth_token: "...", oauth_token_secret: "..."]
      {:ok, resp} = Flickrex.Flickr.Test.login() |> Flickrex.request(config)

      %{"user" => user} = resp.body

  The API methods will return an error tuple if there was a problem with the
  request:

      {:error, resp} = Flickrex.Flickr.Photos.get_info() |> Flickrex.request()
      resp.body == %{"code" => 1, "message" => "Photo not found", "stat" => "fail"}
  """

  # Flickr directory
  flickr_dir = Path.join(File.cwd!(), "/lib/flickr")

  # A local copy of "flickr.reflection.getMethods"
  methods_file = Path.join(flickr_dir, "flickr.reflection.getMethods.json")

  # Directory holding a JSON info file for each method
  methods_dir = Path.join(flickr_dir, "getMethodInfo")
  methods_files = File.ls!(methods_dir)

  # Recompile this module when the source files change
  @external_resource methods_file

  for method_file <- methods_files do
    @external_resource Path.join(methods_dir, method_file)
  end

  # Group Flickr methods based on the module they will be included in
  methods_modules =
    methods_file
    |> File.read!()
    |> Jason.decode!()
    |> get_in(["methods", "method"])
    |> Enum.map(fn %{"_content" => m} -> m end)
    |> Enum.group_by(fn m -> m |> String.split(".") |> List.delete_at(-1) end)

  for {[_ | namespaces], methods} <- methods_modules do
    # Generate a module name for each method namespace, e.g.
    # `Flickr.Photos.People` for "flickr.photos.people"
    aliases = ["flickrex", "flickr"] ++ namespaces

    module =
      aliases
      |> Enum.map(&String.capitalize/1)
      |> Enum.map(&String.to_atom/1)
      |> Module.concat()

    defmodule module do
      @type arg :: String.Chars.t()
      @type opts :: Flickrex.Rest.args()
      @type operation :: Flickrex.Operation.Rest.t()

      for method <- methods do
        # Generate the function name from the method, e.g. `get_list` for
        # "flickr.photos.people.getList"
        function =
          method
          |> String.split(".")
          |> Enum.reverse()
          |> List.first()
          |> Macro.underscore()
          |> String.to_atom()

        method_file = "#{method}.json"

        method_info =
          case method_file in methods_files do
            true ->
              methods_dir
              |> Path.join(method_file)
              |> File.read!()
              |> Jason.decode!()

            false ->
              %{}
          end

        description =
          method_info
          |> get_in(["method", "description", "_content"])
          |> String.replace("\"/services/api/", "\"https://www.flickr.com/services/api/")
          |> String.replace(~r/<br\ ?\/>/, " ")

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
          |> Enum.map(fn a ->
            case is_binary(a["optional"]) do
              true -> Map.put(a, "optional", String.to_integer(a["optional"]))
              false -> a
            end
          end)
          |> Enum.map(fn argument ->
            content =
              argument
              |> Map.get("_content")
              |> String.replace("\n", " ")
              |> String.replace("\"/services/api/", "\"https://www.flickr.com/services/api/")

            Map.put(argument, "_content", content)
          end)

        {required_args, optional_args} =
          Enum.split_with(arguments, fn
            %{"optional" => 0} -> true
            _ -> false
          end)

        args_names = Enum.map(required_args, fn %{"name" => name} -> String.to_atom(name) end)
        args_vars = Enum.map(args_names, &Macro.var(&1, __MODULE__))
        args_specs = Enum.map(args_names, fn _ -> Macro.var(:arg, __MODULE__) end)
        args_params = Enum.zip(args_names, args_vars)

        doc_source = """
        <%= @description %>

        <%= if @needs_login == 1 do %>
        This method requires authentication with "<%= @permission %>" permission.
        <% else %>
        This method does not require authentication.
        <% end %>

        <%= if length(@required_args) > 0 do %>
        ## Arguments
        <% end %>

        <%= for arg <- @required_args do %>
        * `<%= arg["name"] %>` - <%= arg["_content"] %>
        <% end %>

        <%= if length(@optional_args) > 0 do %>
        ## Options
        <% end %>

        <%= for arg <- @optional_args do %>
        * `<%= arg["name"] %>` - <%= arg["_content"] %>
        <% end %>
        """

        assigns = [
          description: description,
          required_args: required_args,
          optional_args: optional_args,
          needs_login: needs_login,
          permission: permission
        ]

        doc = EEx.eval_string(doc_source, assigns: assigns)

        verb =
          case permission_code do
            0 -> :get
            1 -> :get
            2 -> :post
            3 -> :post
          end

        # If a function has required params, still allow a function call that
        # takes all parameters as options
        if length(required_args) > 0 do
          @spec unquote(function)() :: operation
          def unquote(function)() do
            Flickrex.Rest.unquote(verb)(unquote(method))
          end

          @spec unquote(function)(opts) :: operation
          def unquote(function)(opts) when is_list(opts) do
            Flickrex.Rest.unquote(verb)(unquote(method), opts)
          end
        end

        @doc doc
        @spec unquote(function)(unquote_splicing(args_specs), opts) :: operation
        def unquote(function)(unquote_splicing(args_vars), opts \\ []) do
          Flickrex.Rest.unquote(verb)(unquote(method), unquote(args_params) ++ opts)
        end
      end
    end
  end
end
