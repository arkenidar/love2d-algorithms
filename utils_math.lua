function point_difference_from_center(point, center)
  return { point[1] - center[1], point[2] - center[2] }
end

function point_distance_from_point(point1, point2)
  return math.sqrt((point1[1] - point2[1]) ^ 2 + (point1[2] - point2[2]) ^ 2)
end

function point_unitize_distance(point)
  local distance = point_distance_from_point(point, { 0, 0 })
  if distance == 0 then return point end
  return { point[1] / distance, point[2] / distance }
end

function point_angle_from_center(point, center)
  local difference = point_difference_from_center(point, center)
  difference = point_unitize_distance(difference)

  local angle
  angle = math.deg(math.acos(difference[1]))

  if difference[2] < 0 then angle = 360 - angle end

  return
      angle
      ,
      math.deg(math.acos(difference[1])),
      math.deg(math.asin(difference[2]))
end

function test_point_angle_from_center()
  local test_cases = {
    { { 1, 0 },   0 },
    { { 1, 1 },   45 },
    { { 0, 1 },   90 },
    { { -1, 1 },  90 + 45 },
    { { -1, 0 },  180 },
    { { -1, -1 }, 180 + 45 },
    { { 0, -1 },  180 + 90 },
    { { 1, -1 },  180 + 90 + 45 }
  }

  local all_valid = true
  for _, test_case in ipairs(test_cases) do
    local angle, angle1, angle2 = point_angle_from_center(test_case[1], { 0, 0 })

    io.write(string.format("%g \t %g \t %g \t", angle, angle1, angle2))
    local is_valid = test_case[2] == math.floor(angle)
    all_valid = all_valid and is_valid
    print("expected:", test_case[2], is_valid)
  end
  print("all_valid:", all_valid)
end

function utils_math_tests()
  test_point_angle_from_center()
end

if not ... then
  utils_math_tests()
else
  print("utils_math_tests() skipped")
end
