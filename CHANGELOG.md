# Changelog

## v0.3.0 (2017-03-03)

* Backwards incompatible changes
  * [Flickrex] Return {:ok, response} or {:error, reason} for API calls
  * [Config] Change client configuration and token access flow

## v0.2.0 (2017-02-27)

* Enhancements
  * Flickr API modules

* Backwards incompatible changes
  * [API.Base] `call/4/` requires an HTTP verb and returns unparsed JSON binary
  * [Flickrex] `call/3` renamed to `get/3`
