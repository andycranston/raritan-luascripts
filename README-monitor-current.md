# monitor-current.lua - monitor current being drawn on the PDU outlets

## What does it do?

This script monitors the current being drawn on each outlet on the PDU.
If the difference between the last reading taken and the most recent reading
exceeds a threshold then an email is sent.

I recommend changing the values of `POLL_INTERVAL_IN_SECONDS` and
`THRESHOLD_VALUE_IN_AMPS` to
something appropriate for your PDU environment.

You will also need to ensure that there is a action called `Email Action` defined
on the PDU which sends an email to the necessary person or email group.

Here is an example email sent by the `monitor-current.lua` script:

```
Subject: Outlet 2 (Laptop PSU) on PDU px3rack - current delta of 0.106 amps

Outlet: 2 (Laptop PSU)
Last current value: 0.255 amps
This current value: 0.149 amps
Current delta: 0.106 amps
PDU: px3rack
Model: PX3-5260R
```

## Why is this useful?

Raritan intelligent PDUs can send email alerts when values like outlet
current go above or below warning and critical thresholds. However, a significant fluctuation in 
the amount of current being drawn from an outlet might go
undetected if the before and after values were both within the warning thresholds.

It may be of interest to know when significant jumps like this happen and the `monitor-current.lua`
script makes this possible.

With a little work to the script other values (e.g. the RMS voltage) could be monitored in
a similar way.

----------------------------------------------------

End of README-monitor-current.md
