local Entity = {} -- An unmoving object in the maze that does something when player or mino walks over it. Powerups, traps, maze exit etc

local function draw(self, x, y)
  love.graphics.setColor(unpack(self.color))
  love.graphics.rectangle("fill", ((self.x * w) + 5) + x, ((self.y * w)+ 5) + y, w-10, w-10)
  love.graphics.setColor(1,1,1)
end

function Entity.create(id, x, y)
  local inst = {}
  inst.x = x
  inst.y = y
  inst.id = id
  inst.draw = draw
  inst.color = {0, 1, 0}

  if inst.id == 1 then -- Ariadne's Sword
    inst.color = {0.22, 0, 1}
    inst.id = "sword"
  elseif inst.id == 2 then -- Athena's Shield
    inst.color = {0.22, 0.78, 0.39}
    inst.id = "shield"
  elseif inst.id == 3 then -- Daedalus' Wings
    inst.color = {1, 0.51, 0.51}
    inst.id = "wings"
  elseif inst.id == 4 then -- Hermes' Sandals
    inst.color = {1, 1, 1}
    inst.id = "sandals"
  elseif inst.id == 5 then -- Helm of Hades
    inst.color = {0.78, 0, 0.78}
    inst.id = "helm"
  elseif inst.id == 6 then -- Trap
    inst.color = {0.3, 0.3, 0.3}
    inst.id = "trap"
  end

  return inst
end

return Entity
