defmodule Pong.Components.PaddleControl do
  @moduledoc """
  Controls who drives a paddle: 0 = auto, >0 = session index (future).
  Auto-controlled paddles track the ball with limited effectiveness.
  """
  use Lunity.Component, storage: :tensor, shape: {}, dtype: :s32
end
