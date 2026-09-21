METHOD System.Threading.Tasks.Task EnableSkipAfterDelay(Single, System.Threading.CancellationToken)
 0000: ldloca.s 0
 0002: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.System.Runtime.CompilerServices.AsyncTaskMethodBuilder Create()
 0007: stfld field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0012: ldloca.s 0
 0014: ldarg.0 
 0015: stfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom <>4__this
 0020: ldloca.s 0
 0022: ldarg.1 
 0023: stfld field:Single delay
 0028: ldloca.s 0
 0030: ldarg.2 
 0031: stfld field:System.Threading.CancellationToken token
 0036: ldloca.s 0
 0038: ldc.i4.m1 
 0039: stfld field:Int32 <>1__state
 0044: ldloca.s 0
 0046: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0051: ldloca.s 0
 0053: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void Start[<EnableSkipAfterDelay>d__27](<EnableSkipAfterDelay>d__27 ByRef)
 0058: ldloca.s 0
 0060: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0065: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.System.Threading.Tasks.Task get_Task()
 0070: ret 
