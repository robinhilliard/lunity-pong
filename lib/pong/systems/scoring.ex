defmodule Pong.Systems.Scoring do
  @moduledoc """
  Resets the ball to center when it passes beyond the paddle lines.

  Declares `entities: [:ball]` and checks only the ball's X position.
  When the ball crosses the reset boundary, its position is zeroed and
  velocity re-randomised using the entity's RandomKey.
  """
  use Lunity.System, type: :tensor, entities: [:ball]

  alias Lunity.Components.{Position, RandomKey}
  alias Lunity.Physics.Components.Velocity
  alias Pong.Components.Speed

  @reset_x 20.0

  @spec run(%{
          position: Position.t(),
          velocity: Velocity.t(),
          speed: Speed.t(),
          random_key: RandomKey.t()
        }) :: %{position: Position.t(), velocity: Velocity.t(), random_key: RandomKey.t()}
  def run(inputs) do
    ball_idx = Nx.to_number(inputs[:ball_idx])

    if ball_idx < 0 do
      %{position: inputs.position, velocity: inputs.velocity, random_key: inputs.random_key}
    else
      ball_x = Nx.to_number(inputs.position[ball_idx][0])

      if ball_x < -@reset_x or ball_x > @reset_x do
        reset_ball(inputs, ball_idx)
      else
        %{position: inputs.position, velocity: inputs.velocity, random_key: inputs.random_key}
      end
    end
  end

  defp reset_ball(inputs, i) do
    pos = inputs.position
    vel = inputs.velocity
    keys = inputs.random_key
    speed = inputs.speed

    entity_key = keys[i]
    split = Nx.Random.split(entity_key)
    k1 = split[0]
    subkey = split[1]
    {x_rand, subkey} = Nx.Random.uniform(subkey, type: :f32)
    {z_base, subkey} = Nx.Random.uniform(subkey, type: :f32)
    {z_sign_rand, _subkey} = Nx.Random.uniform(subkey, type: :f32)

    x_sign = if Nx.to_number(x_rand) > 0.5, do: 1.0, else: -1.0
    z_ratio = 0.3 + Nx.to_number(z_base) * 0.7
    z_sign = if Nx.to_number(z_sign_rand) > 0.5, do: 1.0, else: -1.0
    s = Nx.to_number(speed[i])

    ball_y = Nx.to_number(pos[i][1])
    new_pos_row = Nx.tensor([[0.0, ball_y, 0.0]], type: :f32)
    new_vel_row = Nx.tensor([[s * x_sign, 0.0, s * z_ratio * z_sign]], type: :f32)
    new_key_row = Nx.reshape(k1, {1, 2})

    idx = Nx.tensor([[i]])

    %{
      position: Nx.indexed_put(pos, idx, new_pos_row),
      velocity: Nx.indexed_put(vel, idx, new_vel_row),
      random_key: Nx.indexed_put(keys, idx, new_key_row)
    }
  end
end
