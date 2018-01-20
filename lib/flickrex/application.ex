defmodule Flickrex.Application do
  @moduledoc false

  use Application

  @spec start(term, term) ::
          {:ok, pid}
          | {:ok, pid, state :: Application.state()}
          | {:error, reason :: term}
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = []

    opts = [strategy: :one_for_one, name: Flickrex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
