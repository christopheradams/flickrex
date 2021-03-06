defmodule Flickrex.Parsers.AuthTest do
  use ExUnit.Case

  alias Flickrex.Parsers

  import Flickrex.Support.Fixtures

  @text_headers [{"Content-Type", "text/plain; charset=utf-8"}]
  @html_headers [{"Content-Type", "text/html; charset=utf-8"}]

  test "parse_request_token/1 parses a request token" do
    body = URI.encode_query(request_token())

    response = {:ok, %{status_code: 200, headers: [], body: body}}

    parsed_response = Parsers.Auth.parse_request_token(response)

    {:ok, %{status_code: 200, headers: [], body: token}} = parsed_response

    assert token == request_token()
  end

  test "parse_request_token/1 parses request errors" do
    body = "oauth_problem=parameter_absent&oauth_parameters_absent=oauth_callback"

    response = {:ok, %{status_code: 400, headers: @text_headers, body: body}}

    parsed_response = Parsers.Auth.parse_request_token(response)

    expected_response =
      {:error,
       %{
         body: %{
           "oauth_parameters_absent" => "oauth_callback",
           "oauth_problem" => "parameter_absent"
         },
         headers: [{"Content-Type", "text/plain; charset=utf-8"}],
         status_code: 400
       }}

    assert parsed_response == expected_response
  end

  test "parse_request_token/1 parses auth errors" do
    body = "oauth_problem=consumer_key_unknown"

    response = {:ok, %{status_code: 401, headers: @text_headers, body: body}}

    parsed_response = Parsers.Auth.parse_request_token(response)

    expected_response =
      {:error,
       %{
         body: %{"oauth_problem" => "consumer_key_unknown"},
         headers: [{"Content-Type", "text/plain; charset=utf-8"}],
         status_code: 401
       }}

    assert parsed_response == expected_response
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
    body = URI.encode_query(access_token())

    response = {:ok, %{status_code: 200, headers: [], body: body}}

    parsed_response = Parsers.Auth.parse_access_token(response)

    {:ok, %{status_code: 200, headers: [], body: token}} = parsed_response

    assert token == access_token()
  end

  test "parse_access_token/1 parses auth errors" do
    body = "oauth_problem=token_rejected"

    response = {:ok, %{status_code: 401, headers: @text_headers, body: body}}

    parsed_response = Parsers.Auth.parse_access_token(response)

    expected_response =
      {:error,
       %{
         body: %{"oauth_problem" => "token_rejected"},
         headers: [{"Content-Type", "text/plain; charset=utf-8"}],
         status_code: 401
       }}

    assert parsed_response == expected_response
  end

  test "parse_access_token/1 returns other errors" do
    resp = %{status_code: 404, headers: @html_headers, body: ""}
    parsed_response = Parsers.Auth.parse_access_token({:ok, resp})

    assert {:error, resp} == parsed_response
  end
end
