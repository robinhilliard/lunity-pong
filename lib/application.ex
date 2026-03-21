defmodule Pong.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    {:ok, _} = Application.ensure_all_started(:lunity)

    if Application.get_env(:lunity, :mods_enabled, false) do
      :ok = Lunity.Application.load_mods()
    end

    children = [
      {Pong.Manager, [capacity: 32]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
