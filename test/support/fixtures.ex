defmodule Flickrex.Support.Fixtures do
  @moduledoc false

  def fixture(doc, format \\ :json) do
    File.read!("test/fixtures/#{doc}.#{format}")
  end

  def consumer_key do
    "653e7a6ecc1d528c516cc8f92cf98611"
  end

  def consumer_secret do
    "90da57db88379529"
  end

  def request_token do
    %{
      oauth_callback_confirmed: true,
      oauth_token: "72157626737672178-022bbd2f4c2f3432",
      oauth_token_secret: "fccb68c4e6103197"
    }
  end

  def request_token(key) do
    Map.get(request_token(), key)
  end

  def access_token do
    %{
      fullname: "Jamal Fanaian",
      oauth_token: "72157626318069415-087bfc7b5816092c",
      oauth_token_secret: "a202d1f853ec69de",
      user_nsid: "21207597@N07",
      username: "jamalfanaian"
    }
  end

  def access_token(key) do
    Map.get(access_token(), key)
  end

  def verifier do
    "5d1b96a26b494074"
  end
end
