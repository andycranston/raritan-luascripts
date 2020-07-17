--
--  @(!--#) @(#) threshold-helper.lua, version 012, 17-kjuly-2020

-- sample outlet data and print summary to help set thresholds
--
-- defaultArg duration "10"
-- defaultArg interval "5"
--

duration = ARGS["duration"]
interval = ARGS["interval"]

duration = duration * 60

require "Pdu"

local pdu = pdumodel.Pdu:getDefault()

local outlets = pdu:getOutlets()

local n = #outlets

if n == 0 then
  io.write("*** This PDU does not appear to have any outlets ***\n")
  os.exit(1)
end

if outlets[1]:getSensors().current == nil then
  io.write("*** This PDU does not appear to have metered outlets ***\n")
  os.exit(1)
end

io.write("PDU has " .. n .. " outlets\n")

io.write("Total sampling time is " .. string.format("%d", (duration // 60)) .. " minute")
if (duration // 60) ~= 1 then
  io.write("s")
end
if (duration % 60) > 0 then
  io.write(" and " .. string.format("%d", duration % 60) .. " second")
  if (duration % 60) ~= 1 then
    io.write("s")
  end
end
io.write("\n")

io.write("Sampling interval is " .. string.format("%d", interval) .. " second")
if tonumber(interval) ~= 1 then
  io.write("s")
end
io.write("\n")

local samplecount = duration // interval

io.write("A maximum of " .. string.format("%d", samplecount) .. " samples will be taken\n")

local samplemodulo = 1
if samplecount >= 10 then
  samplemodulo = (samplecount // 10)
end

-- io.write("Modulo is " .. tostring(samplemodulo) .. "\n")

local finishtime = os.time() + duration
local c = 0
local ostat = {}
for i = 1, n do
  ostat[i] = {}
  ostat[i].current  = {}
  ostat[i].apower   = {}
  ostat[i].powerf   = {}
  ostat[i].voltage  = {}
  ostat[i].offcount = 0
end

while os.time() <= finishtime do
  c = c + 1

  if (((c - 1) % samplemodulo) == 0) then
    io.write("Taking outlet sample #" .. tostring(c) .. " at " .. os.date("%X") .. "\n")
  end

  for i,outlet in ipairs(outlets) do
    -- RMS current
    local current_sensor = outlet:getSensors().current
    local current = current_sensor:getReading().value
    if c == 1 then
      ostat[i].current.total = current
      ostat[i].current.min = current
      ostat[i].current.max = current
    else
      ostat[i].current.total = ostat[i].current.total + current
      if current < ostat[i].current.min then
        ostat[i].current.min = current
      end
      if current > ostat[i].current.max then
        ostat[i].current.max = current
      end
    end
    -- RMS active power
    local apower_sensor = outlet:getSensors().activePower
    local apower = apower_sensor:getReading().value
    if c == 1 then
      ostat[i].apower.total = apower
      ostat[i].apower.min = apower
      ostat[i].apower.max = apower
    else
      ostat[i].apower.total = ostat[i].apower.total + apower
      if apower < ostat[i].apower.min then
        ostat[i].apower.min = apower
      end
      if apower > ostat[i].apower.max then
        ostat[i].apower.max = apower
      end
    end
    -- RMS power factor
    local powerf_sensor = outlet:getSensors().powerFactor
    local powerf = powerf_sensor:getReading().value
    if c == 1 then
      ostat[i].powerf.total = powerf
      ostat[i].powerf.min = powerf
      ostat[i].powerf.max = powerf
    else
      ostat[i].powerf.total = ostat[i].powerf.total + powerf
      if powerf < ostat[i].powerf.min then
        ostat[i].powerf.min = powerf
      end
      if powerf > ostat[i].powerf.max then
        ostat[i].powerf.max = powerf
      end
    end
    -- RMS voltage
    local voltage_sensor = outlet:getSensors().voltage
    local voltage = voltage_sensor:getReading().value
    if c == 1 then
      ostat[i].voltage.total = voltage
      ostat[i].voltage.min = voltage
      ostat[i].voltage.max = voltage
    else
      ostat[i].voltage.total = ostat[i].voltage.total + voltage
      if voltage < ostat[i].voltage.min then
        ostat[i].voltage.min = voltage
      end
      if voltage > ostat[i].voltage.max then
        ostat[i].voltage.max = voltage
      end
    end
    -- Off counter
    local pstate = outlet:getState().powerState
    if pstate == pdumodel.Outlet.PowerState.PS_OFF then
      ostat[i].offcount = ostat[i].offcount + 1
    end
  end

  sleep(interval)
end

io.write("Completed sampling - a total of " .. c .. " samples were taken\n")

for i,outlet in ipairs(outlets) do
  local outletname = outlet:getSettings().name

  if outletname == "" then
    outletname = tostring(i)
  end

  io.write("\n")
  io.write("Outlet: " .. outletname)
  if ostat[i].offcount == c then
    io.write(" (likely powered off)")
  elseif ostat[i].offcount > 0 then
    io.write(" (powered off some of the time)")
  end
  io.write("\n")

  io.write("  RMS Current      ")
  io.write("  Min: " .. string.format("%7.3f", ostat[i].current.min))
  io.write("  Avg: " .. string.format("%7.3f", ostat[i].current.total / c))
  io.write("  Max: " .. string.format("%7.3f", ostat[i].current.max))
  io.write("\n")

  io.write("  Active Power     ")
  io.write("  Min: " .. string.format("%3.0f    ", ostat[i].apower.min))
  io.write("  Avg: " .. string.format("%3.0f    ", ostat[i].apower.total / c))
  io.write("  Max: " .. string.format("%3.0f    ", ostat[i].apower.max))
  io.write("\n")

  io.write("  Power Factor     ")
  io.write("  Min: " .. string.format("  %4.2f ", ostat[i].powerf.min))
  io.write("  Avg: " .. string.format("  %4.2f ", ostat[i].powerf.total / c))
  io.write("  Max: " .. string.format("  %4.2f ", ostat[i].powerf.max))
  io.write("\n")

  io.write("  RMS Voltage      ")
  io.write("  Min: " .. string.format("%5.1f  ", ostat[i].voltage.min))
  io.write("  Avg: " .. string.format("%5.1f  ", ostat[i].voltage.total / c))
  io.write("  Max: " .. string.format("%5.1f  ", ostat[i].voltage.max))
  io.write("\n")
end

io.write("\n")
io.write("*** End of report ***\n")

return 4
