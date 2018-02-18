defmodule Flickrex.Response do
  @moduledoc """
  Defines a Flickr response.
  """

  alias __MODULE__, as: Response

  @type t :: %Response{
          status_code: pos_integer,
          headers: [{binary, binary}],
          body: term
        }

  defstruct [
    :status_code,
    :body,
    :headers
  ]
end
