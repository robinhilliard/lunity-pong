defmodule Pong.Entities.Wall do
  @moduledoc "Static wall/floor collider. Derives box collider from node scale."
  use Lunity.Entity

  @impl Lunity.Entity
  def init(config, entity_id) do
    pos = Map.get(config, :position, {0, 0, 0})
    {sx, sy, sz} = Map.get(config, :scale, {1, 1, 1})

    Lunity.Components.Position.put(entity_id, pos)
    Lunity.Physics.Components.Velocity.put(entity_id, {0, 0, 0})
    Lunity.Physics.Components.BoxCollider.put(entity_id, {sx, sy, sz})
    Lunity.Physics.Components.Static.put(entity_id, 1)
    Lunity.Physics.Components.CollisionLayer.put(entity_id, 4)
    Lunity.Physics.Components.CollisionMask.put(entity_id, 1)
    Lunity.Physics.Components.Restitution.put(entity_id, 1.0)
    :ok
  end
end
