defmodule Flickrex.Upload do
  @moduledoc """
  Operations on Flickr Upload Service.

  ## Examples

      photo = "path/to/photo.png"

      {:ok, resp} =
        photo
        |> Flickrex.Upload.upload(is_public: 0)
        |> Flickrex.request()

  Because response content type of photo uploads are always in XML, the body is
  parsed as a list of tuples that represent the document, e.g:

      {"rsp", [{"stat", "ok"}], [{"photoid", [], ["35467821184"]}]}
  """

  alias Flickrex.Operation

  @doc """
  Upload a photo to the Flickr API.

  This method requires authentication with write permission.

  ## Options

  * `title` - The title of the photo.
  * `description` - A description of the photo. May contain some limited HTML.
  * `tags` - A space-seperated list of tags to apply to the photo.
  * `is_public`, `is_friend`, `is_family` - Set to 0 for no, 1 for
    yes. Specifies who can view the photo. If omitted permissions will be set to
    user's default
  * `safety_level` - Set to 1 for Safe, 2 for Moderate, or 3 for Restricted. If
    omitted or an invalid value is passed, will be set to user's default
  * `content_type` - Set to 1 for Photo, 2 for Screenshot, or 3 for Other. If
    omitted , will be set to user's default
  * `hidden` - Set to 1 to keep the photo in global search results, 2 to hide from
    public searches. If omitted, will be set based to user's default
  """
  def upload(photo, opts \\ []) do
    Operation.Upload.new(:upload, photo, opts)
  end

  @doc """
  Replace a photo on the Flickr API.

  ## Options

  * `photo_id` - The ID of the photo to replace. <small>**(required)**</small>
  * `async`
  """
  def replace(photo, opts \\ []) do
    Operation.Upload.new(:replace, photo, opts)
  end
end
