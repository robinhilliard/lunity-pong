defmodule Pong.Entities.Ball do
  use Lunity.Entity

  entity do
    property :speed, :float, default: 10.0, min: 0.0

    component Lunity.Components.Position
    component Lunity.Components.RandomKey
    component Lunity.Physics.Components.Velocity
    component Lunity.Physics.Components.BoxCollider
    component Lunity.Physics.Components.Static
    component Lunity.Physics.Components.CollisionLayer
    component Lunity.Physics.Components.CollisionMask
    component Lunity.Physics.Components.Restitution
    component Pong.Components.Speed
  end

  @impl Lunity.Entity
  def init(config, entity_id) do
    pos = Map.get(config, :position, {0.0, 1.5, 0.0})
    speed = Map.get(config, :speed, 10.0)

    {sx, sy, sz} = Map.get(config, :scale, {1.0, 0.5, 1.0})

    seed = :erlang.phash2({entity_id, System.monotonic_time()})
    key = Nx.Random.key(seed)
    split = Nx.Random.split(key)
    k1 = split[0]
    subkey = split[1]
    {x_rand, subkey} = Nx.Random.uniform(subkey, type: :f32)
    {z_base, subkey} = Nx.Random.uniform(subkey, type: :f32)
    {z_sign_rand, _subkey} = Nx.Random.uniform(subkey, type: :f32)

    x_sign = if Nx.to_number(x_rand) > 0.5, do: 1, else: -1
    z_ratio = (0.3 + Nx.to_number(z_base) * 0.7) * if(Nx.to_number(z_sign_rand) > 0.5, do: 1, else: -1)

    Position.put(entity_id, pos)
    Velocity.put(entity_id, {speed * x_sign, 0.0, speed * z_ratio})
    Speed.put(entity_id, speed)
    RandomKey.put(entity_id, Nx.to_flat_list(k1) |> List.to_tuple())
    BoxCollider.put(entity_id, {sx, sy, sz})
    Static.put(entity_id, 0)
    CollisionLayer.put(entity_id, 1)
    CollisionMask.put(entity_id, 6)
    Restitution.put(entity_id, 1.0)
    :ok
  end
end
