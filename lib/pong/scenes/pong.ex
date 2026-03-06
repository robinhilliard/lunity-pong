defmodule Pong.Scenes.Pong do
  use Lunity.Scene

  scene do
    node(:floor, prefab: Pong.Prefabs.Box, position: {0, -1, 0}, scale: {12, 0.3, 6})

    node(:paddle_left,
      prefab: Pong.Prefabs.Box,
      entity: Pong.Entities.Paddle,
      position: {-18, 0.5, 0},
      scale: {0.3, 0.3, 1.5},
      properties: %{side: :left}
    )

    node(:paddle_right,
      prefab: Pong.Prefabs.Box,
      entity: Pong.Entities.Paddle,
      position: {18, 0.5, 0},
      scale: {0.3, 0.3, 1.5},
      properties: %{side: :right}
    )

    node(:wall_top, prefab: Pong.Prefabs.Box, position: {0, 0.15, 9.5}, scale: {12, 0.5, 0.3})
    node(:wall_bottom, prefab: Pong.Prefabs.Box, position: {0, 0.15, -9.5}, scale: {12, 0.5, 0.3})

    node(:ball,
      prefab: Pong.Prefabs.Box,
      entity: Pong.Entities.Ball,
      position: {0, 0.5, 0},
      scale: {0.4, 0.4, 0.4},
      material: Pong.Materials.warm_glow(),
      light: Lunity.Light.point(color: {1.0, 0.85, 0.6}, intensity: 5.0, range: 50.0)
    )
  end
end
