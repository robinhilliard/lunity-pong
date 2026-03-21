defmodule Pong.Entities.Wall do
  @moduledoc "Static wall/floor collider. Derives box collider from node scale."
  use Lunity.Entity

  entity do
    component(Lunity.Components.Position)
    component(Lunity.Physics.Components.Velocity)
    component(Lunity.Physics.Components.BoxCollider)
    component(Lunity.Physics.Components.Static)
    component(Lunity.Physics.Components.CollisionLayer)
    component(Lunity.Physics.Components.CollisionMask)
    component(Lunity.Physics.Components.Restitution)
  end

  @impl Lunity.Entity
  def init(config, entity_id) do
    pos = Map.get(config, :position, {0, 0, 0})
    {sx, sy, sz} = Map.get(config, :scale, {1, 1, 1})

    Position.put(entity_id, pos)
    Velocity.put(entity_id, {0, 0, 0})
    BoxCollider.put(entity_id, {sx, sy, sz})
    Static.put(entity_id, 1)
    CollisionLayer.put(entity_id, 4)
    CollisionMask.put(entity_id, 1)
    Restitution.put(entity_id, 1.0)
    :ok
  end
end
