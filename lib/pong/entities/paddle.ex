defmodule Pong.Entities.Paddle do
  use Lunity.Entity

  entity do
    property(:side, :atom, values: [:left, :right], default: :left)
    property(:speed, :float, default: 8.0, min: 0.0)
  end

  @impl Lunity.Entity
  def init(_config, _entity_id), do: :ok
end
