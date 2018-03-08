local cell = require("cell")
local list = require("list")
local entity = require("entity")

local Maze = {} --A randomly generated maze composed of cells

local function update(self)
  for y = 0, rows - 1 do
    for x = 0, cols - 1 do
      self.grid[y][x].mvisited = false
    end
  end
end


local function draw(self, x, y)
  love.graphics.draw(self.canvas, 0 , 0) --Draw the maze which was printed to a canvas when it was generated. 
  for i = 0, rows -1 do
    for j = 0, cols - 1 do 
      if self.entities[i][j] then
        self.entities[i][j]:draw(0, 0)
      end
    end
  end
end


local function removeWalls(a, b) -- Removes the walls between cells a and b, used in maze generation.
  local x = a.x - b.x
  if x == 1 then
    b.walls[1] = false
  end
  if x == -1 then
    a.walls[1] = false
  end
  local y = a.y - b.y
  if y == 1 then
    b.walls[2] = false
  end
  if y == -1 then
    a.walls[2] = false
  end
end  


function Maze.create()
  inst = {}
  inst.grid = {} -- 2D array of cells, indices start at 0
  inst.mt = {} --metatable for grid
  inst.mt.__index = function (t, k) return {} end --This might be a little hack-y. This is so that when we call grid[y][x] with an invalid y, we get nil rather than an error.
  setmetatable(inst.grid, inst.mt)
  inst.trail = list.create() 
  inst.current = {}
  inst.entities = {}
  inst.removeWalls = removeWalls
  inst.draw = draw
  inst.exit = {}
  inst.update = update
  
  for y = 0, rows - 1  do --initializing the grid of cells and entities.
    inst.grid[y] = {}
    inst.entities[y] = {}
    for x = 0, cols - 1  do
      inst.grid[y][x] = cell.create(x, y, inst.grid)
    end
  end
  
  for i = 1, 3 do
    local randx = love.math.random(cols) - 1
    local randy = love.math.random(rows) - 1
    inst.entities[randy][randx] = entity.create(6, randx, randy)
  end
  
  --Maze generation algorithm starts here. We are implementing the algorithm found here: https://en.wikipedia.org/wiki/Maze_generation_algorithm#Recursive_backtracker
  
  inst.current = inst.grid[0][0] --Make a cell the current cell. We're chosing top left. Could easily be random or the player spawn location.
  local deadend = 0
  while inst.current do -- As long as there's a current cell
    inst.current.visited = true -- Mark current cell as visited.
    local new = inst.current:checkNeighbors() -- Examine the current cell's neighbors for an unvisited cell.
    if new then -- If there is an unvisited neighbor
      deadend = 0
      inst.trail:push(inst.current) --Push the current cell to the stack
      inst.removeWalls(inst.current, new) --Remove the wall between the current cell and the chosen cell
      inst.current = new -- The chosen cell becomes the current cell, go back to the start of the while loop.
    else --There are no unvisited neigbors.
      if deadend == 0 then
        deadend = 1
        if love.math.random(2) == 1 then inst.entities[inst.current.y][inst.current.x] = entity.create(love.math.random(5), inst.current.x, inst.current.y) end
      end
      inst.current = inst.trail:pop() --Pop a cell from the stack and make it the current cell. This is the backtracking element. Go back til we get a cell with unvisited neighbors or the maze is complete.
    end
  end
 -- inst.grid._et[index(cols-1, love.math.random(rows-1))].walls[1] = false --These two lines remove a random wall on the right and bottom of the maze so that it can open into other mazes.
 -- inst.grid._et[index(love.math.random(cols-1), rows-1)].walls[2]= false
  inst.grid[love.math.random(rows - 1)][cols - 1].walls[1] = false
  inst.grid[rows - 1][love.math.random(cols - 1)].walls[2] = false
  
  inst.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight()) --Create a canvas and draw the maze to the canvas to make the maze easy to draw later.
  love.graphics.setCanvas(inst.canvas)
  love.graphics.push()
  love.graphics.origin()
    for y = 0, rows - 1 do
      for x = 0, cols - 1 do
        inst.grid[y][x]:draw()
      end
    end
  love.graphics.pop()
  love.graphics.setCanvas()
    
  return inst
end




return Maze