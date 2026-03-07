defmodule Pong.Systems.BounceWalls do
  @moduledoc """
  Reflects ball velocity when hitting walls or paddles and resets on score.

  Uses tensor operations: checks position bounds, flips velocity components
  via conditional select, resets ball to center when it passes a paddle.

  Game field: X = -18..18 (paddle lines), Z = -9.2..9.2 (walls).
  """
  use Lunity.System,
    type: :tensor,
    reads: [
      Pong.Components.Position,
      Pong.Components.Velocity,
      Pong.Components.Speed
    ],
    writes: [Pong.Components.Position, Pong.Components.Velocity]

  import Nx.Defn

  @wall_z 9.0
  @paddle_x 17.5
  @reset_x 18.5

  defn run(%{position: pos, velocity: vel, speed: speed}) do
    x = pos[[.., 0]]
    z = pos[[.., 2]]
    vx = vel[[.., 0]]
    vz = vel[[.., 2]]

    # Bounce off top/bottom walls (Z axis)
    hit_top = Nx.greater(z, @wall_z)
    hit_bottom = Nx.less(z, -@wall_z)
    wall_hit = Nx.logical_or(hit_top, hit_bottom)
    vz = Nx.select(wall_hit, Nx.negate(vz), vz)
    z = Nx.clip(z, -@wall_z, @wall_z)

    # Bounce off paddles (X axis)
    hit_left_paddle = Nx.less(x, -@paddle_x)
    hit_right_paddle = Nx.greater(x, @paddle_x)
    paddle_hit = Nx.logical_or(hit_left_paddle, hit_right_paddle)
    vx = Nx.select(paddle_hit, Nx.negate(vx), vx)
    x = Nx.clip(x, -@paddle_x, @paddle_x)

    # Reset ball when it goes past paddles (score event)
    scored = Nx.logical_or(Nx.less(x, -@reset_x), Nx.greater(x, @reset_x))
    has_speed = Nx.greater(speed, 0)
    should_reset = Nx.logical_and(scored, has_speed)
    x = Nx.select(should_reset, 0.0, x)
    z = Nx.select(should_reset, 0.0, z)
    vx = Nx.select(should_reset, speed, vx)
    vz = Nx.select(should_reset, Nx.multiply(speed, 0.7), vz)

    new_pos = Nx.stack([x, pos[[.., 1]], z], axis: 1)
    new_vel = Nx.stack([vx, vel[[.., 1]], vz], axis: 1)

    %{position: new_pos, velocity: new_vel}
  end
end
