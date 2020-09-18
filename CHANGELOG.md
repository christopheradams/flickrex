# Changelog

## v0.8.1 (2020-09-18)

* Fixes
  * [Mix] Update hackney dependency to fix benoitc/hackney#589

## v0.8.0 (2019-03-15)

* Enhancements
  * [Flickr] Include example responses in Flickr API documentation.

## v0.7.0 (2018-03-15)

* Enhancements
  * [Flickr] Create functions for API methods with required arguments.
  * [Parsers] Parse 400 error response bodies for tokens.

* Deprecations
  * [Flickr] Calling an API function with required arguments using just an
    options list is deprecated.
  * [Upload] Calling replace with `photo_id` as an option is deprecated.

* Backwards incompatible changes
  * [Auth] Rename access token `verifier` to `oauth_verifier`.

## v0.6.0 (2018-02-20)

* Enhancements
  * [Parsers] Switch to Jason for JSON decoding.
  * [Parsers] Decode JSONP responses.
  * [Parsers] 2-arity Rest and Upload parser functions will be given a
    `Config` struct.
  * [Response] Add `Response` struct to be returned for requests.
  * [Operation] Add `http_headers` parameter to all operations.
  * [Config] Add options for JSON and XML decoders.
  * [ExDoc] Group Flickr API modules.

* Fixes
  * [Mix] Keep mix task private to the package.

* Backwards incompatible changes
  * [Rest] Use atoms for format and http method parameters.
  * [Rest] Rename `extra_params` to `default_params`.
  * [Config] Remove `:oauth` config key.
  * [Elixir] Drop Elixir 1.3 support.

## v0.5.0 (2017-08-23)

* Enhancements
  * [Flickrex] An `:http_opts` option has been added to `request/2` and
    `request!/2`.

* Deprecations
  * [Config] The `:oauth` config key is deprecated.

* Backwards incompatible changes
  * [Flickrex] Client, config, and get/post functions have been removed.
  * [Flickr] `Flickr` modules have been removed in favor of `Flickrex.Flickr`.

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
