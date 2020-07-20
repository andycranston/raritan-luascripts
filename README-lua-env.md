# lua-env.lua

## What does it do?

This is a short script that outputs information about the
Lua environment on the PDU.

Here is the output when run on a PX3-5260R PDU:

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

## Why is this useful?

Knowing the maximum number of scripts that can be loaded on a PDU (the `maxAmountOfScripts` value)
may influence how scripts are written and deployed.

Also the value of `outputBufferSize` might be taken into consideration for scripts that run
continuously and regularly produce output.

----------------------------------------------------

End of README-lua-env.md
