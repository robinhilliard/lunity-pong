defmodule Pong.Scenes.Pong do
  use Lunity.Scene

  scene do
    node(:floor, prefab: "box", position: {0, 0, -1}, scale: {12, 6, 0.3})
    node(:paddle_left, prefab: "box", position: {-18, 0, 0.5}, scale: {0.3, 1.5, 0.3})
    node(:paddle_right, prefab: "box", position: {18, 0, 0.5}, scale: {0.3, 1.5, 0.3})
    node(:wall_top, prefab: "box", position: {0, 9.5, 0.15}, scale: {12, 0.3, 0.5})
    node(:wall_bottom, prefab: "box", position: {0, -9.5, 0.15}, scale: {12, 0.3, 0.5})
    node(:ball, prefab: "box", position: {0, 0, 0.5}, scale: {0.4, 0.4, 0.4})
  end
end
