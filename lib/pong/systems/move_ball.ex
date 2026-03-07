defmodule Pong.Systems.MoveBall do
  @moduledoc "Applies velocity to position for all entities each tick."
  use Lunity.System,
    type: :tensor,
    reads: [Pong.Components.Position, Pong.Components.Velocity],
    writes: [Pong.Components.Position]

  import Nx.Defn

  defn run(%{position: pos, velocity: vel}) do
    %{position: Nx.add(pos, vel)}
  end
end
