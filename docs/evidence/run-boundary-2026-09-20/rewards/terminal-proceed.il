METHOD System.Threading.Tasks.Task ProceedFromTerminalRewardsScreen()
 0000: ldloca.s 0
 0002: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.System.Runtime.CompilerServices.AsyncTaskMethodBuilder Create()
 0007: stfld field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0012: ldloca.s 0
 0014: ldarg.0 
 0015: stfld field:MegaCrit.Sts2.Core.Runs.RunManager <>4__this
 0020: ldloca.s 0
 0022: ldc.i4.m1 
 0023: stfld field:Int32 <>1__state
 0028: ldloca.s 0
 0030: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0035: ldloca.s 0
 0037: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void Start[<ProceedFromTerminalRewardsScreen>d__211](<ProceedFromTerminalRewardsScreen>d__211 ByRef)
 0042: ldloca.s 0
 0044: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0049: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.System.Threading.Tasks.Task get_Task()
 0054: ret 
