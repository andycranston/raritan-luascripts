# raritan-luascripts

Some example Lua scripts for running on Raritan intelligent PDUs.

## lua-env.lua

This is a short script that outputs information about the
Lua environment on the PDU. Here is the output when run
on a PX3-5260R PDU:

```
Lua Environment
---------------
outputBufferSize: 16384
maxScriptSize: 40000
maxScriptMemoryGrowth: 262144
allScriptSize: 2536
autoStartDelay: 30000
amountOfScripts: 2
restartInterval: 10000
maxAmountOfScripts: 4
maxAllScriptSize: 100000
---
End
```

## monitor-current.lua

This script monitors the current being drawn on each outlet on the PDU.
If the difference between the last reading taken and the most recent reading
exceeds a threshold and email is sent. A significant fluctuation in 
the amount of current being drawn from an outlet could be of interest.

I recommend changing the values of `POLL_INTERVAL_IN_SECONDS` and
`THRESHOLD_VALUE_IN_AMPS` to
something appropriate for your PDU environment.

----------------------------------------------------
