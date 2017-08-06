defmodule Flickrex.Parsers.AuthTest do
  use ExUnit.Case

  alias Flickrex.Parsers

  @text_headers [{"content-type", "text/plain; charset=utf-8"}]
  @html_headers [{"content-type", "text/html; charset=utf-8"}]

  test "parse_request_token/1 parses a request token" do
    body = "oauth_callback_confirmed=true&oauth_token=TOKEN&oauth_token_secret=TOKEN_SECRET"

    response = {:ok, %{status_code: 200, headers: [], body: body}}

    parsed_response = Parsers.Auth.parse_request_token(response)

    {:ok, %{status_code: 200, headers: [], body: token}} = parsed_response

    assert token == %{
      oauth_token: "TOKEN",
      oauth_token_secret: "TOKEN_SECRET",
      oauth_callback_confirmed: true
    }
  end

  test "parse_request_token/1 parses auth errors" do
    body = "oauth_problem=consumer_key_unknown"

    response = {:ok, %{status_code: 401, headers: @text_headers, body: body}}

    parsed_response = Parsers.Auth.parse_request_token(response)

    assert parsed_response ==
    {:error, %{body: %{"oauth_problem" => "consumer_key_unknown"},
               headers: [{"content-type", "text/plain; charset=utf-8"}],
               status_code: 401}}
  end

  test "parse_request_token/1 returns other errors" do
    resp = %{status_code: 404, headers: @html_headers, body: ""}
    parsed_response = Parsers.Auth.parse_request_token({:ok, resp})

    assert {:error, resp} == parsed_response
  end

  test "parse_request_token/1 passes errors through" do
    response = {:error, %{reason: :error}}

    assert Parsers.Auth.parse_request_token(response) == response
  end

  test "parse_access_token/1 parses an access token" do
    body = "fullname=FULL%20NAME&oauth_token=TOKEN&oauth_token_secret=SECRET&user_nsid=NSID&username=USERNAME"

    response = {:ok, %{status_code: 200, headers: [], body: body}}

    parsed_response = Parsers.Auth.parse_access_token(response)

    {:ok, %{status_code: 200, headers: [], body: token}} = parsed_response

    assert token == %{
      fullname: "FULL NAME",
      oauth_token: "TOKEN",
      oauth_token_secret: "SECRET",
      user_nsid: "NSID",
      username: "USERNAME"
    }
  end

  test "parse_access_token/1 parses auth errors" do
    body = "oauth_problem=token_rejected"

    response = {:ok, %{status_code: 401, headers: @text_headers, body: body}}

    parsed_response = Parsers.Auth.parse_access_token(response)

    assert parsed_response ==
    {:error, %{body: %{"oauth_problem" => "token_rejected"},
               headers: [{"content-type", "text/plain; charset=utf-8"}],
               status_code: 401}}
  end

  test "parse_access_token/1 returns other errors" do
    resp = %{status_code: 404, headers: @html_headers, body: ""}
    parsed_response = Parsers.Auth.parse_access_token({:ok, resp})

    assert {:error, resp} == parsed_response
  end
end

