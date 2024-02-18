local rootFsNodePrototype = {}
local function createRootFsNode(backing, path)
  return setmetatable({
    backing = backing,
    path = path
  }, {__index = rootFsNodePrototype})
end

function rootFsNodePrototype:isDirectory()
  return self.backing.isDir(self.path)
end
function rootFsNodePrototype:hasChild(name)
  return self.backing.exists(self.path .. "/" .. name)
end
function rootFsNodePrototype:getChild(name)
  local path = self.path .. "/" .. name
  if not self.backing.exists(path) then
    error("File or directory does not exist")
  end
  return createRootFsNode(self.backing, path)
end
function rootFsNodePrototype:createDirectory(name)
  local path = self.path .. "/" .. name
  if self.backing.exists(path) then
    error("File or directory already exists")
  end
  self.backing.makeDir(path)
  return createRootFsNode(self.backing, path)
end
function rootFsNodePrototype:createFile(name)
  local path = self.path .. "/" .. name
  if self.backing.exists(path) then
    error("File or directory already exists")
  end
  local handle = self.backing.open(path, "w")
  self.backing.close(handle)
  
  return createRootFsNode(self.backing, path)
end
function rootFsNodePrototype:list()
  return self.backing.list(self.path)
end
function rootFsNodePrototype:delete()
  self.backing.delete(self.path)
end

local function formatRootFs(_)
  -- TODO: Look at parameter
  return createRootFsNode(fs, "/")
end

return {
  load = formatRootFs
}