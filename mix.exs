defmodule Pong.MixProject do
  use Mix.Project

  def project do
    [
      app: :pong,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
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
      # or from hex when published
      {:lunity, "~> 0.1.0", path: "../lunity"},
      {:ecsx, "~> 0.5"},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
