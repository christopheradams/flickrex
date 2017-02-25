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
photos = Flickr.Photos.get_recent(flickrex)
```

## Installation

Add `flickrex` to your list of applications and dependencies in `mix.exs`:

```elixir
def application do
  [applications: [:logger, :flickrex]]
end

def deps do
  [{:flickrex, "~> 0.1.0"}]
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

### Create a Flickrex config

```elixir
flickrex = Flickrex.new
```

### Module API

```elixir
photos = Flickr.Photos.get_recent(flickrex)
id = photos["photos"]["photo"] |> List.first |> Map.get("id")
info = Flickr.Photos.get_info(flickrex, photo_id: id)
title = info["photo"]["title"]["_content"]
```

### Manual API

```
photos = Flickrex.get(flickrex, "flickr.photos.getRecent")
info = Flickrex.get(flickrex, "flickr.photos.getInfo", photo_id: id)
```

### Authentication

```elixir
flickrex = Flickrex.new
token = Flickrex.get_request_token(flickrex)
auth_url = Flickrex.get_authorize_url(token)

# Open the URL in your browser, authorize the app, and get the verify token
verify = "..."
flickrex = Flickrex.fetch_access_token(flickrex, token, verify)
login = Flickr.Test.login(flickrex)

# save flickrex.access_token and flickrex.access_token_secret for this user
```

If the user has already been authenticated, you can reuse the access token and access secret:

```elixir
tokens = [access_token: "...", access_token_secret: "..."]
flickrex = Flickrex.new |> Flickrex.config(tokens)
login = Flickr.Test.login(flickrex)
```

## Testing

Run the test suite:

```sh
mix test
```

To run a test that hits the Flickr API, set these environment variables to your
real tokens: `FLICKR_CONSUMER_KEY`, `FLICKR_CONSUMER_SECRET`,
`FLICKR_ACCESS_TOKEN`, `FLICKR_ACCESS_SECRET`.

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
