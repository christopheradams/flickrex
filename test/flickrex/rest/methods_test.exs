defmodule Flickrex.Rest.MethodsTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  setup [:flickr_config]

  test "request photo info in XML", %{config: opts} do
    test_info(nil, opts)
  end

  test "request photo info in JSON", %{config: opts} do
    test_info(:json, opts)
  end

  def test_info(format, opts) do
    photo_id = "8436466166"
    method = "flickr.photos.getInfo"

    operation =
      method
      |> Flickrex.Rest.get(photo_id: photo_id)
      |> Map.put(:format, format)

    {:ok, response} = Flickrex.request(operation, opts)

    assert get_in(response.body, ["photo", "id"]) == photo_id
  end

  test "request fake method in XML", %{config: opts} do
    test_fake(:rest, opts)
  end

  test "request fake method in JSON", %{config: opts} do
    test_fake(:json, opts)
  end

  def test_fake(format, opts) do
    method = "flickr.fakeMethod"

    operation =
      method
      |> Flickrex.Rest.get()
      |> Map.put(:format, format)

    assert {:error, response} = Flickrex.request(operation, opts)

    expected_body =
      case format do
        :rest ->
          %{
            "stat" => "fail",
            "err" => %{"code" => "112", "msg" => "Method &quot;flickr.fakeMethod&quot; not found"}
          }

        :json ->
          %{
            "stat" => "fail",
            "code" => 112,
            "message" => "Method \"flickr.fakeMethod\" not found"
          }
      end

    assert response.body == expected_body
  end
end
