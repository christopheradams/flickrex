defmodule Flickrex.Parsers.Auth do
  @moduledoc false

  alias Flickrex.Response

  @type response :: {:ok, Response.t()} | {:error, term}

  @spec parse_request_token(response) :: response
  def parse_request_token({:ok, %{status_code: 200, body: body} = resp}) do
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
      oauth_token: token,
      oauth_token_secret: secret,
      oauth_callback_confirmed: callback_confirmed
    }

    {:ok, %{resp | body: parsed_body}}
  end

  def parse_request_token(val) do
    parse_token(val)
  end

  @spec parse_access_token(response) :: response
  def parse_access_token({:ok, %{status_code: 200, body: body} = resp}) do
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

  def parse_access_token(val) do
    parse_token(val)
  end

  defp parse_token({:ok, %{status_code: code, body: body} = resp}) when code in [400, 401] do
    {:error, %{resp | body: URI.decode_query(body)}}
  end

  defp parse_token({:ok, %{status_code: status_code} = resp}) when status_code >= 400 do
    {:error, resp}
  end

  defp parse_token(val), do: val
end
