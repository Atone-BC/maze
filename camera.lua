local Camera = {} --Camera effect following player.

local function lerp(a, b, t) -- Linear interpolation function, returning a value some percent t (0.01 = 1%) of the way between a and b.
  return a * (1-t) + (b*t)
end

local function draw(self) --Offsets subsequent draws
  love.graphics.origin()
  love.graphics.translate(self.x, self.y)
end

local function update(self)
    self.x = self.x or (self.game.middle.x - self.game.player.x) * W
    self.y = self.y or (self.game.middle.y - self.game.player.y) * W

    if self.x > ((self.game.middle.x - self.game.player.x) * W) + 5
    or self.x < ((self.game.middle.x - self.game.player.x) * W) - 5
    or self.y > ((self.game.middle.y - self.game.player.y) * W) + 5
    or self.y < ((self.game.middle.y - self.game.player.y) * W) - 5
    then
      self.x = lerp( self.x, (self.game.middle.x - self.game.player.x) * W, self.speed) --Lerp between current offset and new offset for smooth camera.
      self.y = lerp( self.y, (self.game.middle.y - self.game.player.y) * W, self.speed)
    end

end

function Camera.create()
  local inst = {}
  inst.x = nil
  inst.y = nil
  inst.speed = 0.01
  inst.update = update
  inst.game = nil
  inst.draw = draw
  return inst
end
return Camera
