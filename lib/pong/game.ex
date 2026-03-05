defmodule Pong.Game do
  @moduledoc """
  Pong game window. Loads the scene via Lunity.SceneLoader from config.
  """
  use EAGL.Window
  use EAGL.Const
  use EAGL.OrbitCamera
  import Bitwise

  alias EAGL.Scene
  alias Lunity.SceneLoader

  def run(opts \\ []) do
    default_opts = [
      depth_testing: true,
      size: {1024, 768},
      enter_to_exit: true
    ]

    EAGL.Window.run(
      __MODULE__,
      "Pong",
      Keyword.merge(default_opts, opts)
    )
  end

  @impl true
  def setup do
    with {:ok, program} <- GLTF.EAGL.create_pbr_shader(),
         {:ok, scene, _entities} <-
           SceneLoader.load_scene(Pong.Scenes.Pong, shader_program: program) do
      orbit = EAGL.OrbitCamera.fit_to_scene(scene)
      {:ok, %{program: program, scene: scene, orbit: orbit}}
    end
  end

  @impl true
  def render(w, h, %{program: prog, scene: scene, orbit: orbit} = state) do
    :gl.viewport(0, 0, trunc(w), trunc(h))
    :gl.clearColor(0.1, 0.12, 0.15, 1.0)
    :gl.clear(@gl_color_buffer_bit ||| @gl_depth_buffer_bit)
    :gl.enable(@gl_cull_face)
    :gl.cullFace(@gl_back)

    :gl.useProgram(prog)
    view = EAGL.OrbitCamera.get_view_matrix(orbit)
    proj = EAGL.OrbitCamera.get_projection_matrix(orbit, w / max(h, 1))

    GLTF.EAGL.set_pbr_uniforms(prog,
      view_pos: EAGL.OrbitCamera.get_position(orbit)
    )

    Scene.render(scene, view, proj)
    {:ok, state}
  end

  @impl true
  def cleanup(%{program: p}) do
    EAGL.Shader.cleanup_program(p)
    :ok
  end
end
