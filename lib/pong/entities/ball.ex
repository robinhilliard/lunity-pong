defmodule Pong.Entities.Ball do
  use Lunity.Entity

  entity do
    property(:speed, :float, default: 1.0, min: 0.0)
  end

  @impl Lunity.Entity
  def init(config, entity_id) do
    pos = Map.get(config, :position, {0.0, 1.5, 0.0})
    speed = Map.get(config, :speed, 0.5)

    {sx, sy, sz} = Map.get(config, :scale, {1.0, 0.5, 1.0})

    Lunity.Components.Position.put(entity_id, pos)
    Lunity.Physics.Components.Velocity.put(entity_id, {speed, 0.0, speed * 0.7})
    Pong.Components.Speed.put(entity_id, speed)
    Lunity.Physics.Components.BoxCollider.put(entity_id, {sx, sy, sz})
    Lunity.Physics.Components.Static.put(entity_id, 0)
    Lunity.Physics.Components.CollisionLayer.put(entity_id, 1)
    Lunity.Physics.Components.CollisionMask.put(entity_id, 6)
    Lunity.Physics.Components.Restitution.put(entity_id, 1.0)
    :ok
  end
end
