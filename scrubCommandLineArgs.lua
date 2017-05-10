local cmdLineScrubber = {}

local CMD_ARG_DELIMITER = "="

local ACCEPTED_CMD_LINE_ARGS = {
  DURATION = "dur",
  SOURCE_IP = "sip",
  DESTINATION_PORT = "port",
  NUM_PORTS_TO_SCAN = "numPorts",
  ATTACK_TYPE = "attackType",
}

local cmdLineArgMap = {
  [ACCEPTED_CMD_LINE_ARGS.DURATION] = 0,
  [ACCEPTED_CMD_LINE_ARGS.SOURCE_IP] = 0,
  [ACCEPTED_CMD_LINE_ARGS.DESTINATION_PORT] = 0,
  [ACCEPTED_CMD_LINE_ARGS.NUM_PORTS_TO_SCAN] = 0,
  [ACCEPTED_CMD_LINE_ARGS.ATTACK_TYPE] = 0,
}
  
  
function split(xString, xSeperator)
  if xSeperator == nil then
    xSeperator = "%s"
  end
  local words={}
  local ii=1
  for str in string.gmatch(xString, "([^"..xSeperator.."]+)") do
    words[ii] = str
    ii = ii + 1
  end
  return words
end


local function scrubCommandLineArgs(xCmdLineArgs)  
    local extractedData = {}
    
    for k, arg in ipairs(xCmdLineArgs) do
      local cmdLineArg = split(arg, CMD_ARG_DELIMITER)
      local identifier = cmdLineArg[1]
      local data       = cmdLineArg[2]
      extractedData[identifier] = data
    end
    return extractedData
end


local function isValidCommand(xCommandName)
  local isValid = false
  
  for acceptedCmdName, _ in pairs(cmdLineArgMap) do
      if acceptedCmdName == xCommandName then
        isValid = true
      end
  end
  return isValid
end


local function validateCmdLineArgs(xCmdLineArgs)
  for identifier, data in pairs(xCmdLineArgs) do
      local isValid = isValidCommand(identifier)
      if isValid then
          cmdLineArgMap[identifier] = data
      end
  end
end


function cmdLineScrubber.getCmdLineArgs(xCmdLineArgs)

  local extractedCommands = scrubCommandLineArgs(xCmdLineArgs)
  validateCmdLineArgs(extractedCommands)

  return cmdLineArgMap
end

return cmdLineScrubber