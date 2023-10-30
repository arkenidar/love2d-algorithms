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
  return {rectangle[1], rectangle[2], rectangle[1]+rectangle[3], rectangle[2]+rectangle[4] }
end

-- rettangolo da sponde
local function rectangle_from_bounds(bounds)
  return {bounds[1], bounds[2], bounds[3]-bounds[1], bounds[4]-bounds[2] }
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
    point[1]>=rectangle[1] and
    point[1]<=(rectangle[1]+rectangle[3]) and
    point[2]>=rectangle[2] and
    point[2]<=(rectangle[2]+rectangle[4])
end

local function point_mouse_position()
  return {love.mouse.getX(), love.mouse.getY()}
end
------------------------------------------------
local function input_touching()
  return love.mouse.isDown(1)
end
------------------------------------------------

-- disegna
function love.draw()
  -- *****************************************************

  local rectangle1 = {50, 30, 50, 100}
  local color1 = {1,0,1}
  draw_rectangle_color(rectangle1, color1)
  
  local rectangle2 = {love.mouse.getX(), love.mouse.getY(), rectangle1[3], rectangle1[4] }
  local color2 = {0,1,1}
  draw_rectangle_color(rectangle2, color2)
  
  -- - intersezione di 2 rettagoli -> rettangolo anche nullo : rectangle_operation_intersection
  local rectangle3 = rectangle_operation_intersection(rectangle1, rectangle2)
  local color3 = {1,0,0}
  if rectangle3 then draw_rectangle_color(rectangle3, color3) end
  
  -- *****************************************************
  
  -- - 1 punto interno ad un 1 rettangolo -> vero/falso : point_inside_rectangle
  
  local rectangle_mouse_inside = { color = {0.7,1,0.2} , 150,30, 50,100 }
  if point_inside_rectangle(point_mouse_position(), rectangle_mouse_inside) then
    rectangle_mouse_inside.color = {0.5, 0.5, 0.7} end
  draw_rectangle_color(rectangle_mouse_inside, rectangle_mouse_inside.color )
  
  -- *****************************************************
  
  -- - 1 punto interno ad un 1 rettangolo -> vero/falso : point_inside_rectangle
  
  local rectangle_mouse_touch = { color = {0.7,1,0.2} , 250,30, 50,100 }
  if input_touching() and
  point_inside_rectangle(point_mouse_position(), rectangle_mouse_touch) then
    rectangle_mouse_touch.color = {0.5, 0.5, 0.7} end
  draw_rectangle_color(rectangle_mouse_touch, rectangle_mouse_touch.color )
  
  -- *****************************************************
  
  -- - 1 punto interno ad un 1 poligono convesso -> vero/falso : point_inside_polygon_convex

  -- ...

  -- *****************************************************
end