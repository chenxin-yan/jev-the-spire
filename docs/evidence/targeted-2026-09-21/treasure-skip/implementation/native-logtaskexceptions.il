METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldloc.0 
 0008: pop 
 0009: nop 
 0010: ldloc.0 
 0011: brfalse.s 66
 0013: ldarg.0 
 0014: ldfld field:System.Threading.Tasks.Task task
 0019: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0024: stloc.1 
 0025: ldloca.s 1
 0027: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0032: brtrue.s 94
 0034: ldarg.0 
 0035: ldc.i4.0 
 0036: dup 
 0037: stloc.0 
 0038: stfld field:Int32 <>1__state
 0043: ldarg.0 
 0044: ldloc.1 
 0045: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0050: ldarg.0 
 0051: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0056: ldloca.s 1
 0058: ldarg.0 
 0059: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<LogTaskExceptions>d__4](System.Runtime.CompilerServices.TaskAwaiter ByRef, <LogTaskExceptions>d__4 ByRef)
 0064: leave.s 193
 0066: ldarg.0 
 0067: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0072: stloc.1 
 0073: ldarg.0 
 0074: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0079: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0085: ldarg.0 
 0086: ldc.i4.m1 
 0087: dup 
 0088: stloc.0 
 0089: stfld field:Int32 <>1__state
 0094: ldloca.s 1
 0096: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0101: leave.s 149
 0103: stloc.2 
 0104: ldloc.2 
 0105: isinst type:System.OperationCanceledException
 0110: brtrue.s 147
 0112: ldloc.2 
 0113: callvirt method:System.Object.System.String ToString()
 0118: ldc.i4.2 
 0119: call method:MegaCrit.Sts2.Core.Logging.Log.Void Error(System.String, Int32)
 0124: ldloc.2 
 0125: call method:MegaCrit.Sts2.Core.Debug.SentryService.Void CaptureException(System.Exception)
 0130: ldsfld field:System.Action`1[System.Exception] UnobservedFault
 0135: dup 
 0136: brtrue.s 141
 0138: pop 
 0139: br.s 147
 0141: ldloc.2 
 0142: callvirt method:System.Action`1[System.Exception].Void Invoke(System.Exception)
 0147: rethrow 
 0149: leave.s 174
 0151: stloc.3 
 0152: ldarg.0 
 0153: ldc.i4.s -2
 0155: stfld field:Int32 <>1__state
 0160: ldarg.0 
 0161: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0166: ldloc.3 
 0167: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0172: leave.s 193
 0174: ldarg.0 
 0175: ldc.i4.s -2
 0177: stfld field:Int32 <>1__state
 0182: ldarg.0 
 0183: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0188: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0193: ret 
