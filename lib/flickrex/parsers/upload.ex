defmodule Flickrex.Parsers.Upload do

  @moduledoc false

  defdelegate parse(resp), to: Flickrex.Parsers.Rest
end
