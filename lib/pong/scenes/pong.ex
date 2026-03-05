defmodule Pong.Scenes.Pong do
  use Lunity.Scene

  scene do
    light(:sun,
      type: :directional,
      color: {1.0, 0.95, 0.8},
      intensity: 2.0,
      rotation: {-0.3827, 0.0, 0.0, 0.9239}
    )

    light(:fill,
      type: :directional,
      color: {0.4, 0.5, 0.7},
      intensity: 0.5,
      rotation: {0.1, 0.3, 0.0, 0.95}
    )

    node(:floor, prefab: Pong.Prefabs.Box, position: {0, 0, -1}, scale: {12, 6, 0.3})

    node(:paddle_left,
      prefab: Pong.Prefabs.Box,
      entity: Pong.Entities.Paddle,
      position: {-18, 0, 0.5},
      scale: {0.3, 1.5, 0.3},
      properties: %{side: :left}
    )

    node(:paddle_right,
      prefab: Pong.Prefabs.Box,
      entity: Pong.Entities.Paddle,
      position: {18, 0, 0.5},
      scale: {0.3, 1.5, 0.3},
      properties: %{side: :right}
    )

    node(:wall_top, prefab: Pong.Prefabs.Box, position: {0, 9.5, 0.15}, scale: {12, 0.3, 0.5})
    node(:wall_bottom, prefab: Pong.Prefabs.Box, position: {0, -9.5, 0.15}, scale: {12, 0.3, 0.5})

    node(:ball,
      prefab: Pong.Prefabs.Box,
      entity: Pong.Entities.Ball,
      position: {0, 0, 0.5},
      scale: {0.4, 0.4, 0.4},
      material: Pong.Materials.white()
    )
  end
end
