defmodule Pong.Systems.AutoPaddle do
  @moduledoc """
  Moves auto-controlled paddles toward the ball.

  Tracks the ball's Z position with limited speed (70% of max) and a dead zone
  (ignores differences < 0.3 units). Good enough to rally but beatable.

  Uses PaddleControl == 0 as the auto flag. Non-paddle entities have
  PaddleControl == 0 but also Speed == 0, so they don't move.
  """
  use Lunity.System,
    type: :tensor,
    reads: [
      Pong.Components.Position,
      Pong.Components.Speed,
      Pong.Components.PaddleControl
    ],
    writes: [Pong.Components.Position]

  import Nx.Defn

  @effectiveness 0.7
  @dead_zone 0.3
  @dt 0.05

  defn run(%{position: pos, speed: speed, paddle_control: ctrl}) do
    is_auto = Nx.equal(ctrl, 0)
    has_speed = Nx.greater(speed, 0)
    should_move = Nx.logical_and(is_auto, has_speed)

    paddle_z = pos[[.., 2]]

    ball_z = Nx.mean(pos[[.., 2]])

    diff = Nx.subtract(ball_z, paddle_z)
    max_move = Nx.multiply(speed, @effectiveness * @dt)
    clamped = Nx.min(Nx.max(diff, Nx.negate(max_move)), max_move)

    outside_dead_zone = Nx.greater(Nx.abs(diff), @dead_zone)
    move = Nx.select(outside_dead_zone, clamped, 0.0)

    move_3d = Nx.select(should_move, move, 0.0)

    new_z = Nx.add(paddle_z, move_3d)
    new_pos = Nx.stack([pos[[.., 0]], pos[[.., 1]], new_z], axis: 1)

    %{position: new_pos}
  end
end
