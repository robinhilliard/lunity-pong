defmodule Mix.Tasks.Pong.Run do
  @shortdoc "Run the Pong game"
  @moduledoc """
  Starts the Pong game window with the scene built from prefabs (wall, paddle, ball).

  ## Examples

      mix pong.run
  """
  use Mix.Task

  @impl true
  def run(_args) do
    Mix.Task.run("app.start")
    Pong.Game.run()
  end
end
