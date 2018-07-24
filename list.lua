local List = {} -- Double-ended queue adapted from the example in PIL. I really like this as a generic stack / queue in one.
--A fun addition might be specifying "stack", "queue", or "deque" at creation to determine which methods are available and what generic push and pop do.

function List:pushleft(value)
  self.length = self.length + 1
  local first = self.first - 1
  self.first = first
  self[first] = value
end

function List:pushright(value)
  self.length = self.length + 1
  local last = self.last + 1
  self.last = last
  self[last] = value
end

function List:popleft()
  local first = self.first
  if first > self.last then return nil end -- Difference from PIL: if list is empty, we return nil rather than raise an error.
  self.length = self.length - 1
  local value = self[first]
  self[first] = nil        -- to allow garbage collection
  self.first = first + 1
  return value
end

function List:popright()
  local last = self.last
  if self.first > last then return nil end
  self.length = self.length - 1
  local value = self[last]
  self[last] = nil         -- to allow garbage collection
  self.last = last - 1
  return value
end

List.push = List.pushright --For easy use as a stack
List.pop = List.popright

function List.create()
  local inst = {}
  inst.first = 0
  inst.last = -1
  inst.length = 0
  setmetatable(inst, {__index = List})
  return inst
end

return List
