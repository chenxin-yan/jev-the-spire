METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldloc.0 
 0008: brfalse 151
 0013: ldarg.0 
 0014: ldfld field:MegaCrit.Sts2.Core.Rooms.AbstractRoom room
 0019: isinst type:MegaCrit.Sts2.Core.Rooms.CombatRoom
 0024: stloc.2 
 0025: ldloc.2 
 0026: brfalse.s 72
 0028: ldloc.2 
 0029: callvirt method:MegaCrit.Sts2.Core.Rooms.CombatRoom.MegaCrit.Sts2.Core.Models.EncounterModel get_Encounter()
 0034: stloc.3 
 0035: ldloc.3 
 0036: brfalse.s 72
 0038: ldloc.3 
 0039: callvirt method:MegaCrit.Sts2.Core.Models.EncounterModel.Boolean get_ShouldGiveRewards()
 0044: brtrue.s 72
 0046: ldarg.0 
 0047: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0052: ldnull 
 0053: newobj method:MegaCrit.Sts2.Core.Rewards.RewardsSet.Void .ctor(MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer)
 0058: ldarg.0 
 0059: ldfld field:MegaCrit.Sts2.Core.Rooms.AbstractRoom room
 0064: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Rewards.RewardsSet EmptyForRoom(MegaCrit.Sts2.Core.Rooms.AbstractRoom)
 0069: stloc.1 
 0070: br.s 96
 0072: ldarg.0 
 0073: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0078: ldnull 
 0079: newobj method:MegaCrit.Sts2.Core.Rewards.RewardsSet.Void .ctor(MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer)
 0084: ldarg.0 
 0085: ldfld field:MegaCrit.Sts2.Core.Rooms.AbstractRoom room
 0090: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Rewards.RewardsSet WithRewardsFromRoom(MegaCrit.Sts2.Core.Rooms.AbstractRoom)
 0095: stloc.1 
 0096: ldloc.1 
 0097: callvirt method:MegaCrit.Sts2.Core.Rewards.RewardsSet.System.Threading.Tasks.Task Offer()
 0102: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0107: stloc.s 4
 0109: ldloca.s 4
 0111: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0116: brtrue.s 180
 0118: ldarg.0 
 0119: ldc.i4.0 
 0120: dup 
 0121: stloc.0 
 0122: stfld field:Int32 <>1__state
 0127: ldarg.0 
 0128: ldloc.s 4
 0130: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0135: ldarg.0 
 0136: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0141: ldloca.s 4
 0143: ldarg.0 
 0144: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<OfferForRoomEnd>d__0](System.Runtime.CompilerServices.TaskAwaiter ByRef, <OfferForRoomEnd>d__0 ByRef)
 0149: leave.s 233
 0151: ldarg.0 
 0152: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0157: stloc.s 4
 0159: ldarg.0 
 0160: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0165: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0171: ldarg.0 
 0172: ldc.i4.m1 
 0173: dup 
 0174: stloc.0 
 0175: stfld field:Int32 <>1__state
 0180: ldloca.s 4
 0182: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0187: leave.s 214
 0189: stloc.s 5
 0191: ldarg.0 
 0192: ldc.i4.s -2
 0194: stfld field:Int32 <>1__state
 0199: ldarg.0 
 0200: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0205: ldloc.s 5
 0207: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
