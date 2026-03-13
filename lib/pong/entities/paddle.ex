defmodule Pong.Entities.Paddle do
  use Lunity.Entity

  entity do
    property :side, :atom, values: [:left, :right], default: :left
    property :speed, :float, default: 8.0, min: 0.0

    component Lunity.Components.RandomKey
    component Lunity.Components.Position
    component Lunity.Physics.Components.Velocity
    component Lunity.Physics.Components.BoxCollider
    component Lunity.Physics.Components.Static
    component Lunity.Physics.Components.CollisionLayer
    component Lunity.Physics.Components.CollisionMask
    component Lunity.Physics.Components.Restitution
    component Pong.Components.Speed
    component Pong.Components.Side
    component Pong.Components.PaddleControl
  end

  @impl Lunity.Entity
  def init(config, entity_id) do
    pos = Map.get(config, :position, {0.0, 1.5, 0.0})
    side_val = if Map.get(config, :side, :left) == :left, do: 0, else: 1
    speed = Map.get(config, :speed, 8.0)

    {sx, sy, sz} = Map.get(config, :scale, {1.0, 1.0, 3.0})

    Position.put(entity_id, pos)
    Velocity.put(entity_id, {0.0, 0.0, 0.0})
    Speed.put(entity_id, speed)
    Side.put(entity_id, side_val)
    PaddleControl.put(entity_id, 0)
    BoxCollider.put(entity_id, {sx, sy, sz})
    Static.put(entity_id, 1)
    CollisionLayer.put(entity_id, 2)
    CollisionMask.put(entity_id, 1)
    Restitution.put(entity_id, 1.0)
    :ok
  end
end
