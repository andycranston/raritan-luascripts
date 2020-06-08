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
If an outlet goes from a state of drawing current to not drawing any current
then an email is sent via the action "Email Action" on the PDU.

I recommend changing the value of the `POLL_INTERVAL_IN_SECONDS` to
something appropriate for your PDU environment. 60 for sixty seconds would be
a good starting point.

----------------------------------------------------
