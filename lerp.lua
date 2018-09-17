--Linear interpolation. See wiki for detail. Basically, returns a number t*100% of the way between a and b.
local function lerp(a, b, t)
  return a * (1-t) + (b*t)
end
return lerp
