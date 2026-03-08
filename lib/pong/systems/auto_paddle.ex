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
      Lunity.Components.Position,
      Pong.Components.Speed,
      Pong.Components.PaddleControl,
      Lunity.Physics.Components.Static
    ],
    writes: [Lunity.Components.Position]

  import Nx.Defn

  @effectiveness 0.7
  @dead_zone 0.05
  @dt 0.05
  @z_limit 6.0

  defn run(%{position: pos, speed: speed, paddle_control: ctrl, static: static_flag}) do
    is_auto = Nx.equal(ctrl, 0)
    has_speed = Nx.greater(speed, 0)
    is_static = Nx.equal(static_flag, 1)
    should_move = Nx.logical_and(is_auto, Nx.logical_and(has_speed, is_static))

    paddle_z = pos[[.., 2]]

    is_ball = Nx.logical_and(Nx.equal(static_flag, 0), has_speed)
    ball_weight = Nx.as_type(is_ball, :f32)
    total_weight = Nx.sum(ball_weight)
    safe_weight = Nx.max(total_weight, 1.0)
    ball_z = Nx.sum(Nx.multiply(pos[[.., 2]], ball_weight)) |> Nx.divide(safe_weight)

    diff = Nx.subtract(ball_z, paddle_z)
    max_move = Nx.multiply(speed, @effectiveness * @dt)
    clamped = Nx.min(Nx.max(diff, Nx.negate(max_move)), max_move)

    outside_dead_zone = Nx.greater(Nx.abs(diff), @dead_zone)
    move = Nx.select(outside_dead_zone, clamped, 0.0)

    move_3d = Nx.select(should_move, move, 0.0)

    new_z = Nx.add(paddle_z, move_3d)
    clamped_z = Nx.min(Nx.max(new_z, -@z_limit), @z_limit)
    final_z = Nx.select(should_move, clamped_z, paddle_z)
    new_pos = Nx.stack([pos[[.., 0]], pos[[.., 1]], final_z], axis: 1)

    %{position: new_pos}
  end
end
