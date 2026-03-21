defmodule Pong.PongGlRouteTest do
  use ExUnit.Case, async: true

  test "GET /pong serves priv/static/pong_gl.html from host app" do
    conn =
      :get
      |> Plug.Test.conn("/pong")
      |> Lunity.Web.Router.call(Lunity.Web.Router.init([]))

    assert conn.status == 200
    assert conn.resp_body =~ "webgl2"
    assert conn.resp_body =~ "pong_gl"
  end
end
