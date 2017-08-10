defmodule FlickrexTest do
  use ExUnit.Case

  import Flickrex.Support.Config

  setup [:flickr_config]

  test "request/2 performs a request", %{config: opts} do
    operation = %Flickrex.Support.Operation{path: "/test"}
    {:ok, resp} = Flickrex.request(operation, opts)

    assert resp == %{body: "Test", headers: [], status_code: 200}
  end

  test "request/2 performs can return an error", %{config: opts} do
    operation = %Flickrex.Support.Operation{path: "/error"}
    {:error, error} = Flickrex.request(operation, opts)

    assert error == %{reason: :error}
  end

  test "request!/2 performs a request", %{config: opts} do
    operation = %Flickrex.Support.Operation{path: "/test"}
    resp = Flickrex.request!(operation, opts)

    assert resp == %{body: "Test", headers: [], status_code: 200}
  end

  test "request!/2 performs can raise an error", %{config: opts} do
    operation = %Flickrex.Support.Operation{path: "/error"}

    assert_raise Flickrex.Error, fn ->
      Flickrex.request!(operation, opts)
    end
  end
end
