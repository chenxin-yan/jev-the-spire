METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldloc.0 
 0008: brfalse.s 85
 0010: ldarg.0 
 0011: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0016: ldnull 
 0017: newobj method:MegaCrit.Sts2.Core.Rewards.RewardsSet.Void .ctor(MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer)
 0022: ldarg.0 
 0023: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward] rewards
 0028: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Rewards.RewardsSet WithCustomRewards(System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward])
 0033: callvirt method:MegaCrit.Sts2.Core.Rewards.RewardsSet.System.Threading.Tasks.Task Offer()
 0038: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0043: stloc.1 
 0044: ldloca.s 1
 0046: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0051: brtrue.s 113
 0053: ldarg.0 
 0054: ldc.i4.0 
 0055: dup 
 0056: stloc.0 
 0057: stfld field:Int32 <>1__state
 0062: ldarg.0 
 0063: ldloc.1 
 0064: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0069: ldarg.0 
 0070: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0075: ldloca.s 1
 0077: ldarg.0 
 0078: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<OfferCustom>d__1](System.Runtime.CompilerServices.TaskAwaiter ByRef, <OfferCustom>d__1 ByRef)
 0083: leave.s 164
 0085: ldarg.0 
 0086: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0091: stloc.1 
 0092: ldarg.0 
 0093: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0098: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0104: ldarg.0 
 0105: ldc.i4.m1 
 0106: dup 
 0107: stloc.0 
 0108: stfld field:Int32 <>1__state
 0113: ldloca.s 1
 0115: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0120: leave.s 145
 0122: stloc.2 
 0123: ldarg.0 
 0124: ldc.i4.s -2
 0126: stfld field:Int32 <>1__state
 0131: ldarg.0 
 0132: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0137: ldloc.2 
 0138: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0143: leave.s 164
 0145: ldarg.0 
 0146: ldc.i4.s -2
 0148: stfld field:Int32 <>1__state
 0153: ldarg.0 
 0154: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0159: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0164: ret 
