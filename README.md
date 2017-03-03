# Flickrex

[![Build Status](https://travis-ci.org/christopheradams/flickrex.svg?branch=master)](https://travis-ci.org/christopheradams/flickrex)
[![Hex Version](https://img.shields.io/hexpm/v/flickrex.svg)](https://hex.pm/packages/flickrex)

Flickr client library for Elixir.

The package has two main modules:

* `Flickrex` - handles configuration and authentication for the API.
* `Flickr` - mirrors the Flickr API method namespace.

[Documentation for Flickrex is available on hexdocs](http://hexdocs.pm/flickrex/).<br/>
[Source code is available on Github](https://github.com/christopheradams/flickrex).<br/>
[Package is available on hex](https://hex.pm/packages/flickrex).

## Hello World

```elixir
flickrex = Flickrex.new
{:ok, photos} = Flickr.Photos.get_recent(flickrex)
```

## Installation

Add `flickrex` to your list of applications and dependencies in `mix.exs`:

```elixir
def application do
  [applications: [:logger, :flickrex]]
end

def deps do
  [{:flickrex, "~> 0.3.0"}]
end
```

## Configuration

[Create an application](https://www.flickr.com/services/apps/create/apply/) on
Flickr and add the API keys to your Mix config file:

```elixir
config :flickrex, :oauth, [
  consumer_key:    "...",
  consumer_secret: "...",
]
```

## Usage

### Create a Flickrex client

```elixir
flickrex = Flickrex.new
```

### Module API

```elixir
{:ok, photos} = Flickr.Photos.get_recent(flickrex)
id = photos["photos"]["photo"] |> List.first |> Map.get("id")
{:ok, info} = Flickr.Photos.get_info(flickrex, photo_id: id)
title = info["photo"]["title"]["_content"]
```

### Manual API

```
{:ok, info} = Flickrex.get(flickrex, "flickr.photos.getInfo", photo_id: id)
```

### Authentication

```elixir
flickrex = Flickrex.new
{:ok, request} = Flickrex.fetch_request_token(flickrex)
auth_url = Flickrex.get_authorize_url(request)

# Open the URL in your browser, authorize the app, and get the verify token
verify = "..."
{:ok, access} = Flickrex.fetch_access_token(flickrex, request, verify)
flickrex = Flickrex.put_access_token(flickrex, access)

# You can now call methods that require authorization
{:ok, login} = Flickr.Test.login(flickrex)
```

You can save `flickrex.access.token` and `flickrex.access.secret`, then later
create a new client with the saved tokens:

```elixir
# fetch `access_token` and `access_token_secret` from disk or memory
flickrex = Flickrex.new |> Flickrex.put_access_token(access_token, access_token_secret)
```

## Testing

Run the test suite:

```sh
mix test
```

To run a test that hits the Flickr API, set these environment variables to your
API keys: `FLICKR_CONSUMER_KEY`, `FLICKR_CONSUMER_SECRET`.

Run the test with:

```sh
mix test --only flickr_api
```

## Development

The `Flickr` modules are generated using data from the Flickr APIs reflection
methods. If the API ever changes, new data can be fetched with the Mix task:

```
mix flickrex.reflect
```

The data files are commited to the repository so that network and API access is
not required to compile this library.
