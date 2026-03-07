defmodule Pong.Components.Speed do
  @moduledoc "Maximum movement speed (scalar float)."
  use Lunity.Component, storage: :tensor, shape: {}, dtype: :f32
end
