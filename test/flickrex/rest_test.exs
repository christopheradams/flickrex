defmodule Flickrex.RestTest do
  use ExUnit.Case

  alias Flickrex.{Rest, Operation}

  test "get/2 returns a Rest operation" do
    test_rest(:get)
  end

  test "post/2 returns a Rest operation" do
    test_rest(:post)
  end

  def test_rest(http_method) do
    method = "flickr.test.echo"

    expected = %Operation.Rest{
      extra_params: %{
        nojsoncallback: 1
      },
      format: :json,
      http_method: http_method,
      method: method,
      params: %{test: "test"},
      parser: &Flickrex.Parsers.Rest.parse/2,
      path: "services/rest",
      service: :api
    }

    actual = apply(Rest, http_method, [method, [test: "test"]])

    assert actual == expected
  end
end
