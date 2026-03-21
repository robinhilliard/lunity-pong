defmodule Pong.Phase0InputSpikeTest do
  @moduledoc """
  Phase 0 — S0/S2: raw `Lunity.Input.Session` state is visible inside an instance tick
  and can move a bound paddle entity.

  Phase 0 write-up: `lunity` repo `docs/phase0_findings.md`.
  """
  use ExUnit.Case, async: false

  alias Lunity.ComponentStore
  alias Lunity.Components.Position
  alias Lunity.Input.{Session, SessionMeta}
  alias Lunity.Instance
  alias Pong.Components.PaddleControl

  test "S0: keyboard held on a session moves bound paddle :paddle_left along Z" do
    id = "phase0_s0"
    sid = make_ref()

    try do
      assert {:ok, _pid} = Instance.start(Pong.Scenes.Pong, id: id, manager: Pong.Manager)

      :ok = Session.register(sid)

      true =
        Session.update_meta(sid, %SessionMeta{
          entity_id: :paddle_left,
          instance_id: id,
          user_id: "test",
          player_id: "player-s0"
        })

      ComponentStore.with_store(id, fn ->
        PaddleControl.put(:paddle_left, 1)
      end)

      z_before =
        ComponentStore.with_store(id, fn ->
          {_x, _y, z} = Position.get(:paddle_left)
          z
        end)

      Session.key_down(sid, :w)

      assert {:halted, true, _} =
               Instance.run_until(
                 id,
                 fn ->
                   {_x, _y, z} = Position.get(:paddle_left)
                   z > z_before + 0.01
                 end,
                 max_ticks: 120
               )
    after
      Session.unregister(sid)
      Instance.stop(id)
    end
  end

  test "S2: two sessions drive :paddle_left and :paddle_right independently" do
    id = "phase0_s2"
    left = make_ref()
    right = make_ref()

    try do
      assert {:ok, _pid} = Instance.start(Pong.Scenes.Pong, id: id, manager: Pong.Manager)

      :ok = Session.register(left)
      :ok = Session.register(right)
      true = Session.update_meta(left, %SessionMeta{entity_id: :paddle_left, instance_id: id})
      true = Session.update_meta(right, %SessionMeta{entity_id: :paddle_right, instance_id: id})

      ComponentStore.with_store(id, fn ->
        PaddleControl.put(:paddle_left, 1)
        PaddleControl.put(:paddle_right, 1)
      end)

      Session.key_down(left, :w)
      Session.key_down(right, :arrow_down)

      assert {:halted, true, _} =
               Instance.run_until(
                 id,
                 fn ->
                   {_xl, _yl, zl} = Position.get(:paddle_left)
                   {_xr, _yr, zr} = Position.get(:paddle_right)
                   zl > 0.05 and zr < -0.05
                 end,
                 max_ticks: 200
               )
    after
      Session.unregister(left)
      Session.unregister(right)
      Instance.stop(id)
    end
  end

  test "S1: SessionMeta.instance_id scopes input; same entity_id on another instance is unaffected" do
    ia = "phase0_ia"
    ib = "phase0_ib"
    sid = make_ref()

    try do
      assert {:ok, _} = Instance.start(Pong.Scenes.Pong, id: ia, manager: Pong.Manager)
      assert {:ok, _} = Instance.start(Pong.Scenes.Pong, id: ib, manager: Pong.Manager)

      :ok = Session.register(sid)

      true =
        Session.update_meta(sid, %SessionMeta{
          entity_id: :paddle_left,
          instance_id: ia
        })

      ComponentStore.with_store(ia, fn -> PaddleControl.put(:paddle_left, 1) end)
      ComponentStore.with_store(ib, fn -> PaddleControl.put(:paddle_left, 1) end)

      z_ib_before =
        ComponentStore.with_store(ib, fn ->
          {_x, _y, z} = Position.get(:paddle_left)
          z
        end)

      Session.key_down(sid, :w)

      assert {:halted, true, _} =
               Instance.run_until(
                 ia,
                 fn ->
                   ComponentStore.with_store(ia, fn ->
                     {_x, _y, z} = Position.get(:paddle_left)
                     z > 0.01
                   end)
                 end,
                 max_ticks: 120
               )

      z_ib_after =
        ComponentStore.with_store(ib, fn ->
          {_x, _y, z} = Position.get(:paddle_left)
          z
        end)

      assert abs(z_ib_after - z_ib_before) < 0.001
    after
      Session.unregister(sid)
      Instance.stop(ia)
      Instance.stop(ib)
    end
  end
end
