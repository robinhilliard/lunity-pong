defmodule Pong.Entities.Paddle do
  use Lunity.Entity

  entity do
    property(:side, :atom, values: [:left, :right], default: :left)
    property(:speed, :float, default: 8.0, min: 0.0)
  end

  @impl Lunity.Entity
  def init(config, entity_id) do
    pos = Map.get(config, :position, {0.0, 1.5, 0.0})
    side_val = if Map.get(config, :side, :left) == :left, do: 0, else: 1
    speed = Map.get(config, :speed, 8.0)

    {sx, sy, sz} = Map.get(config, :scale, {1.0, 1.0, 3.0})

    Lunity.Components.Position.put(entity_id, pos)
    Lunity.Physics.Components.Velocity.put(entity_id, {0.0, 0.0, 0.0})
    Pong.Components.Speed.put(entity_id, speed)
    Pong.Components.Side.put(entity_id, side_val)
    Pong.Components.PaddleControl.put(entity_id, 0)
    Lunity.Physics.Components.BoxCollider.put(entity_id, {sx, sy, sz})
    Lunity.Physics.Components.Static.put(entity_id, 1)
    Lunity.Physics.Components.CollisionLayer.put(entity_id, 2)
    Lunity.Physics.Components.CollisionMask.put(entity_id, 1)
    Lunity.Physics.Components.Restitution.put(entity_id, 1.0)
    :ok
  end
end
