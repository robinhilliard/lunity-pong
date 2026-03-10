defmodule Pong.Entities.Ball do
  use Lunity.Entity

  entity do
    property :speed, :float, default: 8.0, min: 0.0

    component Lunity.Components.Position
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
    speed = Map.get(config, :speed, 1.0)

    {sx, sy, sz} = Map.get(config, :scale, {1.0, 0.5, 1.0})

    Position.put(entity_id, pos)
    Velocity.put(entity_id, {speed, 0.0, speed * 0.7})
    Speed.put(entity_id, speed)
    BoxCollider.put(entity_id, {sx, sy, sz})
    Static.put(entity_id, 0)
    CollisionLayer.put(entity_id, 1)
    CollisionMask.put(entity_id, 6)
    Restitution.put(entity_id, 1.0)
    :ok
  end
end
