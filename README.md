# Pong

A Pong game built on [Lunity](https://github.com/robinhilliard/lunity) and [EAGL](https://github.com/robinhilliard/eagl). Serves as the first game project for the Lunity engine, driving development of the scene, entity, and prefab DSLs, and editor tooling.

## Running

```bash
mix pong.run
```

The game runs in Lunity's editor mode by default, with orbit camera controls and auto-reload on file changes.

## Project structure

```
lib/
  pong.ex                    # Main module
  application.ex             # Application supervisor
  pong/
    game.ex                  # Game window (play mode)
    scenes/
      pong.ex                # Scene module (use Lunity.Scene)

priv/
  config/
    scenes/
      pong.exs               # Legacy config scene (fallback)

config/
  config.exs                 # Lunity editor mode config
```

## Scene definition

The pong scene is defined as a compiled module using the Lunity Scene DSL:

```elixir
defmodule Pong.Scenes.Pong do
  use Lunity.Scene

  scene do
    node :floor,        prefab: "box", position: {0, 0, -1}, scale: {12, 6, 0.3}
    node :paddle_left,  prefab: "box", position: {-18, 0, 0.5}, scale: {0.3, 1.5, 0.3}
    node :paddle_right, prefab: "box", position: {18, 0, 0.5}, scale: {0.3, 1.5, 0.3}
    node :wall_top,     prefab: "box", position: {0, 9.5, 0.15}, scale: {12, 0.3, 0.5}
    node :wall_bottom,  prefab: "box", position: {0, -9.5, 0.15}, scale: {12, 0.3, 0.5}
    node :ball,         prefab: "box", position: {0, 0, 0.5}, scale: {0.4, 0.4, 0.4}
  end
end
```

## How it uses Lunity

- **Scene DSL** -- scene layout defined as a compiled module with `use Lunity.Scene`
- **PrefabLoader** -- all elements use the `"box"` prefab (`priv/prefabs/box.glb`)
- **Editor mode** -- Lunity opens the editor window, loads the default scene, enables orbit camera
- **File watcher** -- changes to scene/config files trigger auto-reload with camera preserved
- **MCP tooling** -- agent-driven development via Lunity's MCP server

## Dependencies

- `lunity` - Game engine (path dependency to `../lunity`)
- `ecsx` - Entity Component System
