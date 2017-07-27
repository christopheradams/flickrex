defmodule Flickrex.Auth.ParsersTest do
  use ExUnit.Case

  alias Flickrex.Auth

  test "parse_request_token/1 parses a request token" do
    body = "oauth_callback_confirmed=true&oauth_token=TOKEN&oauth_token_secret=TOKEN_SECRET"

    response = {:ok, %{status_code: 200, headers: [], body: body}}

    parsed_response = Auth.Parsers.parse_request_token(response)

    {:ok, %{status_code: 200, headers: [], body: token}} = parsed_response

    assert token == %{token: "TOKEN", secret: "TOKEN_SECRET", callback_confirmed: true}
  end

  test "parse_request_token/1 passes through responses with no body" do
    response = {:ok, %{status_code: 400, headers: []}}

    assert Auth.Parsers.parse_request_token(response) == response
  end

  test "parse_request_token/1 passes errors through" do
    response = {:error, %{reason: :error}}

    assert Auth.Parsers.parse_request_token(response) == response
  end

  test "parse_access_token/1 parses an access token" do
    body = "fullname=FULL%20NAME&oauth_token=TOKEN&oauth_token_secret=SECRET&user_nsid=NSID&username=USERNAME"

    response = {:ok, %{status_code: 200, headers: [], body: body}}

    parsed_response = Auth.Parsers.parse_access_token(response)

    {:ok, %{status_code: 200, headers: [], body: token}} = parsed_response

    assert token == %{
      fullname: "FULL NAME",
      oauth_token: "TOKEN",
      oauth_token_secret: "SECRET",
      user_nsid: "NSID",
      username: "USERNAME"
    }
  end
end

