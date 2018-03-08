local Minotaur = {} -- The minotaur is a hostile NPC that chases the player through the labyrinth.

local list = require("list")

local function draw(self)
  for y = -1, 1 do 
    for x = -1, 1 do
      if self.game.map[y][x] == self.maze then
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("fill", ((self.x * w) + 5) +  (love.graphics.getWidth() * x), ((self.y * w)+ 5) +  (love.graphics.getHeight()) * y, w-10, w-10)
        love.graphics.setColor(255,255,255)
      end
    end
  end
end


local function findPath(self)
  --Adapted version of the maze generation algorithm to find a path to the player. Because these are "perfect" mazes, there is exactly one path from one point to any other point. So we can kinda just brute force it.
  local current = self.maze.grid[self.y][self.x] --initial cell is minotaur's location
  
  while current do --Is this necessary? There should always be a current. Think about and maybe rewrite this later.
    current.mvisited = true
    if current == self.goal then self.trail:push(current) break end --When the current cell is the goal, break the loop. The remaining trail is the path from goal to minotaur.
    
    local new = current:checkPath() --Find a neighbor without a wall between
    if new then --If there's an open neighbor
      self.trail:push(current) --push the chosen cell to the stack
      current = new --chosen cell becomes current cell, start again.
    else --if no open neighbors
      current = self.trail:pop() --backtrack
    end
  end
  
  for i = 1, self.trail.length do -- Trail is path from goal -> mino. Pop it all into a new stack, reversing the order so it's a path from mino -> goal.
    self.path:push(self.trail:pop()) -- We should rewrite this to skip this step now that we're using dequeues for our stacks.
  end

  
end

local function update(self)
  local player = self.game.player
  local map = self.game.map
  if self.maze == map[0][0] then --If in the same maze as the player, the player is the goal.
    self.goal = map[0][0].grid[player.y][player.x]
  else -- Else the exit is the goal
    self.goal = self.maze.exit 
  end
  if self.x == self.goal.x and self.y == self.goal.y and self.maze ~= map[0][0] then --we're on the goal
    local exitDirection = game.player.roomTrail:popleft()
    if exitDirection == "up" then
      self.maze = game.player.roomTrail:popleft()
      self.y = rows - 1
    elseif exitDirection == "down" then
      self.maze = game.player.roomTrail:popleft()
      self.y = 0
    elseif exitDirection == "left" then
      self.maze = game.player.roomTrail:popleft()
      self.x = cols - 1 
    elseif exitDirection == "right" then
      self.maze = game.player.roomTrail:popleft()
      self.x = 0
    end
  else -- We're not on the goal
  self:findPath() --Get a path
  self.path:pop() --Pop the current position off the path, should probably change findPath to do this for us.
  local step = self.path:pop() --Pop the next step along the path.
  if step then -- Take that step
    self.x = step.x
    self.y = step.y
  end

  end
  self.path = list.create() --clear the path, we're getting a new one next time.
  for y = 0, rows - 1 do
    for x = 0, cols - 1 do
      self.maze.grid[y][x].mvisited = false
    end
  end
  
  if self.maze.entities[self.y][self.x] then
    if self.maze.entities[self.y][self.x] and self.maze.entities[self.y][self.x].id == "trap" then
      self.trapped = 3
    end
    self.maze.entities[self.y][self.x] = nil
  end
  
end

function Minotaur.create(x, y, maze)
  local inst = {}
  inst.x = x
  inst.y = y
  inst.maze = maze
  inst.goal = inst.maze.grid[0][0]
  inst.trail = list.create()
  inst.path = list.create()
  inst.findPath = findPath
  inst.update = update
  inst.draw = draw
  inst.trapped = 0
  inst.game = nil
  return inst
end


return Minotaur