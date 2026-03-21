defmodule Pong.PlayerJoin do
  @moduledoc """
  Server-side player placement: picks a running Pong instance and controlled entity.

  Ignores client-supplied `instance_id` / `entity_id` — use `client` only for future
  hints (queue, side preference, etc.).
  """
  @behaviour Lunity.Web.PlayerJoin

  @impl true
  def assign(%{client: _client}) do
    case Lunity.Instance.list() |> Enum.sort() do
      [] ->
        {:error, "no_instances", "no game instance is running"}

      [instance_id | _] ->
        {:ok, instance_id, :paddle_left, nil}
    end
  end
end
