defmodule Flickrex.Support.Fixtures do
  def fixture(doc, format \\ :json) do
    File.read!("test/fixtures/#{doc}.#{format}")
  end
end
