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
exceeds a threshold then an email is sent. A significant fluctuation in 
the amount of current being drawn from an outlet could be of interest.

I recommend changing the values of `POLL_INTERVAL_IN_SECONDS` and
`THRESHOLD_VALUE_IN_AMPS` to
something appropriate for your PDU environment.

You will also need to ensure that there is a action called `Email Action` defined
on the PDU which sends an email to the necessary person or email group.

## threshold-helper.lua

This script is for PDUs which have individually metered outlets. It runs for
a specified amount of time and takes regular samples of the following values:

+ RMS Current
+ Active Power
+ Power Factor
+ RMS Voltage

for each outlet. At the end of the time it displays a summary for each outlet and value showing the minumum
observed value, the maximum and the average.

These values should help the person configuring the outlet thresholds on the PDU.

By default the script runs for 10 minutes and takes samples at 5 second intervals. These
values can be changed by starting the script using the `Start With Arguments` option.
To specify a different amount of time the script should run add an argument called `duration`
and set the value to the number of minutes. To specify a different sampling rate/interval
add an argument called `interval` and set the value to the number of seconds to wait between
taking a sample.


----------------------------------------------------
