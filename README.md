# Flickrex

Flickr client library for Elixir.

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
Flickr and make note of the API Key and Secret.

Add the API keys to your Mix config file:

```elixir
config :flickrex, :oauth, [
  consumer_key:    "...",
  consumer_secret: "...",
]
```

## Usage

### Simple

```elixir
flickrex = Flickrex.new
list = Flickrex.call(flickrex, "flickr.photos.getRecent")
id = list["photos"]["photo"] |> List.first |> Map.get("id")
info = Flickrex.call(flickrex, "flickr.photos.getInfo", photo_id: id)
title = info["photo"]["title"]["_content"]
```

### Authentication

```elixir
flickrex = Flickrex.new
token = Flickrex.get_request_token(flickrex)
auth_url = Flickrex.get_authorize_url(token)

# Open the URL in your browser, authorize the app, and get the verify token
verify = "..."
flickrex = Flickrex.fetch_access_token(flickrex, token, verify)
login = Flickrex.call(flickrex, "flickr.test.login")

# save flickrex.access_token and flickrex.access_token_secret for this user
```

If the user has already been authenticated, you can reuse the access token and access secret:

```elixir
tokens = [access_token: "...", access_token_secret: "..."]
flickrex = Flickrex.new |> Flickrex.config(tokens)
login = Flickrex.call(flickrex, "flickr.test.login")
```
