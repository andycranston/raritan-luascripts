--
--  monitor-current.lua : monitor for outlets going from drawing current to drawing none
--

EMAIL_ACTION_NAME = "Email Action"
POLL_INTERVAL_IN_SECONDS = 5
DIFFERENCE_THRESHOLD_IN_AMPS = 0.1

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
      diff = lastc - currentc
      if diff < 0 then
        diff = diff * -1
      end
      if diff > DIFFERENCE_THRESHOLD_IN_AMPS then
        local subject = "Outlet " .. i .. " (" .. outletname .. ") on PDU " .. pduset.name .. " has exceeded the current difference threshold of " .. DIFFERENCE_THRESHOLD_IN_AMPS .. " amps"
        local msg = ""
        msg = msg .. "Outlet: " .. i .. " (" .. outletname .. ")\n"
        msg = msg .. "Last current value: " .. tostring(lastc) .. " amps\n"
        msg = msg .. "This current value: " .. tostring(currentc) .. " amps\n"
        msg = msg .. "Difference: " .. diff .. " amps\n"
        msg = msg .. "PDU: " .. pduset.name .. "\n"
        msg = msg .. "Model: " .. pdumd.nameplate.model .. "\n"
        sendemail(ee, emailaction, subject, msg)
      end
    end
  end

  last = current
end
