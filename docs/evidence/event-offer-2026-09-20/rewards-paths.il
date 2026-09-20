METHOD MegaCrit.Sts2.Core.Rewards.RewardsSet WithCustomRewards(System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward])
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward] get_Rewards()
 0006: ldarg.1 
 0007: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward].Void AddRange(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Rewards.Reward])
 0012: ldarg.0 
 0013: ret 
METHOD MegaCrit.Sts2.Core.Rewards.RewardsSet EmptyForRoom(MegaCrit.Sts2.Core.Rooms.AbstractRoom)
 0000: ldarg.0 
 0001: ldarg.1 
 0002: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.Void set_Room(MegaCrit.Sts2.Core.Rooms.AbstractRoom)
 0007: ldarg.0 
 0008: ldc.i4.1 
 0009: stfld field:Boolean _allowEmptyRewards
 0014: ldarg.0 
 0015: ret 
METHOD MegaCrit.Sts2.Core.Rewards.RewardsSet WithRewardsFromRoom(MegaCrit.Sts2.Core.Rooms.AbstractRoom)
 0000: ldarg.0 
 0001: ldarg.1 
 0002: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.Void set_Room(MegaCrit.Sts2.Core.Rooms.AbstractRoom)
 0007: ldarg.1 
 0008: callvirt method:MegaCrit.Sts2.Core.Rooms.AbstractRoom.MegaCrit.Sts2.Core.Rooms.RoomType get_RoomType()
 0013: ldc.i4.3 
 0014: bne.un.s 59
 0016: ldarg.0 
 0017: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0022: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0027: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.Int32 get_CurrentActIndex()
 0032: ldarg.0 
 0033: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0038: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0043: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.ActModel] get_Acts()
 0048: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Models.ActModel].Int32 get_Count()
 0053: ldc.i4.1 
 0054: sub 
 0055: blt.s 59
 0057: ldarg.0 
 0058: ret 
 0059: ldarg.0 
 0060: ldarg.0 
 0061: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0066: ldarg.1 
 0067: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.Boolean TryGenerateTutorialRewards(MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.Rooms.AbstractRoom)
 0072: stloc.0 
 0073: ldloc.0 
 0074: brtrue.s 100
 0076: ldarg.0 
 0077: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward] get_Rewards()
 0082: ldarg.0 
 0083: ldarg.0 
 0084: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0089: ldarg.1 
 0090: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward] GenerateRewardsFor(MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.Rooms.AbstractRoom)
 0095: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward].Void AddRange(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Rewards.Reward])
 0100: ldarg.0 
 0101: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Rooms.AbstractRoom get_Room()
 0106: isinst type:MegaCrit.Sts2.Core.Rooms.CombatRoom
 0111: stloc.1 
 0112: ldloc.1 
 0113: brfalse.s 148
 0115: ldloc.1 
 0116: callvirt method:MegaCrit.Sts2.Core.Rooms.CombatRoom.System.Collections.Generic.IReadOnlyDictionary`2[MegaCrit.Sts2.Core.Entities.Players.Player,System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward]] get_ExtraRewards()
 0121: ldarg.0 
 0122: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0127: ldloca.s 2
 0129: callvirt method:System.Collections.Generic.IReadOnlyDictionary`2[MegaCrit.Sts2.Core.Entities.Players.Player,System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward]].Boolean TryGetValue(MegaCrit.Sts2.Core.Entities.Players.Player, System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward] ByRef)
 0134: brfalse.s 148
 0136: ldarg.0 
 0137: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward] get_Rewards()
 0142: ldloc.2 
 0143: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward].Void AddRange(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Rewards.Reward])
 0148: ldarg.0 
 0149: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Rewards.RewardsSet <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: switch switch 4
 0036: ldloc.1 
 0037: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0042: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Entities.Creatures.Creature get_Creature()
 0047: callvirt method:MegaCrit.Sts2.Core.Entities.Creatures.Creature.Boolean get_IsDead()
 0052: brfalse.s 59
 0054: leave 819
 0059: ldloc.1 
 0060: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.System.Threading.Tasks.Task GenerateWithoutOffering()
 0065: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0070: stloc.s 4
 0072: ldloca.s 4
 0074: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0079: brtrue.s 146
 0081: ldarg.0 
 0082: ldc.i4.0 
 0083: dup 
 0084: stloc.0 
 0085: stfld field:Int32 <>1__state
 0090: ldarg.0 
 0091: ldloc.s 4
 0093: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0098: ldarg.0 
 0099: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0104: ldloca.s 4
 0106: ldarg.0 
 0107: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<Offer>d__33](System.Runtime.CompilerServices.TaskAwaiter ByRef, <Offer>d__33 ByRef)
 0112: leave 845
 0117: ldarg.0 
 0118: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0123: stloc.s 4
 0125: ldarg.0 
 0126: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0131: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0137: ldarg.0 
 0138: ldc.i4.m1 
 0139: dup 
 0140: stloc.0 
 0141: stfld field:Int32 <>1__state
 0146: ldloca.s 4
 0148: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0153: ldloc.1 
 0154: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Rooms.AbstractRoom get_Room()
 0159: isinst type:MegaCrit.Sts2.Core.Rooms.CombatRoom
 0164: ldnull 
 0165: cgt.un 
 0167: stloc.2 
 0168: ldarg.0 
 0169: ldloc.1 
 0170: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer _synchronizer
 0175: ldloc.1 
 0176: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer.System.Threading.Tasks.Task BeginRewardsSet(MegaCrit.Sts2.Core.Rewards.RewardsSet)
 0181: stfld field:System.Threading.Tasks.Task <task>5__2
 0186: ldloc.1 
 0187: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward] get_Rewards()
 0192: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward].Int32 get_Count()
 0197: ldc.i4.0 
 0198: bgt.s 216
 0200: ldloc.2 
 0201: brtrue.s 216
 0203: ldloc.1 
 0204: ldfld field:Boolean _allowEmptyRewards
 0209: brtrue.s 216
 0211: leave 819
 0216: ldloc.1 
 0217: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward] get_Rewards()
 0222: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Rewards.Reward,System.Boolean] <>9__33_0
 0227: dup 
 0228: brtrue.s 253
 0230: pop 
 0231: ldsfld field:<>c <>9
 0236: ldftn method:MegaCrit.Sts2.Core.Rewards.RewardsSet+<>c.Boolean <Offer>b__33_0(MegaCrit.Sts2.Core.Rewards.Reward)
 0242: newobj method:System.Func`2[MegaCrit.Sts2.Core.Rewards.Reward,System.Boolean].Void .ctor(System.Object, IntPtr)
 0247: dup 
 0248: stsfld field:System.Func`2[MegaCrit.Sts2.Core.Rewards.Reward,System.Boolean] <>9__33_0
 0253: call method:System.Linq.Enumerable.Boolean All[Reward](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Rewards.Reward], System.Func`2[MegaCrit.Sts2.Core.Rewards.Reward,System.Boolean])
 0258: stloc.3 
 0259: ldloc.3 
 0260: brtrue.s 317
 0262: ldloc.1 
 0263: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward] get_Rewards()
 0268: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Rewards.Reward,System.Boolean] <>9__33_1
 0273: dup 
 0274: brtrue.s 299
 0276: pop 
 0277: ldsfld field:<>c <>9
 0282: ldftn method:MegaCrit.Sts2.Core.Rewards.RewardsSet+<>c.Boolean <Offer>b__33_1(MegaCrit.Sts2.Core.Rewards.Reward)
 0288: newobj method:System.Func`2[MegaCrit.Sts2.Core.Rewards.Reward,System.Boolean].Void .ctor(System.Object, IntPtr)
 0293: dup 
 0294: stsfld field:System.Func`2[MegaCrit.Sts2.Core.Rewards.Reward,System.Boolean] <>9__33_1
 0299: call method:System.Linq.Enumerable.Boolean Any[Reward](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Rewards.Reward], System.Func`2[MegaCrit.Sts2.Core.Rewards.Reward,System.Boolean])
 0304: brfalse.s 317
 0306: ldstr str:Some rewards are populated and others are not when calling RewardsCmd.Offer! This might lead to hooks getting called twice
 0311: ldc.i4.2 
 0312: call method:MegaCrit.Sts2.Core.Logging.Log.Void Warn(System.String, Int32)
 0317: ldloc.1 
 0318: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0323: call method:MegaCrit.Sts2.Core.Context.LocalContext.Boolean IsMe(MegaCrit.Sts2.Core.Entities.Players.Player)
 0328: brfalse 694
 0333: call method:MegaCrit.Sts2.Core.TestSupport.TestMode.Boolean get_IsOn()
 0338: brfalse 675
 0343: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Rewards.RewardsSet,System.Threading.Tasks.Task] testSelector
 0348: brfalse.s 454
 0350: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Rewards.RewardsSet,System.Threading.Tasks.Task] testSelector
 0355: ldloc.1 
 0356: callvirt method:System.Func`2[MegaCrit.Sts2.Core.Rewards.RewardsSet,System.Threading.Tasks.Task].System.Threading.Tasks.Task Invoke(MegaCrit.Sts2.Core.Rewards.RewardsSet)
 0361: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0366: stloc.s 5
 0368: ldloca.s 5
 0370: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0375: brtrue.s 442
 0377: ldarg.0 
 0378: ldc.i4.1 
 0379: dup 
 0380: stloc.0 
 0381: stfld field:Int32 <>1__state
 0386: ldarg.0 
 0387: ldloc.s 5
 0389: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0394: ldarg.0 
 0395: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0400: ldloca.s 5
 0402: ldarg.0 
 0403: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<Offer>d__33](System.Runtime.CompilerServices.TaskAwaiter ByRef, <Offer>d__33 ByRef)
 0408: leave 845
 0413: ldarg.0 
 0414: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0419: stloc.s 5
 0421: ldarg.0 
 0422: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0427: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0433: ldarg.0 
 0434: ldc.i4.m1 
 0435: dup 
 0436: stloc.0 
 0437: stfld field:Int32 <>1__state
 0442: ldloca.s 5
 0444: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0449: br 642
 0454: ldarg.0 
 0455: ldloc.1 
 0456: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward] get_Rewards()
 0461: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward].Enumerator GetEnumerator()
 0466: stfld field:Enumerator <>7__wrap2
 0471: nop 
 0472: ldloc.0 
 0473: ldc.i4.2 
 0474: beq.s 556
 0476: br.s 593
 0478: ldarg.0 
 0479: ldflda field:Enumerator <>7__wrap2
 0484: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Rewards.Reward].MegaCrit.Sts2.Core.Rewards.Reward get_Current()
 0489: stloc.s 6
 0491: ldloc.1 
 0492: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer _synchronizer
 0497: ldloc.s 6
 0499: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer.System.Threading.Tasks.Task`1[System.Boolean] SelectLocalReward(MegaCrit.Sts2.Core.Rewards.Reward)
 0504: callvirt method:System.Threading.Tasks.Task`1[System.Boolean].System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] GetAwaiter()
 0509: stloc.s 7
 0511: ldloca.s 7
 0513: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean].Boolean get_IsCompleted()
 0518: brtrue.s 585
 0520: ldarg.0 
 0521: ldc.i4.2 
 0522: dup 
 0523: stloc.0 
 0524: stfld field:Int32 <>1__state
 0529: ldarg.0 
 0530: ldloc.s 7
 0532: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__2
 0537: ldarg.0 
 0538: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0543: ldloca.s 7
 0545: ldarg.0 
 0546: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<Offer>d__33](System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] ByRef, <Offer>d__33 ByRef)
 0551: leave 845
 0556: ldarg.0 
 0557: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__2
 0562: stloc.s 7
 0564: ldarg.0 
 0565: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__2
 0570: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean]
 0576: ldarg.0 
 0577: ldc.i4.m1 
 0578: dup 
 0579: stloc.0 
 0580: stfld field:Int32 <>1__state
 0585: ldloca.s 7
 0587: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean].Boolean GetResult()
 0592: pop 
 0593: ldarg.0 
 0594: ldflda field:Enumerator <>7__wrap2
 0599: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Rewards.Reward].Boolean MoveNext()
 0604: brtrue.s 478
 0606: leave.s 630
 0608: ldloc.0 
 0609: ldc.i4.0 
 0610: bge.s 629
 0612: ldarg.0 
 0613: ldflda field:Enumerator <>7__wrap2
 0618: constrained. type:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Rewards.Reward]
 0624: callvirt method:System.IDisposable.Void Dispose()
 0629: endfinally 
 0630: ldarg.0 
 0631: ldflda field:Enumerator <>7__wrap2
 0636: initobj type:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Rewards.Reward]
 0642: ldloc.1 
 0643: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer _synchronizer
 0648: ldloc.1 
 0649: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer.Boolean IsRewardsSetCompleted(MegaCrit.Sts2.Core.Rewards.RewardsSet)
 0654: brtrue.s 694
 0656: ldloc.1 
 0657: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.Boolean get_ThrowInTestIfRewardsNotTaken()
 0662: brfalse.s 694
 0664: ldstr str:The RewardsSet is not complete after rewards were selected!
 0669: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0674: throw 
 0675: ldloc.1 
 0676: ldloc.2 
 0677: ldloc.1 
 0678: call method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0683: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0688: call method:MegaCrit.Sts2.Core.Nodes.Screens.NRewardsScreen.MegaCrit.Sts2.Core.Nodes.Screens.NRewardsScreen ShowScreen(MegaCrit.Sts2.Core.Rewards.RewardsSet, Boolean, MegaCrit.Sts2.Core.Runs.IRunState)
 0693: pop 
 0694: ldarg.0 
 0695: ldfld field:System.Threading.Tasks.Task <task>5__2
 0700: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0705: stloc.s 8
 0707: ldloca.s 8
 0709: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0714: brtrue.s 778
 0716: ldarg.0 
 0717: ldc.i4.3 
 0718: dup 
 0719: stloc.0 
 0720: stfld field:Int32 <>1__state
 0725: ldarg.0 
 0726: ldloc.s 8
 0728: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0733: ldarg.0 
 0734: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0739: ldloca.s 8
 0741: ldarg.0 
 0742: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<Offer>d__33](System.Runtime.CompilerServices.TaskAwaiter ByRef, <Offer>d__33 ByRef)
 0747: leave.s 845
 0749: ldarg.0 
 0750: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0755: stloc.s 8
 0757: ldarg.0 
 0758: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0763: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0769: ldarg.0 
 0770: ldc.i4.m1 
 0771: dup 
 0772: stloc.0 
 0773: stfld field:Int32 <>1__state
 0778: ldloca.s 8
 0780: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0785: leave.s 819
 0787: stloc.s 9
 0789: ldarg.0 
 0790: ldc.i4.s -2
 0792: stfld field:Int32 <>1__state
 0797: ldarg.0 
 0798: ldnull 
 0799: stfld field:System.Threading.Tasks.Task <task>5__2
 0804: ldarg.0 
 0805: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0810: ldloc.s 9
 0812: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0817: leave.s 845
 0819: ldarg.0 
 0820: ldc.i4.s -2
 0822: stfld field:Int32 <>1__state
 0827: ldarg.0 
 0828: ldnull 
 0829: stfld field:System.Threading.Tasks.Task <task>5__2
 0834: ldarg.0 
 0835: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0840: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0845: ret 
