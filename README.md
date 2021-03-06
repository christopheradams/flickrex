# Flickrex

[![Hex.pm](https://img.shields.io/hexpm/v/flickrex.svg)](https://hex.pm/packages/flickrex)
[![Hexdocs](https://img.shields.io/badge/hexdocs-prerelease-orange.svg)](http://hexdocs.pm/flickrex/)
[![Build Status](https://travis-ci.org/christopheradams/flickrex.svg?branch=master)](https://travis-ci.org/christopheradams/flickrex)

Flickr client library for Elixir.

The package's main modules are:

* `Flickrex` - performs API requests.
* `Flickrex.Auth` - handles authentication.
* `Flickrex.Flickr` - mirrors the Flickr API method namespace.
* `Flickrex.Upload` - handles photo uploads.
* `Flickrex.URL` - generates Flickr URLs for photos, etc.

Install the latest version of Flickrex from [https://hex.pm/packages/flickrex](https://hex.pm/packages/flickrex)

Documentation is available at [http://hexdocs.pm/flickrex](http://hexdocs.pm/flickrex)

Source code is available at [https://github.com/christopheradams/flickrex](https://github.com/christopheradams/flickrex)

## Hello World

```elixir
{:ok, resp} = Flickrex.Flickr.Photos.get_recent() |> Flickrex.request()

%{"photos" => photos} = resp.body
```

## Installation

Add `flickrex` to your list of applications and dependencies in `mix.exs`:

```elixir
def application do
  [applications: [:logger, :flickrex]]
end

def deps do
  [{:flickrex, "~> 0.8"}]
end
```

## Configuration

[Create an application](https://www.flickr.com/services/apps/create/apply/) on
Flickr and add the API keys to your Mix config file:

```elixir
config :flickrex, :config, [
  consumer_key:    "...",
  consumer_secret: "...",
]
```

The configuration also accepts `oauth_token` and `oauth_token_secret` keys, but
it is highly recommended to store these values separately for each authenticated
user, rather than setting them globally.

## Usage

### Flickr API

```elixir
operation = Flickrex.Flickr.Photos.get_recent(per_page: 5)
{:ok, resp} = Flickrex.request(operation)

%{"photos" => photos} = resp.body
```

### Configuration Override

```elixir
config = [consumer_key: "...", consumer_secret: "..."]
{:ok, resp} = Flickrex.request(operation, config)
```

### Authentication

```elixir
{:ok, %{body: request}} = Flickrex.Auth.request_token() |> Flickrex.request()

{:ok, auth_url} =
  request.oauth_token
  |> Flickrex.Auth.authorize_url()
  |> Flickrex.request()

# Open the URL in your browser, authorize the app, and get the verify token
verifier = "..."

{:ok, %{body: access}} =
  request.oauth_token
  |> Flickrex.Auth.access_token(request.oauth_token_secret, verifier)
  |> Flickrex.request()

# You can now call methods that require authorization
config = [oauth_token: access.oauth_token, oauth_token_secret: access.oauth_token_secret]
{:ok, resp} = Flickrex.Flickr.Test.login() |> Flickrex.request(config)
```

## Testing

Run the test suite:

```sh
mix test
```

To run a test that hits the Flickr API, set these environment variables:

* `FLICKR_CONSUMER_KEY`
* `FLICKR_CONSUMER_SECRET`

Run the test with:

```sh
mix test --only flickr_api
```

If testing this package on [Travis CI](https://travis-ci.com/), the same Flickr
environment variables must be set for the repository.

### Bypass and Mocks

If you are using the Flickrex package in your own application, you have the
option of bypassing the endpoint URLs or mocking the HTTP client, either in your
config file or in options passed to `Flickrex.request/2`.

An HTTP client mock needs to implement the `Flickrex.Request.HttpClient`
behaviour.

```elixir
# test.exs
config :flickrex, :config, [
  http_client: MyApp.Flickrex.MockClient,
]
```

If bypassing the endpoints, the URLs are set separately for each service:

```elixir
# test.exs
config :flickrex, :api, url: "http://localhost/api"
config :flickrex, :upload, url: "http://localhost/upload"
```

## Development

The `Flickr` modules are generated using data from the Flickr APIs reflection
methods. If the API ever changes, new data can be fetched with the Mix task:

```
mix flickrex.reflect
```

The data files are committed to the repository so that network and API access is
not required to compile this library.

## Documentation

To build the documentation from source:

```
mix docs
```

## License

Flickrex copyright © 2017,
[Christopher Adams](https://github.com/christopheradams)

Flickrex logo based on Venn Diagram CC-by Eddy Ymeri
