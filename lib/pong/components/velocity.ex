defmodule Pong.Components.Velocity do
  @moduledoc "Entity velocity vector {vx, vy, vz}."
  use Lunity.Component, storage: :tensor, shape: {3}, dtype: :f32
end
