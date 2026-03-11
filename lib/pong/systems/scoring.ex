defmodule Pong.Systems.Scoring do
  @moduledoc """
  Resets the ball to center when it passes beyond the paddle lines.
  Structured system so we can use :rand for random launch direction.
  """
  use Lunity.System, type: :structured

  alias Lunity.Components.Position
  alias Lunity.Physics.Components.Velocity
  alias Pong.Components.Speed

  @reset_x 20.0

  @spec run(integer(), %{position: Position.t(), velocity: Velocity.t(), speed: Speed.t()}) ::
          %{position: Position.t(), velocity: Velocity.t()} | :ok
  def run(_entity_id, %{position: {x, y, _z}, velocity: _vel, speed: speed})
      when speed > 0 and (x < -@reset_x or x > @reset_x) do
    x_sign = if :rand.uniform() > 0.5, do: 1, else: -1
    z_ratio = (0.3 + :rand.uniform() * 0.7) * if(:rand.uniform() > 0.5, do: 1, else: -1)

    %{
      position: {0.0, y, 0.0},
      velocity: {speed * x_sign, 0.0, speed * z_ratio}
    }
  end

  def run(_entity_id, _components), do: :ok
end
