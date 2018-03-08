local Entity = {} -- An unmoving object in the maze that does something when player or mino walks over it. Powerups, traps, maze exit etc

local function draw(self, x, y)
  love.graphics.setColor(unpack(self.color))
  love.graphics.rectangle("fill", ((self.x * w) + 5) + x, ((self.y * w)+ 5) + y, w-10, w-10)
  love.graphics.setColor(255,255,255)
end

function Entity.create(id, x, y)
  local inst = {}
  inst.x = x
  inst.y = y
  inst.id = id
  inst.draw = draw
  inst.color = {0, 255, 0}
  
  if inst.id == 1 then -- Ariadne's Sword
    inst.color = {55, 0, 255}
    inst.id = "sword"
  elseif inst.id == 2 then -- Athena's Shield
    inst.color = {55, 200, 100}
    inst.id = "shield"
  elseif inst.id == 3 then -- Daedalus' Wings
    inst.color = {255, 130, 130}
    inst.id = "wings"
  elseif inst.id == 4 then -- Hermes' Sandals
    inst.color = {255, 255, 255}
    inst.id = "sandals"
  elseif inst.id == 5 then -- Helm of Hades
    inst.color = {200, 0, 200}
    inst.id = "helm"
  elseif inst.id == 6 then -- Trap
    inst.color = {75, 75, 75}
    inst.id = "trap"
  end
  
  return inst
end

return Entity