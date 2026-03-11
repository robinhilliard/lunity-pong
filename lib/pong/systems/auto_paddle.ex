defmodule Pong.Systems.AutoPaddle do
  @moduledoc """
  Moves auto-controlled paddles toward the ball.

  Moves at `@paddle_speed` units/sec toward the ball's Z, clamped to the
  court bounds. Frame-rate independent via dt scaling.

  Uses PaddleControl == 0 as the auto flag. Non-paddle entities have
  PaddleControl == 0 but also Speed == 0, so they don't move.
  """
  use Lunity.System, type: :tensor

  alias Lunity.Components.{Position, DeltaTime}
  alias Lunity.Physics.Components.Static
  alias Pong.Components.{Speed, PaddleControl}

  @paddle_speed 40.0
  @z_limit 6.0

  @spec run(%{
          position: Position.t(),
          speed: Speed.t(),
          paddle_control: PaddleControl.t(),
          static: Static.t(),
          delta_time: DeltaTime.t()
        }) :: %{position: Position.t()}
  defn run(%{position: pos, speed: speed, paddle_control: ctrl, static: static_flag, delta_time: dt}) do
    is_auto = Nx.equal(ctrl, 0)
    has_speed = Nx.greater(speed, 0)
    is_static = Nx.equal(static_flag, 1)
    should_move = Nx.logical_and(is_auto, Nx.logical_and(has_speed, is_static))

    paddle_z = pos[[.., 2]]

    is_ball = Nx.logical_and(Nx.equal(static_flag, 0), has_speed)
    ball_weight = Nx.as_type(is_ball, :f32)
    safe_weight = Nx.max(Nx.sum(ball_weight), 1.0)
    ball_z = Nx.sum(Nx.multiply(pos[[.., 2]], ball_weight)) |> Nx.divide(safe_weight)

    target_z = Nx.min(Nx.max(ball_z, -@z_limit), @z_limit)
    diff = Nx.subtract(target_z, paddle_z)
    max_step = Nx.multiply(dt, @paddle_speed)
    clamped = Nx.min(Nx.max(diff, Nx.negate(max_step)), max_step)
    new_z = Nx.add(paddle_z, clamped)
    final_z = Nx.select(should_move, new_z, paddle_z)
    new_pos = Nx.stack([pos[[.., 0]], pos[[.., 1]], final_z], axis: 1)

    %{position: new_pos}
  end
end
