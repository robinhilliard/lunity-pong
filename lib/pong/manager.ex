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
      Pong.Components.Position,
      Pong.Components.Velocity,
      Pong.Components.Speed,
      Pong.Components.Side,
      Pong.Components.PaddleControl
    ]
  end

  @impl true
  def systems do
    [
      Pong.Systems.AutoPaddle,
      Pong.Systems.MoveBall,
      Pong.Systems.BounceWalls
    ]
  end

  @impl true
  def setup do
    {:ok, _pid} = Lunity.Instance.start(Pong.Scenes.Pong, id: "pong_1")
    :ok
  end
end
