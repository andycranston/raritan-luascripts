--
--  monitor-current.lua : monitor for outlets going from drawing current to drawing none
--

EMAIL_ACTION_NAME = "Email Action"
POLL_INTERVAL_IN_SECONDS = 5

require "Pdu"
require "EventEngine"

function getpowerandcurrent(pdu)
  local outlets = pdu:getOutlets()
  local t = {}
  local i = 1

  for _,outlet in ipairs(outlets) do
    local state = outlet:getState().powerState
      local current_sensor = outlet:getSensors().current
      local current = current_sensor:getReading().value
      local name = outlet:getSettings().name
      if name == "" then
        name = "Outlet " .. tostring(i)
      end
      t[i] = { state, current, name }
      i = i + 1
  end

  return t
end

function sendemail(ee, emailaction, subject, messagebody)
  local emailcontext = {
    { key = "LogMessage",  value = "Place holder text" },
    { key = "UseCustomMessage", value = "1" },
    { key = "CustomMessage", value = messagebody },
    { key = "UseCustomMailSubject", value = "1" },
    { key = "CustomMailSubject", value = subject },
  }

  local rc = ee:testAction(emailaction, emailcontext)
end

local ee = event.Engine:getDefault()
local emailaction = nil
local actions = ee:listActions()
for _,action in ipairs(actions) do
  if action.name == EMAIL_ACTION_NAME then
    emailaction = action
  end
end
if emailaction == nil then
  print("Cannot find the action called \"" .. EMAIL_ACTION_NAME .. "\"")
  os.exit(1)
end

local pdu = pdumodel.Pdu:getDefault()

local pduset = pdu:getSettings()

local pdumd = pdu:getMetaData()

local last = getpowerandcurrent(pdu)

while true do
  sleep(POLL_INTERVAL_IN_SECONDS)

  local current = getpowerandcurrent(pdu)

  for i = 1, #current do
    lastp = last[i][1]
    lastc = last[i][2]
    currentp = current[i][1]
    currentc = current[i][2]
    outletname = current[i][3]

    if (lastp == 1) and (currentp == 1) then
      if (lastc > 0) and (currentc == 0) then
        local subject = "Outlet " .. i .. " (" .. outletname .. ") on PDU " .. pduset.name .. " has stopped drawing current"
        local messagebody = "Outlet: " .. i .. " (" .. outletname .. ")" .. "\nPDU: " .. pduset.name .. "\nModel: " .. pdumd.nameplate.model
        sendemail(ee, emailaction, subject, messagebody)
      end
    end
  end

  last = current
end
