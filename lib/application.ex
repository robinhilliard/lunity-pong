defmodule Pong.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Pong.Manager
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
