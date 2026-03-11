defmodule Pong.Systems.Scoring do
  @moduledoc """
  Resets the ball to center when it passes beyond the paddle lines.

  Tensor system using Nx.Random for deterministic random launch direction.
  Each entity carries a RandomKey component; the system splits the key,
  samples direction values, and writes the updated key back.
  """
  use Lunity.System, type: :tensor

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
    pos = inputs.position
    vel = inputs.velocity
    speed = inputs.speed
    keys = inputs.random_key

    x = pos[[.., 0]]
    has_speed = Nx.greater(speed, 0)
    out_left = Nx.less(x, -@reset_x)
    out_right = Nx.greater(x, @reset_x)
    scored = Nx.logical_and(has_speed, Nx.logical_or(out_left, out_right))

    n = Nx.axis_size(keys, 0)

    {new_keys, new_vel} =
      Enum.reduce(0..(n - 1), {keys, vel}, fn i, {k_acc, v_acc} ->
        did_score = Nx.to_number(scored[i]) == 1

        if did_score do
          entity_key = k_acc[i]
          split = Nx.Random.split(entity_key)
          k1 = split[0]
          subkey = split[1]
          {x_rand, subkey} = Nx.Random.uniform(subkey, type: :f32)
          {z_base, subkey} = Nx.Random.uniform(subkey, type: :f32)
          {z_sign_rand, _subkey} = Nx.Random.uniform(subkey, type: :f32)

          x_sign = Nx.select(Nx.greater(x_rand, 0.5), 1.0, -1.0)
          z_ratio = Nx.add(0.3, Nx.multiply(z_base, 0.7))
          z_sign = Nx.select(Nx.greater(z_sign_rand, 0.5), 1.0, -1.0)
          s = Nx.reshape(speed[i], {})

          vx = Nx.multiply(s, x_sign) |> Nx.reshape({1})
          vy = Nx.tensor([0.0], type: :f32)
          vz = Nx.multiply(s, Nx.multiply(z_ratio, z_sign)) |> Nx.reshape({1})
          new_v = Nx.concatenate([vx, vy, vz])

          indices_v = Nx.tensor([[i]])
          v_acc = Nx.indexed_put(v_acc, indices_v, Nx.reshape(new_v, {1, 3}))

          indices_k = Nx.tensor([[i]])
          k_acc = Nx.indexed_put(k_acc, indices_k, Nx.reshape(k1, {1, 2}))

          {k_acc, v_acc}
        else
          {k_acc, v_acc}
        end
      end)

    reset_pos_x = Nx.select(scored, Nx.tensor(0.0, type: :f32), x)
    reset_pos_z = Nx.select(scored, Nx.tensor(0.0, type: :f32), pos[[.., 2]])
    new_pos = Nx.stack([reset_pos_x, pos[[.., 1]], reset_pos_z], axis: 1)

    %{position: new_pos, velocity: new_vel, random_key: new_keys}
  end
end
