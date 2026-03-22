defmodule Pong.MixProject do
  use Mix.Project

  def project do
    [
      app: :pong,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp aliases do
    # Ensures path dep `lunity` is compiled before the task (avoids stale BEAM).
    # Single string so Mix runs `mix deps.compile lunity` (not a task named "lunity").
    [pw: ["deps.compile lunity", "lunity.player_window"]]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :wx],
      mod: {Pong.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:lunity, "~> 0.1.0", path: "../lunity"},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
