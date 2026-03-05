defmodule Pong.Prefabs.Box do
  use Lunity.Prefab, glb: "box"

  prefab do
    property :color, :float_array,
      length: 4,
      default: [0.8, 0.8, 0.8, 1.0],
      subtype: :gamma_color,
      description: "Box tint color (RGBA)"
  end
end
