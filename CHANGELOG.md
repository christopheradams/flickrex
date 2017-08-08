# Changelog

## v0.4.0 (2017-08-08)

* Enhancements
  * [Flickrex] New API for creating Flickr API operations and performing requests.
  * [Upload] Added photo upload and replace support.
  * [Flickr] Testimonials module

* Deprecations
  * [Flickrex] Client, config, and get/post request functions are deprecated in
    favor of the new operation/request API.
  * [Flickr] All `Flickr` modules have been deprecated in favor of `Flickrex.Flickr`.

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
