defmodule Pong.Entities.Ball do
  use Lunity.Entity

  entity do
    property :speed, :float, default: 10.0, min: 0.0
  end

  @impl Lunity.Entity
  def init(_config, _entity_id), do: :ok
end
