defmodule Pong.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    # ECSx starts as its own app; add game systems here when wiring up game loop
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
