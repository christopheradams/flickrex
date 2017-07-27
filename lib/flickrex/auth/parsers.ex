defmodule Flickrex.Auth.Parsers do

  @moduledoc false

  def parse_request_token({:ok, %{body: body} = resp}) do
    oauth_token = URI.decode_query(body, %{})

    token = oauth_token["oauth_token"]
    secret = oauth_token["oauth_token_secret"]

    callback_confirmed =
      case oauth_token["oauth_callback_confirmed"] do
        "true" -> true
        "false" -> false
        _ -> nil
      end

    parsed_body = %{
      token: token,
      secret: secret,
      callback_confirmed: callback_confirmed,
    }

    {:ok, %{resp | body: parsed_body}}
  end

  def parse_request_token(val), do: val

  def parse_access_token({:ok, %{body: body} = resp}) do
    access_token = URI.decode_query(body, %{})

    parsed_body = %{
      fullname: access_token["fullname"],
      oauth_token: access_token["oauth_token"],
      oauth_token_secret: access_token["oauth_token_secret"],
      user_nsid: access_token["user_nsid"],
      username: access_token["username"]
    }

    {:ok, %{resp | body: parsed_body}}
  end

  def parse_access_token(val), do: val
end
