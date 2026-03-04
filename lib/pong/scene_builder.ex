defmodule Pong.SceneBuilder do
  @moduledoc """
  Builds the Pong scene from the "box" prefab with layout from config.

  Layout is defined in `priv/config/scenes/pong.exs`; positioning and scaling
  live in config rather than code.
  """
  import EAGL.Math
  alias EAGL.Node
  alias EAGL.Scene
  alias Lunity.{ConfigLoader, PrefabLoader}

  @scene_config_path "scenes/pong"

  @doc """
  Build the Pong scene. Requires an active GL context (call from render loop or setup).
  Returns `{:ok, scene}` or `{:error, reason}`.
  """
  @spec build(keyword()) :: {:ok, Scene.t()} | {:error, term()}
  def build(opts \\ []) do
    with {:ok, layout} <- load_scene_layout(opts),
         root <- Node.new(name: "pong_root"),
         root <- add_elements_from_config(root, layout, opts),
         scene <- Scene.new(name: "pong") |> Scene.add_root_node(root) do
      {:ok, scene}
    end
  end

  defp load_scene_layout(opts) do
    config_opts = Keyword.take(opts, [:app])
    case ConfigLoader.load_config(@scene_config_path, config_opts) do
      {:ok, config} when is_map(config) -> {:ok, config}
      {:ok, list} when is_list(list) -> {:ok, Map.new(list)}
      {:error, _} = err -> err
    end
  end

  defp add_elements_from_config(root, layout, opts) do
    Enum.reduce(layout, root, fn {name, element_config}, acc ->
      add_element(acc, name, element_config, opts)
    end)
  end

  defp add_element(parent, name, element_config, opts) do
    prefab_id = element_config[:prefab] || element_config["prefab"]
    pos = elem_to_vec3(element_config[:position] || element_config["position"])
    scale = elem_to_vec3(element_config[:scale] || element_config["scale"])

    with {:ok, prefab_scene, prefab_config} <- PrefabLoader.load_prefab(prefab_id, opts),
         {:ok, updated_parent, _} <-
           PrefabLoader.instantiate_prefab_from_loaded(prefab_scene, prefab_config, parent, %{}) do
      [child | rest] = updated_parent.children
      updated_child =
        child
        |> Node.set_position(pos)
        |> Node.set_scale(scale)
        |> Map.put(:name, to_string(name))
      Node.set_children(updated_parent, [updated_child | rest])
    else
      {:error, reason} ->
        raise "Failed to add element #{name}: #{inspect(reason)}"
    end
  end

  defp elem_to_vec3([x, y, z]) when is_number(x) and is_number(y) and is_number(z),
    do: vec3(x, y, z)
  defp elem_to_vec3(nil), do: vec3(0, 0, 0)
  defp elem_to_vec3(other), do: raise("Invalid position/scale: #{inspect(other)}")
end
