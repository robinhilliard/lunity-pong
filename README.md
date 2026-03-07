# Pong

A Pong game built on [Lunity](https://github.com/robinhilliard/lunity) and [EAGL](https://github.com/robinhilliard/eagl). Serves as the first game project for the Lunity engine, driving development of the scene, entity, and prefab DSLs, component system, and editor tooling.

## Running

```bash
mix pong.run
```

The game runs in Lunity's editor mode by default, with orbit camera controls and auto-reload on file changes.

## Development

For the full editor experience with scene hierarchy, MCP tools, and agent-driven development, run from the Pong project:

```bash
mix lunity.edit
```

This starts the Lunity editor window and MCP server. Configure Cursor to connect (see Lunity README). `mix pong.run` launches the standalone game window; `mix lunity.edit` is the development editor.

## Project structure

```
lib/
  pong.ex                    # Main module
  application.ex             # Application supervisor (starts Pong.Manager)
  pong/
    manager.ex               # Lunity.Manager (components, systems, tick loop)
    game.ex                  # Game window (play mode)
    components/
      position.ex            # {x, y, z} tensor component
      velocity.ex            # {vx, vy, vz} tensor component
      speed.ex               # Scalar float tensor component
      side.ex                # Paddle side (0=left, 1=right)
      paddle_control.ex      # Auto vs player control (0=auto)
    systems/
      move_ball.ex           # Applies velocity to position (defn)
      bounce_walls.ex        # Wall/paddle reflection and scoring (defn)
      auto_paddle.ex         # Auto paddle tracking (defn)
    scenes/
      pong.ex                # Scene module (use Lunity.Scene)
    entities/
      ball.ex                # Ball entity (inits Position, Velocity, Speed)
      paddle.ex              # Paddle entity (inits Position, Speed, Side, PaddleControl)

config/
  config.exs                 # Lunity editor mode config
```

## Component system

Pong uses Lunity's Nx-backed tensor components. All game state is stored in contiguous Nx tensors. Systems are `defn` functions that process entire tensors per tick -- no per-entity iteration loops.

Both paddles default to auto control (PaddleControl = 0). The AutoPaddle system tracks the ball with limited speed and a dead zone, producing rallies that eventually end.

## Dependencies

- `lunity` - Game engine (path dependency to `../lunity`)
