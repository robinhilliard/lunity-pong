# Pong

A Pong game built on the [Lunity Game Engine](https://github.com/robinhilliard/lunity) as a starter project.

## Prerequisites

Pong depends on Lunity and EAGL, which require Erlang/OTP 25+ with wx support, Elixir 1.17+, and OpenGL 3.3+.

### macOS

Use Homebrew — it builds Erlang with wx correctly configured. Do **not** use asdf-installed Erlang; it links against wxWidgets at build time and breaks when Homebrew upgrades wxWidgets.

```bash
brew install erlang elixir
```

If you also use asdf for other projects, the `.tool-versions` files in all three projects are set to `system`, so asdf will use Homebrew's Erlang and Elixir automatically.

Verify: `elixir --version` should show matching OTP versions (e.g. "compiled with Erlang/OTP 26" when running OTP 26). Mismatched versions cause `nif_not_loaded` errors on `:gl.*` calls.

**Cursor/ElixirLS**: If ElixirLS shows "Failed to run elixir check command", launch Cursor from the terminal (`cursor .`) so it inherits your shell PATH.

### Linux / WSL2

```bash
# Erlang, Elixir, OpenGL drivers, file watching
sudo apt install erlang elixir libgl1-mesa-dev libglu1-mesa-dev inotify-tools
```

WSL2 works for development but OpenGL runs through a software layer — expect lower frame rates and input lag compared to native Linux or macOS.

### Verify

```bash
elixir --version    # Check Elixir and OTP versions match
mix pong.check      # Checks elixir, erlang, wx, and compilation
```

## Setup

```bash
mix setup    # Fetch deps for pong, lunity, eagl
```

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
