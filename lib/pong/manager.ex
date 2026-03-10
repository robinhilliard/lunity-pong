defmodule Pong.Manager do
  @moduledoc """
  Pong game manager. Registers components, defines system execution order,
  and creates a default game instance on first start.
  """
  use Lunity.Manager

  @impl true
  def components do
    [
      Lunity.Components.InstanceMembership,
      Lunity.Components.Position,
      Lunity.Physics.Components.Velocity,
      Lunity.Physics.Components.BoxCollider,
      Lunity.Physics.Components.CollisionLayer,
      Lunity.Physics.Components.CollisionMask,
      Lunity.Physics.Components.Restitution,
      Lunity.Physics.Components.Static,
      Pong.Components.Speed,
      Pong.Components.Side,
      Pong.Components.PaddleControl
    ]
  end

  @impl true
  def systems do
    [
      Pong.Systems.AutoPaddle,
      Lunity.Physics.Systems.SweptAABBCollision,
      Pong.Systems.Scoring
    ]
  end

  @impl true
  def setup do
    {:ok, _pid} = Lunity.Instance.start(Pong.Scenes.Pong, id: "pong_1")
    :ok
  end
end
