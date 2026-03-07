defmodule Pong.Entities.Ball do
  use Lunity.Entity

  entity do
    property(:speed, :float, default: 10.0, min: 0.0)
  end

  @impl Lunity.Entity
  def init(config, entity_id) do
    pos = Map.get(config, :position, {0, 0.5, 0})
    speed = Map.get(config, :speed, 10.0)

    Pong.Components.Position.put(entity_id, pos)
    Pong.Components.Velocity.put(entity_id, {speed, 0.0, speed * 0.7})
    Pong.Components.Speed.put(entity_id, speed)
    :ok
  end
end
