defmodule Flickrex.ConnectionError do
  defexception [:reason, message: "connection error"]
end
