defmodule Pong.Components.Position do
  @moduledoc "Entity world position {x, y, z}."
  use Lunity.Component, storage: :tensor, shape: {3}, dtype: :f32
end
