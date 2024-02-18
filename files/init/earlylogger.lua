local l, h = term.getSize()
local x, y = 1, 1
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()

local TRACE_LEVEL = 1
local INFO_LEVEL = 2
local WARN_LEVEL = 3

local messageBuffer = {}
local function recordMessage(level, message)
  table.insert(messageBuffer, {level = level, message = message})
end

local function nextLine()
  y = y + 1
  x = 1
  if y > h then
    term.scroll(1)
    y = h
  end
end

local function write(chars)
  for i = 1, #chars do
    local char = chars:sub(i, i)
    if x > l or char == "\n" then
      nextLine()
    end
    term.setCursorPos(x, y)
    term.write(char)
    x = x + 1
  end
end

local function termShow(color, level, message)
  term.setTextColor(colors.white)
  write("[")
  term.setTextColor(color)
  write(level)
  term.setTextColor(colors.white)
  write("] ")
  write(message)
  nextLine()
end

local earlyLogger = {}

function earlyLogger.trace(message)
  termShow(colors.blue, "TRACE", message)
  recordMessage(TRACE_LEVEL, message)
end
function earlyLogger.info(message)
  termShow(colors.green, "INFO", message)
  recordMessage(INFO_LEVEL, message)
end
function earlyLogger.warn(message)
  termShow(colors.yellow, "WARN", message)
  recordMessage(WARN_LEVEL, message)
end
function earlyLogger.error(message)
  termShow(colors.red, "ERROR", message)
  recordMessage(WARN_LEVEL, message)
end

return earlyLogger