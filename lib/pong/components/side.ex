defmodule Pong.Components.Side do
  @moduledoc "Paddle side: 0 = left, 1 = right."
  use Lunity.Component, storage: :tensor, shape: {}, dtype: :s32
end
