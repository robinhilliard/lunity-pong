defmodule Pong.Scenes.Pong do
  use Lunity.Scene

  scene do
    node(:floor,
      prefab: Pong.Prefabs.Box,
      position: {0, -0.5, 0},
      scale: {30.0, 1.0, 18.0}
    )

    node(:paddle_left,
      prefab: Pong.Prefabs.Box,
      entity: Pong.Entities.Paddle,
      position: {-14, 1.5, 0},
      scale: {1.0, 1.0, 3.0},
      properties: %{side: :left},
      material: Pong.Materials.warm_glow(),
      light: Lunity.Light.point(color: {1.0, 0.85, 0.6}, intensity: 5.0, range: 50.0)
    )

    node(:paddle_right,
      prefab: Pong.Prefabs.Box,
      entity: Pong.Entities.Paddle,
      position: {14, 1.5, 0},
      scale: {1.0, 1.0, 3.0},
      properties: %{side: :right},
      material: Pong.Materials.warm_glow(),
      light: Lunity.Light.point(color: {1.0, 0.85, 0.6}, intensity: 5.0, range: 50.0)
    )

    node(:wall_top,
      prefab: Pong.Prefabs.Box,
      entity: Pong.Entities.Wall,
      position: {0, 1.0, 8.5},
      scale: {30.0, 2.0, 1.0}
    )

    node(:wall_bottom,
      prefab: Pong.Prefabs.Box,
      entity: Pong.Entities.Wall,
      position: {0, 1.0, -8.5},
      scale: {30.0, 2.0, 1.0}
    )

    node(:ball,
      prefab: Pong.Prefabs.Box,
      entity: Pong.Entities.Ball,
      position: {0.0, 1.5, 0.0},
      scale: {01.0, 1.0, 1.0},
      material: Pong.Materials.warm_glow(),
      light: Lunity.Light.point(color: {1.0, 0.85, 0.6}, intensity: 5.0, range: 50.0)
    )
  end
end
