defmodule Pong.Materials do
  use Lunity.Materials

  material(:white, base_color: {1.0, 1.0, 1.0}, metallic: 0.0, roughness: 0.5)

  material(:bright_white,
    base_color: {1.0, 1.0, 1.0},
    emissive: {0.8, 0.8, 0.8},
    metallic: 0.0,
    roughness: 0.3
  )

  material(:blue, base_color: {0.2, 0.5, 1.0}, metallic: 0.0, roughness: 0.4)
end
