------------------------------------------------
-- Lua DEBUGGERS setup
------------------------------------------------

-- VISUAL STUDIO CODE debugger

-- Local Lua Debugger - simple Lua debugger with no dependencies
-- https://marketplace.visualstudio.com/items?itemName=tomblind.local-lua-debugger-vscode
require("lldebugger").start()

------------------------------------------------

-- ZEROBRANE STUDIO debugger

-- debugging support (/pkulchenko/MobDebug setup, works also in ZeroBrane Studio)

-- https://github.com/pkulchenko/MobDebug/blob/master/examples/start.lua
-- https://raw.githubusercontent.com/pkulchenko/MobDebug/master/src/mobdebug.lua

-- don't activate debugging if not specified this way
if arg[#arg] == "-debug" then
  -- activate debugging
  require("mobdebug").start()
end
------------------------------------------------

--[[
- 1 punto interno ad un 1 rettangolo -> vero/falso : point_inside_rectangle
- intersezione di 2 rettagoli -> rettangolo anche nullo : rectangle_operation_intersection
- 1 punto interno ad un 1 poligono convesso -> vero/falso : point_inside_polygon_convex
]]

-- disegna rettangolo colore
local function draw_rectangle_color(rectangle, color)
  love.graphics.setColor(color[1], color[2], color[3], color[4])
  love.graphics.rectangle("fill", rectangle[1], rectangle[2], rectangle[3], rectangle[4])
end

-- rettangolo sponde
local function rectangle_bounds(rectangle)
  return { rectangle[1], rectangle[2], rectangle[1] + rectangle[3], rectangle[2] + rectangle[4] }
end

-- rettangolo da sponde
local function rectangle_from_bounds(bounds)
  return { bounds[1], bounds[2], bounds[3] - bounds[1], bounds[4] - bounds[2] }
end

local function rectangle_bounds_intersect_boolean(bounds1, bounds2)
  local intersect_boolean =
      bounds1[1] < bounds2[3] and
      bounds1[3] > bounds2[1] and
      bounds1[2] < bounds2[4] and
      bounds1[4] > bounds2[2]
  return intersect_boolean
end

-- rettangolo operazione intersezione
-- - intersezione di 2 rettagoli -> rettangolo anche nullo : rectangle_operation_intersection
local function rectangle_operation_intersection(rectangle1, rectangle2)
  local bounds1 = rectangle_bounds(rectangle1)
  local bounds2 = rectangle_bounds(rectangle2)

  local intersect_boolean = rectangle_bounds_intersect_boolean(bounds1, bounds2)

  if not intersect_boolean then
    return nil
  end

  local intersection_rectangle
  local bounds3 = {
    math.max(bounds1[1], bounds2[1]),
    math.max(bounds1[2], bounds2[2]),
    math.min(bounds1[3], bounds2[3]),
    math.min(bounds1[4], bounds2[4])
  }
  intersection_rectangle = rectangle_from_bounds(bounds3)
  return intersection_rectangle
end

------------------------------------------------
local function point_inside_rectangle(point, rectangle)
  return
      point[1] >= rectangle[1] and
      point[1] <= (rectangle[1] + rectangle[3]) and
      point[2] >= rectangle[2] and
      point[2] <= (rectangle[2] + rectangle[4])
end

local function point_mouse_position()
  return { love.mouse.getX(), love.mouse.getY() }
end
------------------------------------------------
local function input_touching()
  return love.mouse.isDown(1)
end
------------------------------------------------
function love.load()
  love.window.setTitle("arkenidar / love2d-algorithms")
end

------------------------------------------------
local animations_delta_time
function love.update(delta_time)
  animations_delta_time = delta_time
end

------------------------------------------------
local input_touched = false
local input_touching_previously = false

local mode_rings = 0 -- 2 ring modes (selectable)

local circle2 = {
  radius = 50,
  center_x = 150 + 50 * 2 + 10,
  center_y = 250,
  input_inside_previously = false,
  radius_inner_animated_current = 25,
  radius_inner_animated_target = 25,
}

-- disegna
function love.draw()
  -- input_touched
  local input_touching_currently = input_touching()
  input_touched = input_touching_currently and not input_touching_previously
  input_touching_previously = input_touching_currently

  -- *****************************************************
  test_case_combined()

  circle_animations(circle2)
end

function test_case_combined()
  local rectangle1 = { 50, 30, 50, 100 }
  local color1 = { 0, 0, 1 }
  draw_rectangle_color(rectangle1, color1)

  local rectangle2 = { love.mouse.getX(), love.mouse.getY(), rectangle1[3], rectangle1[4] }
  -- post-poned

  -- - intersezione di 2 rettagoli -> rettangolo anche nullo : rectangle_operation_intersection
  local rectangle3 = rectangle_operation_intersection(rectangle1, rectangle2)

  if rectangle3 then
    -- post-poned to here (after intersection check)
    local color2 = { 0, 1, 1 }
    draw_rectangle_color(rectangle2, color2)
  end

  -- rectangle 3 after rectangle2
  local color3 = { 1, 0, 0 }
  if rectangle3 then draw_rectangle_color(rectangle3, color3) end

  -- *****************************************************

  -- - 1 punto interno ad un 1 rettangolo -> vero/falso : point_inside_rectangle

  local rectangle_mouse_inside = { color = { 0.7, 1, 0.2 }, 150, 30, 50, 100 }
  if point_inside_rectangle(point_mouse_position(), rectangle_mouse_inside) then
    rectangle_mouse_inside.color = { 1, 0.5, 0.7 }
  end
  draw_rectangle_color(rectangle_mouse_inside, rectangle_mouse_inside.color)

  -- *****************************************************

  -- - 1 punto interno ad un 1 rettangolo -> vero/falso : point_inside_rectangle

  local rectangle_mouse_touch = { color = { 0.7, 1, 0.2 }, 250, 30, 50, 100 }

  local point_is_inside = point_inside_rectangle(point_mouse_position(), rectangle_mouse_touch)

  -- if currently touching then color it
  if input_touching() and point_is_inside then
    rectangle_mouse_touch.color = { 1, 0.5, 0.7 }
  end

  -- if touched (one time) change "mode" variable
  if input_touched and point_is_inside then
    -- 2 ring modes (selectable)
    mode_rings = 1 - mode_rings -- 0 to 1. 1 to 0.
  end

  draw_rectangle_color(rectangle_mouse_touch, rectangle_mouse_touch.color)

  -- *****************************************************

  -- - 1 punto interno ad un 1 poligono convesso -> vero/falso : point_inside_polygon_convex

  --[[ PIP algorithms for convex and concave polygons
    (concave polygons as an extended case of convex polygons base case).
    ]]

  --[[ external links for inspiration:

  - original in DHTML (HTML5+ES)
  <https://github.com/arkenidar/point_in_polygon>

  - derivation for Lua and Love2D
  <https://github.com/arkenidar/Lua_Love2D_PointInPolygon-Algorithm>

  ]]

  -- ...

  -- *****************************************************

  -- reusable functions (module)
  require("utils_math")

  -- circle data
  local center_x, center_y = 150, 250
  local radius = 50

  -- move the "zero-angle", rotation
  local angle_offset = 90 -- degrees

  -- angle from mouse
  local angle = point_angle_from_center(point_mouse_position(), { center_x, center_y })
  angle = (angle + angle_offset) % 360
  angle = math.floor(angle)

  -- texts
  love.graphics.setColor(0, 1, 0)
  love.graphics.print("angle: " .. tostring(angle) .. "°", center_x, center_y - radius - 50)
  love.graphics.print("ring mode: " .. tostring(mode_rings), center_x, center_y - radius - 50 - 20)

  -- circle derivations: ring and sector conditions
  love.graphics.setColor(0, 1, 0)

  -- for each pixel in rectangle
  for px = center_x - radius, center_x + radius do
    for py = center_y - radius, center_y + radius do
      -- ring conditions
      local condition_ring
      local distance = point_distance_from_point({ center_x, center_y }, { px, py })
      condition_ring = distance <= radius and distance >= (radius / 1.3)

      -- sector conditions

      -- angle_point is angle related to current pixel position
      local angle_point = point_angle_from_center({ px, py }, { center_x, center_y })
      angle_point = (angle_point + angle_offset) % 360

      -- range of angles
      local angle_begin, angle_end

      -- 2 ring modes (selectable)
      if mode_rings == 0 then
        angle_begin = 0; angle_end = angle
      elseif mode_rings == 1 then
        local fixed_sector = 60
        angle_begin = ((angle - fixed_sector / 2) + 360) % 360
        angle_end = (angle + fixed_sector / 2) % 360
      end

      --love.graphics.print("angle_begin: " .. tostring(angle_begin) .. "°", center_x + radius + 20, center_y)
      --love.graphics.print("angle_end: " .. tostring(angle_end) .. "°", center_x + radius + 20, center_y + 20)

      local condition_sector
      if angle_begin >= angle_end then
        -- consider zero-angle discontinuity of angles
        condition_sector = angle_point >= angle_begin and angle_point <= 359
        condition_sector = condition_sector or (angle_point >= 0 and angle_point <= angle_end)
      else
        -- base case, simpler
        condition_sector = angle_point >= angle_begin and angle_point <= angle_end
      end

      -- combined conditions
      local condition_point = condition_ring and condition_sector
      if condition_point then
        love.graphics.points({ px, py }) -- draw pixel
      end
    end
  end
end

function circle_animations(circle)
  local radius = circle.radius
  local center_x, center_y = circle.center_x, circle.center_y
  local radius_inner_animated_current = circle.radius_inner_animated_current
  local radius_inner_animated_target = circle.radius_inner_animated_target

  -- *****************************************************
  -- pointer_went_inside, pointer_went_outside, circle.input_inside_previously
  local distance_pointer = point_distance_from_point({ center_x, center_y }, point_mouse_position())
  local input_inside_currently = distance_pointer <= radius

  local pointer_went_inside = input_inside_currently and not circle.input_inside_previously
  local pointer_went_outside = not input_inside_currently and circle.input_inside_previously

  circle.input_inside_previously = input_inside_currently
  -- *****************************************************
  -- circle.radius_inner_animated_target, proportion

  local proportion = 1
  if pointer_went_inside then
    proportion = 0.2
    radius_inner_animated_target = circle.radius * proportion
  elseif pointer_went_outside then
    proportion = 0.8
    radius_inner_animated_target = circle.radius * proportion
  end

  circle.radius_inner_animated_target = radius_inner_animated_target

  -- *****************************************************
  -- circle.radius_inner_animated_current, delta_size

  local delta_size = animations_delta_time * 100

  if radius_inner_animated_current < radius_inner_animated_target then
    radius_inner_animated_current = math.min(radius_inner_animated_target, radius_inner_animated_current + delta_size)
  elseif radius_inner_animated_current > radius_inner_animated_target then
    radius_inner_animated_current = math.max(radius_inner_animated_target, radius_inner_animated_current - delta_size)
  end

  circle.radius_inner_animated_current = radius_inner_animated_current

  -- *****************************************************

  -- for each pixel in rectangle
  for px = center_x - radius, center_x + radius do
    for py = center_y - radius, center_y + radius do
      -- pixel distance from circle center
      local distance = point_distance_from_point({ center_x, center_y }, { px, py })
      if distance <= circle.radius_inner_animated_current then
        -- inner circle
        love.graphics.setColor(0, 1, 0)  -- inner color
        love.graphics.points({ px, py }) -- draw inner pixel
      elseif distance <= radius then
        -- outer circle
        love.graphics.setColor(1, 1, 0)  -- outer color
        love.graphics.points({ px, py }) -- draw pixel
      end
    end
  end
  -- *****************************************************
end
