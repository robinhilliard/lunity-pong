lunity.on("on_init", function(event)
  lunity.log("Pong base mod initialized")
end)

lunity.on("on_tick", function(e)
  local dt = e.dt
  local speed = 40.0
  local zlim = 6.0

  local function clamp(z, lo, hi)
    if z < lo then return lo end
    if z > hi then return hi end
    return z
  end

  local function move(entity, up_key, down_key)
    local dz = 0.0
    local actions = lunity.input.actions_for_entity(entity)
    if actions then
      for _, a in ipairs(actions) do
        if a.op == "move" then
          local m = a.dz or 0.0
          dz = dz + m * speed * dt
        end
      end
    end
    if dz == 0.0 then
      if lunity.input.is_key_down_for_entity(up_key, entity) then dz = dz + speed * dt end
      if lunity.input.is_key_down_for_entity(down_key, entity) then dz = dz - speed * dt end
    end
    if dz ~= 0.0 then
      local pos = lunity.entity.get(entity, "position")
      if pos then
        local x, y, z = pos[1], pos[2], pos[3]
        z = clamp(z + dz, -zlim, zlim)
        lunity.entity.set(entity, "position", {x, y, z})
      end
    end
  end

  move("paddle_left", "w", "s")
  move("paddle_right", "arrow_up", "arrow_down")
end)
