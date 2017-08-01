defmodule Flickrex.URL do
  @moduledoc """
  Generate Flickr URLs for photos, profiles, and photostreams

  ## Examples

      get_info = Flickrex.Flickr.Photos.get_info(photo_id: "...")
      {:ok, %{body: info}} = Flickrex.request(get_info)

      photo = info["photo"]
      medium_url = Flickrex.URL.url(photo)
  """

  require EEx

  @typedoc "A photo returned by the Flickr API"
  @type photo :: map

  @profile_url "https://www.flickr.com/people/<%= user_id %>/"
  @photostream_url "https://www.flickr.com/photos/<%= user_id %>/"
  @photopage_url "https://www.flickr.com/photos/<%= user_id %>/<%= photo_id %>"
  @photosets_url "https://www.flickr.com/photos/<%= user_id %>/sets/"
  @photoset_url "https://www.flickr.com/photos/<%= user_id %>/sets/<%= photoset_id %>"
  @photo_source_url "https://farm<%= farm %>.staticflickr.com/<%= server %>/<%= id %>_<%= secret %><%= size %>.<%= format %>"

  @doc """
  URL for user profile
  """
  @spec url_profile(String.t) :: String.t
  EEx.function_from_string(:def, :url_profile, @profile_url, [:user_id])

  @doc """
  URL for user photostream
  """
  @spec url_photostream(String.t) :: String.t
  EEx.function_from_string(:def, :url_photostream, @photostream_url, [:user_id])

  @doc """
  URL for individual photo page
  """
  @spec url_photopage(String.t, String.t) :: String.t
  EEx.function_from_string(:def, :url_photopage, @photopage_url, [:user_id, :photo_id])

  @doc """
  URL for user photo sets
  """
  @spec url_photosets(String.t) :: String.t
  EEx.function_from_string(:def, :url_photosets, @photosets_url, [:user_id])

  @doc """
  URL for individual photo set
  """
  @spec url_photoset(String.t, String.t) :: String.t
  EEx.function_from_string(:def, :url_photoset, @photoset_url, [:user_id, :photoset_id])

  @spec url_photo_source(String.t, String.t, String.t, String.t, String.t, String.t) :: String.t
  EEx.function_from_string(:defp, :url_photo_source, @photo_source_url, [:farm, :server, :id, :secret, :size, :format])

  photo_sizes = %{"" => "Medium", "_b" => "Large", "_m" => "Small",
                  "_s" => "Square", "_t" => "Thumbnail",
                  "_z" => "Medium 640"}

  for {size, doc} <- photo_sizes do
    url_size = String.to_atom("url#{size}")

    @doc """
    URL for #{doc} size photo
    """
    @spec unquote(url_size)(photo) :: binary
    def unquote(url_size)(r) do
      url_photo_source(r, unquote(size), "jpg")
    end
  end

  @doc """
  URL for Original size photo
  """
  @spec url_o(photo) :: binary
  def url_o(%{"farm" => farm, "server" => server, "id" => id,
              "originalsecret" => secret, "originalformat" => format} = _r) do
    url_photo_source(farm, server, id, secret, "_o", format)
  end

  defp url_photo_source(%{"farm" => farm, "server" => server, "id" => id, "secret" => secret}, size, format) do
    url_photo_source(farm, server, id, secret, size, format)
  end
end
