# threshold-helper.lua - produce summary data to enable sensible threshold values to be set on each outlet

## What does it do?

The `threshold-helper.lua` script is for Raritan intelligent PDUs which have individually metered outlets.

It produces summary data to enable sensible threshold values to be set on each outlet.

By default it runs for 10
minutes and takes samples every 5 seconds of the following values:

+ RMS Current
+ Active Power
+ Power Factor
+ RMS Voltage

After the default 10 minutes it displays a summary for each outlet similar to this example:

```
Outlet: HP Layer 3 Switch
  RMS Current        Min:   0.101  Avg:   0.103  Max:   0.106
  Active Power       Min:  14      Avg:  14      Max:  14
  Power Factor       Min:   0.57   Avg:   0.59   Max:   0.59 
  RMS Voltage        Min: 232.4    Avg: 234.7    Max: 236.3
```

## Why is this useful?

Raritan intelligent PDUs can be configured with threshold values on each outlet. If a threshold
is crossed the PDU can raise an alert (e.g. send an email).

The `threshold-helper.lua` script can be used to get an idea of what `normal` values are and this
should help in determining effective threshold values to set on each outlet on each PDU.

## Changing default duration and/or interval

To change the default duration of 10 minutes and/or the default sampling interval of 5 seconds use
the "Start With Arguments" menu option on the Lua scripts page of the PDU web interface.

To change duration specify an argument called `duration` and enter value for the number of minutes to run the
script.

To change sampling interval specify an argument called `interval` and enter value for the number of seconds
to wait between samples.

## Powered off outlets

The script also monitors the power state of the outlets.

If an outlet was powered off every time it was
sampled then a message similar to:

```
(likely powered off)
```

will appear after the outlet name/number.

If an outlet was powered off during at least one sample (but not all the samples)
then a message similar to:

```
(powered off some of the time)
```

will appear.

This is useful information because if an outlet was powered off for all or even one or two of the samples
then the summary figures will be misleading. For example the minimum current will be zero.

## Example output

Here is example output from a PX3-5260R Raritan intelligent PDU:

```
PDU has 12 outlets
Total sampling time is 10 minutes
Sampling interval is 5 seconds
A maximum of 120 samples will be taken
Taking outlet sample #1 at 10:25:26
Taking outlet sample #13 at 10:26:30
Taking outlet sample #25 at 10:27:34
Taking outlet sample #37 at 10:28:38
Taking outlet sample #49 at 10:29:42
Taking outlet sample #61 at 10:30:47
Taking outlet sample #73 at 10:31:51
Taking outlet sample #85 at 10:32:55
Taking outlet sample #97 at 10:33:59
Taking outlet sample #109 at 10:35:03
Completed sampling - a total of 113 samples were taken

Outlet: Cisco Switch (powered off some of the time)
  RMS Current        Min:   0.000  Avg:   0.057  Max:   0.133
  Active Power       Min:   0      Avg:   8      Max:  19
  Power Factor       Min:   0.59   Avg:   0.83   Max:   1.00 
  RMS Voltage        Min:   0.0    Avg: 103.9    Max: 235.7

Outlet: Laptop PSU
  RMS Current        Min:   0.105  Avg:   0.149  Max:   0.285
  Active Power       Min:  12      Avg:  18      Max:  38
  Power Factor       Min:   0.48   Avg:   0.52   Max:   0.58 
  RMS Voltage        Min: 232.2    Avg: 234.2    Max: 235.7

Outlet: Raspberry Pi
  RMS Current        Min:   0.000  Avg:   0.000  Max:   0.000
  Active Power       Min:   0      Avg:   0      Max:   0
  Power Factor       Min:   1.00   Avg:   1.00   Max:   1.00 
  RMS Voltage        Min: 232.2    Avg: 234.2    Max: 235.7

Outlet: Monitor
  RMS Current        Min:   0.220  Avg:   0.223  Max:   0.230
  Active Power       Min:  31      Avg:  31      Max:  32
  Power Factor       Min:   0.59   Avg:   0.60   Max:   0.61 
  RMS Voltage        Min: 232.2    Avg: 234.2    Max: 235.7

Outlet: Trailing Double Socket
  RMS Current        Min:   0.000  Avg:   0.000  Max:   0.000
  Active Power       Min:   0      Avg:   0      Max:   0
  Power Factor       Min:   1.00   Avg:   1.00   Max:   1.00 
  RMS Voltage        Min: 232.2    Avg: 234.2    Max: 235.7

Outlet: AI Cube 4G Router
  RMS Current        Min:   0.000  Avg:   0.021  Max:   0.042
  Active Power       Min:   0      Avg:   2      Max:   4
  Power Factor       Min:   1.00   Avg:   1.00   Max:   1.00 
  RMS Voltage        Min: 232.2    Avg: 234.2    Max: 235.7

Outlet: HP Layer 3 Switch
  RMS Current        Min:   0.101  Avg:   0.103  Max:   0.106
  Active Power       Min:  14      Avg:  14      Max:  14
  Power Factor       Min:   0.57   Avg:   0.59   Max:   0.59 
  RMS Voltage        Min: 232.4    Avg: 234.7    Max: 236.3

Outlet: VMWare ESX server
  RMS Current        Min:   0.190  Avg:   0.197  Max:   0.221
  Active Power       Min:  24      Avg:  25      Max:  26
  Power Factor       Min:   0.47   Avg:   0.53   Max:   0.55 
  RMS Voltage        Min: 232.4    Avg: 234.7    Max: 236.3

Outlet: 9 (likely powered off)
  RMS Current        Min:   0.000  Avg:   0.000  Max:   0.000
  Active Power       Min:   0      Avg:   0      Max:   0
  Power Factor       Min:   1.00   Avg:   1.00   Max:   1.00 
  RMS Voltage        Min:   0.0    Avg:   0.0    Max:   0.0

Outlet: 10 (likely powered off)
  RMS Current        Min:   0.000  Avg:   0.000  Max:   0.000
  Active Power       Min:   0      Avg:   0      Max:   0
  Power Factor       Min:   1.00   Avg:   1.00   Max:   1.00 
  RMS Voltage        Min:   0.0    Avg:   0.0    Max:   0.0

Outlet: 11 (likely powered off)
  RMS Current        Min:   0.000  Avg:   0.000  Max:   0.000
  Active Power       Min:   0      Avg:   0      Max:   0
  Power Factor       Min:   1.00   Avg:   1.00   Max:   1.00 
  RMS Voltage        Min:   0.0    Avg:   0.0    Max:   0.0

Outlet: 12 (powered off some of the time)
  RMS Current        Min:   0.000  Avg:   0.000  Max:   0.000
  Active Power       Min:   0      Avg:   0      Max:   0
  Power Factor       Min:   1.00   Avg:   1.00   Max:   1.00 
  RMS Voltage        Min:   0.0    Avg: 222.2    Max: 236.3

*** End of report ***
```

----------------------------------------------------

End of README-threshold-helper.md
