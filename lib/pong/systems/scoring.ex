defmodule Pong.Systems.Scoring do
  @moduledoc """
  Resets the ball to center when it passes beyond the paddle lines (score event).
  The collision system handles bouncing; this system handles scoring.
  """
  use Lunity.System, type: :tensor

  alias Lunity.Components.Position
  alias Lunity.Physics.Components.Velocity
  alias Pong.Components.Speed

  @reset_x 20.0

  @spec run(%{position: Position.t(), velocity: Velocity.t(), speed: Speed.t()}) ::
          %{position: Position.t(), velocity: Velocity.t()}
  defn run(%{position: pos, velocity: vel, speed: speed}) do
    x = pos[[.., 0]]

    has_speed = Nx.greater(speed, 0)
    past_left = Nx.less(x, -@reset_x)
    past_right = Nx.greater(x, @reset_x)
    scored = Nx.logical_and(Nx.logical_or(past_left, past_right), has_speed)

    new_x = Nx.select(scored, 0.0, x)
    new_z = Nx.select(scored, 0.0, pos[[.., 2]])
    new_vx = Nx.select(scored, speed, vel[[.., 0]])
    new_vz = Nx.select(scored, Nx.multiply(speed, 0.7), vel[[.., 2]])

    new_pos = Nx.stack([new_x, pos[[.., 1]], new_z], axis: 1)
    new_vel = Nx.stack([new_vx, vel[[.., 1]], new_vz], axis: 1)

    %{position: new_pos, velocity: new_vel}
  end

end
