local Cell = {} -- A cell is one of the squares within a maze. They have location, walls, and methods for examining neighboring cells.


local function draw(self)
  if self.visited then
    love.graphics.setColor(0.25, 0.25, 0.25)
    love.graphics.rectangle("fill", self.x * w, self. y * w, w, w)
    love.graphics.setColor(1,1,1)
  end
  love.graphics.setLineWidth(2)
  if self.walls[1] then
    love.graphics.line(self.x * w + w, self.y * w, self.x * w + w, self.y * w + w) --right
  end
  if self.walls[2] then
    love.graphics.line(self.x * w, self.y * w + w, self.x * w + w, self.y * w + w) -- bottom
  end
end

local function checkPath(self) --We could probably merge this with checkNeighbors. Same thing, adapted for use in the minotaur's pathfinding. Returns a neighbor without a wall in the way.
  local neighbors = {}
  local top = self.grid[self.y - 1][self.x]
  local right = self.grid[self.y][self.x + 1]
  local bottom = self.grid[self.y + 1][self.x]
  local left = self.grid[self.y][self.x - 1]

  if top and not top.mvisited and not top.walls[2] then
    table.insert(neighbors, top)
  end
  if right and not right.mvisited and not self.walls[1] then
    table.insert(neighbors, right)
  end
    if bottom and not bottom.mvisited and not self.walls[2] then
    table.insert(neighbors, bottom)
  end
    if left and not left.mvisited and not left.walls[1] then
    table.insert(neighbors, left)
  end
  if #neighbors > 0 then
    local r = love.math.random(#neighbors)
    return neighbors[r]
  else
    return nil
  end

end


local function checkNeighbors(self) -- Used in maze generation. Checks neighboring cells and returns a random unvisited neighbor.
  local neighbors = {} --Table to hold all neighbors.
  local top = self.grid[self.y - 1][self.x]
  local right = self.grid[self.y][self.x + 1]
  local bottom = self.grid[self.y + 1][self.x]
  local left = self.grid[self.y][self.x - 1]

  if top and not top.visited then --If the neighbor exists and has not been visited, add it to the table.
    table.insert(neighbors, top)
  end

  if right and not right.visited then
    table.insert(neighbors, right)
  end

  if bottom and not bottom.visited then
    table.insert(neighbors, bottom)
  end

  if left and not left.visited then
    table.insert(neighbors, left)
  end

  if #neighbors > 0 then
    local r = love.math.random(#neighbors)
    return neighbors[r] --Returns a random unvisitied neighbor or nil.
  else
    return nil
  end
end

function Cell.create(x, y, grid)
  local inst = {}
  inst.x = x
  inst.y = y
  inst.grid = grid
  inst.draw = draw
  inst.checkPath = checkPath
  inst.checkNeighbors = checkNeighbors
  inst.walls = {true, true} --right, bottom  --Each cell only has walls on the right and bottom sides. The surrounding cells create it's left and top side walls.
  inst.visited = false
  inst.mvisited = false
  inst.isExit = false
  return inst
end


return Cell
