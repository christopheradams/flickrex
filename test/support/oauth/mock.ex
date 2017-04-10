defmodule Flickrex.OAuth.Mock do
  @moduledoc false

  @behaviour Flickrex.OAuth

  @type consumer_key :: Flickrex.OAuth.consumer_key
  @type consumer_secret :: Flickrex.OAuth.consumer_secret
  @type token :: Flickrex.OAuth.token
  @type token_secret :: Flickrex.OAuth.token_secret

  @ok {'HTTP/1.1', 200, 'OK'}
  @bad_request {'HTTP/1.1', 400, 'Bad Request'}
  @unauthorized {'HTTP/1.1', 401, 'Unauthorized'}

  # Send a bad consumer key/secret
  @spec request(:get | :post, binary, Keyword.t, consumer_key, consumer_secret, token, token_secret) :: tuple
  def request(:get, _url, _, "BAD_KEY", "BAD_SECRET", _, _) do
    {:ok, {@unauthorized, nil, "oauth_problem=consumer_key_unknown"}}
  end

  # Send an access token/secret when requesting a token
  def request(:get, "https://api.flickr.com/services/oauth/request_token", _, _, _, "AT", "AS") do
    {:ok, {@unauthorized, nil, "oauth_problem=siganture_invalid"}}
  end

  # Request a token
  def request(:get, "https://api.flickr.com/services/oauth/request_token", params, _, _, _, _) do
    # Send an error if oauth_callback is not provided
    case Keyword.has_key?(params, :oauth_callback) do
      true ->
        terms = %{oauth_callback_confirmed: true, oauth_token: "REQUEST_TOKEN",
                  oauth_token_secret: "REQUEST_TOKEN_SECRET"}
        body = terms |> URI.encode_query |> String.to_char_list
        {:ok, {@ok, nil, body}}
      false ->
        {:ok, {@bad_request, nil, "oauth_problem=parameter_absent&oauth_parameters_absent=oauth_callback"}}
    end
  end

  # Request an access token
  def request(:get, "https://api.flickr.com/services/oauth/access_token", params, _, _, _, _) do
    case params[:oauth_verifier] do
      "BAD_VERIFIER" ->
        {:ok, {@bad_request, nil, "oauth_problem=parameter_absent&oauth_parameters_absent=oauth_token"}}
      _verifier ->
        terms = %{fullname: "FULLNAME", oauth_token: "ACCESS_TOKEN",
                  oauth_token_secret: "ACCESS_TOKEN_SECRET",
                  user_nsid: "USER_NSID", username: "USERNAME"}
        body = terms |> URI.encode_query |> String.to_char_list
        {:ok, {@ok, nil, body}}
    end
  end

  # Make a REST method call
  def request(verb, "https://api.flickr.com/services/rest", params, _, _, _, _) do
    method = Keyword.get(params, :method)
    if method == "ERROR" do
      {:ok, {@bad_request, nil, "call error"}}
    else
      format = Keyword.get(params, :format)
      no_json = Keyword.get(params, :nojsoncallback)
      param =
        params
        |> Keyword.drop([:method, :format, :nojsoncallback])
        |> Enum.map(fn {k,v} -> "#{k}:#{v}" end)
        |> Enum.join(",")
      body = '{"verb":"#{verb}","param":"#{param}","nojsoncallback":#{no_json},"method":"#{method}","format":"#{format}","stat":"ok"}'
      {:ok, {@ok, nil, body}}
    end
  end

  # Receive a 400 error
  def request(_verb, "HTTP_ERROR", _, _, _, _, _) do
    {:ok, {@bad_request, nil, "service error"}}
  end

  # Receive an HTTPC error
  def request(_verb, "HTTPC_ERROR", _, _, _, _, _) do
    {:error, :reason}
  end

  # Echo back all arguments
  def request(method, url, params, ck, cs, at, ats) do
    args = [method: method, url: url, ck: ck, cs: cs, at: at, ats: ats]
    query = Keyword.merge(args, params)
    body = URI.encode_query(query)
    {:ok, {@ok, nil, body}}
  end
end
