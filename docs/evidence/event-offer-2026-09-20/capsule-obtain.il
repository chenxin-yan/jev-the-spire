METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Models.Relics.SmallCapsule <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse.s 98
 0017: ldloc.1 
 0018: call method:MegaCrit.Sts2.Core.Models.RelicModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0023: ldc.i4.1 
 0024: newobj method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward].Void .ctor(Int32)
 0029: dup 
 0030: ldloc.1 
 0031: call method:MegaCrit.Sts2.Core.Models.RelicModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0036: newobj method:MegaCrit.Sts2.Core.Rewards.RelicReward.Void .ctor(MegaCrit.Sts2.Core.Entities.Players.Player)
 0041: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward].Void Add(MegaCrit.Sts2.Core.Rewards.Reward)
 0046: call method:MegaCrit.Sts2.Core.Commands.RewardsCmd.System.Threading.Tasks.Task OfferCustom(MegaCrit.Sts2.Core.Entities.Players.Player, System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward])
 0051: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0056: stloc.2 
 0057: ldloca.s 2
 0059: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0064: brtrue.s 126
 0066: ldarg.0 
 0067: ldc.i4.0 
 0068: dup 
 0069: stloc.0 
 0070: stfld field:Int32 <>1__state
 0075: ldarg.0 
 0076: ldloc.2 
 0077: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0082: ldarg.0 
 0083: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0088: ldloca.s 2
 0090: ldarg.0 
 0091: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<AfterObtained>d__2](System.Runtime.CompilerServices.TaskAwaiter ByRef, <AfterObtained>d__2 ByRef)
 0096: leave.s 177
 0098: ldarg.0 
 0099: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0104: stloc.2 
 0105: ldarg.0 
 0106: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0111: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0117: ldarg.0 
 0118: ldc.i4.m1 
 0119: dup 
 0120: stloc.0 
 0121: stfld field:Int32 <>1__state
 0126: ldloca.s 2
 0128: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0133: leave.s 158
 0135: stloc.3 
 0136: ldarg.0 
 0137: ldc.i4.s -2
 0139: stfld field:Int32 <>1__state
 0144: ldarg.0 
 0145: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0150: ldloc.3 
 0151: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0156: leave.s 177
 0158: ldarg.0 
 0159: ldc.i4.s -2
 0161: stfld field:Int32 <>1__state
 0166: ldarg.0 
 0167: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0172: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0177: ret 
