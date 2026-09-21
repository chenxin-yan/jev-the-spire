METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.GameActions.ActionExecutor <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse.s 108
 0017: ldloc.0 
 0018: ldc.i4.1 
 0019: beq 212
 0024: call method:MegaCrit.Sts2.Core.Helpers.NonInteractiveMode.System.Func`1[System.Boolean] get_AutoSlayerCheck()
 0029: callvirt method:System.Func`1[System.Boolean].Boolean Invoke()
 0034: brfalse 248
 0039: leave 286
 0044: call method:MegaCrit.Sts2.Core.TestSupport.TestMode.Boolean get_IsOn()
 0049: brfalse.s 145
 0051: ldc.i4.s 50
 0053: call method:System.Threading.Tasks.Task.System.Threading.Tasks.Task Delay(Int32)
 0058: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0063: stloc.2 
 0064: ldloca.s 2
 0066: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0071: brtrue.s 136
 0073: ldarg.0 
 0074: ldc.i4.0 
 0075: dup 
 0076: stloc.0 
 0077: stfld field:Int32 <>1__state
 0082: ldarg.0 
 0083: ldloc.2 
 0084: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0089: ldarg.0 
 0090: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0095: ldloca.s 2
 0097: ldarg.0 
 0098: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<WaitForUnpause>d__31](System.Runtime.CompilerServices.TaskAwaiter ByRef, <WaitForUnpause>d__31 ByRef)
 0103: leave 305
 0108: ldarg.0 
 0109: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0114: stloc.2 
 0115: ldarg.0 
 0116: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0121: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0127: ldarg.0 
 0128: ldc.i4.m1 
 0129: dup 
 0130: stloc.0 
 0131: stfld field:Int32 <>1__state
 0136: ldloca.s 2
 0138: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0143: br.s 248
 0145: call method:MegaCrit.Sts2.Core.Nodes.NGame.MegaCrit.Sts2.Core.Nodes.NGame get_Instance()
 0150: ldloca.s 4
 0152: initobj type:System.Threading.CancellationToken
 0158: ldloc.s 4
 0160: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.System.Threading.Tasks.Task`1[System.Single] AwaitProcessFrame(Godot.Node, System.Threading.CancellationToken)
 0165: callvirt method:System.Threading.Tasks.Task`1[System.Single].System.Runtime.CompilerServices.TaskAwaiter`1[System.Single] GetAwaiter()
 0170: stloc.3 
 0171: ldloca.s 3
 0173: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Single].Boolean get_IsCompleted()
 0178: brtrue.s 240
 0180: ldarg.0 
 0181: ldc.i4.1 
 0182: dup 
 0183: stloc.0 
 0184: stfld field:Int32 <>1__state
 0189: ldarg.0 
 0190: ldloc.3 
 0191: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Single] <>u__2
 0196: ldarg.0 
 0197: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0202: ldloca.s 3
 0204: ldarg.0 
 0205: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<WaitForUnpause>d__31](System.Runtime.CompilerServices.TaskAwaiter`1[System.Single] ByRef, <WaitForUnpause>d__31 ByRef)
 0210: leave.s 305
 0212: ldarg.0 
 0213: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Single] <>u__2
 0218: stloc.3 
 0219: ldarg.0 
 0220: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Single] <>u__2
 0225: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Single]
 0231: ldarg.0 
 0232: ldc.i4.m1 
 0233: dup 
 0234: stloc.0 
 0235: stfld field:Int32 <>1__state
 0240: ldloca.s 3
 0242: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Single].Single GetResult()
 0247: pop 
 0248: ldloc.1 
 0249: ldfld field:Boolean _isPaused
 0254: brtrue 44
 0259: leave.s 286
 0261: stloc.s 5
 0263: ldarg.0 
 0264: ldc.i4.s -2
 0266: stfld field:Int32 <>1__state
 0271: ldarg.0 
 0272: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0277: ldloc.s 5
 0279: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0284: leave.s 305
 0286: ldarg.0 
 0287: ldc.i4.s -2
 0289: stfld field:Int32 <>1__state
 0294: ldarg.0 
 0295: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0300: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0305: ret 
