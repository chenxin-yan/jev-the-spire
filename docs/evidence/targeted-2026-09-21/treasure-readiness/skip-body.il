METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse.s 82
 0017: ldarg.0 
 0018: ldfld field:Single delay
 0023: ldarg.0 
 0024: ldfld field:System.Threading.CancellationToken token
 0029: ldc.i4.0 
 0030: call method:MegaCrit.Sts2.Core.Commands.Cmd.System.Threading.Tasks.Task Wait(Single, System.Threading.CancellationToken, Boolean)
 0035: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0040: stloc.2 
 0041: ldloca.s 2
 0043: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0048: brtrue.s 110
 0050: ldarg.0 
 0051: ldc.i4.0 
 0052: dup 
 0053: stloc.0 
 0054: stfld field:Int32 <>1__state
 0059: ldarg.0 
 0060: ldloc.2 
 0061: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0066: ldarg.0 
 0067: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0072: ldloca.s 2
 0074: ldarg.0 
 0075: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<EnableSkipAfterDelay>d__27](System.Runtime.CompilerServices.TaskAwaiter ByRef, <EnableSkipAfterDelay>d__27 ByRef)
 0080: leave.s 185
 0082: ldarg.0 
 0083: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0088: stloc.2 
 0089: ldarg.0 
 0090: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0095: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0101: ldarg.0 
 0102: ldc.i4.m1 
 0103: dup 
 0104: stloc.0 
 0105: stfld field:Int32 <>1__state
 0110: ldloca.s 2
 0112: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0117: ldarg.0 
 0118: ldflda field:System.Threading.CancellationToken token
 0123: call method:System.Threading.CancellationToken.Boolean get_IsCancellationRequested()
 0128: brtrue.s 141
 0130: ldloc.1 
 0131: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0136: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Enable()
 0141: leave.s 166
 0143: stloc.3 
 0144: ldarg.0 
 0145: ldc.i4.s -2
 0147: stfld field:Int32 <>1__state
 0152: ldarg.0 
 0153: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0158: ldloc.3 
 0159: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0164: leave.s 185
 0166: ldarg.0 
 0167: ldc.i4.s -2
 0169: stfld field:Int32 <>1__state
 0174: ldarg.0 
 0175: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0180: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0185: ret 
