# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# Run "mix help config" for more information.

import Config

config :logger, :console, format: "[$level] $message\n"

# Lunity: run in editor mode (opens window). Required for mix run -e; MCP sets this too.
# If the window crashes, set default_scene to nil to disable auto-load and debug.
config :lunity,
  mode: :editor,
  default_scene: "pong",
  scene_builders: %{
    "pong" => {Pong.SceneBuilder, :build}
  }
