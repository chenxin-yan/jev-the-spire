METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: switch switch 8
 0052: ldloc.1 
 0053: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder] _holdersInUse
 0058: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder].Enumerator GetEnumerator()
 0063: stloc.3 
 0064: br.s 82
 0066: ldloca.s 3
 0068: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder].MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder get_Current()
 0073: stloc.s 4
 0075: ldloc.s 4
 0077: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Disable()
 0082: ldloca.s 3
 0084: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder].Boolean MoveNext()
 0089: brtrue.s 66
 0091: leave.s 111
 0093: ldloc.0 
 0094: ldc.i4.0 
 0095: bge.s 110
 0097: ldloca.s 3
 0099: constrained. type:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder]
 0105: callvirt method:System.IDisposable.Void Dispose()
 0110: endfinally 
 0111: ldloc.1 
 0112: ldfld field:System.Threading.Tasks.TaskCompletionSource _relicPickingBeganTaskCompletionSource
 0117: callvirt method:System.Threading.Tasks.TaskCompletionSource.Void SetResult()
 0122: ldloc.1 
 0123: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0128: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0133: callvirt method:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Players.Player].System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Entities.Players.Player] GetEnumerator()
 0138: stloc.s 5
 0140: br.s 222
 0142: ldloc.s 5
 0144: callvirt method:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Entities.Players.Player].MegaCrit.Sts2.Core.Entities.Players.Player get_Current()
 0149: stloc.s 6
 0151: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0156: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer get_TreasureRoomRelicSynchronizer()
 0161: ldloc.s 6
 0163: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.PlayerVote GetPlayerVote(MegaCrit.Sts2.Core.Entities.Players.Player)
 0168: stloc.s 7
 0170: ldloc.s 7
 0172: ldfld field:Boolean voteReceived
 0177: brfalse.s 222
 0179: ldloc.s 7
 0181: ldflda field:System.Nullable`1[System.Int32] index
 0186: call method:System.Nullable`1[System.Int32].Boolean get_HasValue()
 0191: brtrue.s 222
 0193: ldloc.1 
 0194: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImageCollection _hands
 0199: ldloc.s 6
 0201: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0206: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImageCollection.MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImage GetHand(UInt64)
 0211: dup 
 0212: brtrue.s 217
 0214: pop 
 0215: br.s 222
 0217: call method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImage.Void SetSkipped()
 0222: ldloc.s 5
 0224: callvirt method:System.Collections.IEnumerator.Boolean MoveNext()
 0229: brtrue.s 142
 0231: leave.s 249
 0233: ldloc.0 
 0234: ldc.i4.0 
 0235: bge.s 248
 0237: ldloc.s 5
 0239: brfalse.s 248
 0241: ldloc.s 5
 0243: callvirt method:System.IDisposable.Void Dispose()
 0248: endfinally 
 0249: ldloc.1 
 0250: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImageCollection _hands
 0255: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImageCollection.Void BeforeRelicsAwarded()
 0260: ldarg.0 
 0261: newobj method:System.Collections.Generic.List`1[System.Threading.Tasks.Task].Void .ctor()
 0266: stfld field:System.Collections.Generic.List`1[System.Threading.Tasks.Task] <tasksToWait>5__2
 0271: ldloca.s 2
 0273: initobj type:System.Nullable`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResultType]
 0279: ldarg.0 
 0280: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult] results
 0285: ldsfld field:System.Comparison`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult] <>9__31_0
 0290: dup 
 0291: brtrue.s 316
 0293: pop 
 0294: ldsfld field:<>c <>9
 0299: ldftn method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection+<>c.Int32 <AnimateRelicAwards>b__31_0(MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult, MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult)
 0305: newobj method:System.Comparison`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult].Void .ctor(System.Object, IntPtr)
 0310: dup 
 0311: stsfld field:System.Comparison`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult] <>9__31_0
 0316: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult].Void Sort(System.Comparison`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult])
 0321: ldarg.0 
 0322: ldarg.0 
 0323: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult] results
 0328: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult].Enumerator GetEnumerator()
 0333: stfld field:Enumerator <>7__wrap2
 0338: nop 
 0339: ldloc.0 
 0340: switch switch 6
 0369: br 1617
 0374: ldarg.0 
 0375: newobj method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection+<>c__DisplayClass31_0.Void .ctor()
 0380: stfld field:<>c__DisplayClass31_0 <>8__1
 0385: ldarg.0 
 0386: ldfld field:<>c__DisplayClass31_0 <>8__1
 0391: ldarg.0 
 0392: ldflda field:Enumerator <>7__wrap2
 0397: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult].MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult get_Current()
 0402: stfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 0407: ldarg.0 
 0408: ldloc.1 
 0409: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder] _holdersInUse
 0414: ldarg.0 
 0415: ldfld field:<>c__DisplayClass31_0 <>8__1
 0420: ldftn method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection+<>c__DisplayClass31_0.Boolean <AnimateRelicAwards>b__1(MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder)
 0426: newobj method:System.Func`2[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder,System.Boolean].Void .ctor(System.Object, IntPtr)
 0431: call method:System.Linq.Enumerable.MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder First[NTreasureRoomRelicHolder](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder], System.Func`2[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder,System.Boolean])
 0436: stfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder <holder>5__4
 0441: ldarg.0 
 0442: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder <holder>5__4
 0447: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder.Void AnimateAwayVotes()
 0452: ldloca.s 2
 0454: call method:System.Nullable`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResultType].Boolean get_HasValue()
 0459: brfalse 612
 0464: ldarg.0 
 0465: ldfld field:<>c__DisplayClass31_0 <>8__1
 0470: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 0475: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResultType type
 0480: ldloc.2 
 0481: stloc.s 8
 0483: ldloca.s 8
 0485: call method:System.Nullable`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResultType].MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResultType GetValueOrDefault()
 0490: ceq 
 0492: ldloca.s 8
 0494: call method:System.Nullable`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResultType].Boolean get_HasValue()
 0499: and 
 0500: brtrue.s 612
 0502: ldc.r4 0.5
 0507: ldloc.1 
 0508: ldfld field:System.Threading.CancellationTokenSource _cts
 0513: callvirt method:System.Threading.CancellationTokenSource.System.Threading.CancellationToken get_Token()
 0518: ldc.i4.0 
 0519: call method:MegaCrit.Sts2.Core.Commands.Cmd.System.Threading.Tasks.Task Wait(Single, System.Threading.CancellationToken, Boolean)
 0524: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0529: stloc.s 9
 0531: ldloca.s 9
 0533: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0538: brtrue.s 605
 0540: ldarg.0 
 0541: ldc.i4.0 
 0542: dup 
 0543: stloc.0 
 0544: stfld field:Int32 <>1__state
 0549: ldarg.0 
 0550: ldloc.s 9
 0552: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0557: ldarg.0 
 0558: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0563: ldloca.s 9
 0565: ldarg.0 
 0566: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<AnimateRelicAwards>d__31](System.Runtime.CompilerServices.TaskAwaiter ByRef, <AnimateRelicAwards>d__31 ByRef)
 0571: leave 2329
 0576: ldarg.0 
 0577: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0582: stloc.s 9
 0584: ldarg.0 
 0585: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0590: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0596: ldarg.0 
 0597: ldc.i4.m1 
 0598: dup 
 0599: stloc.0 
 0600: stfld field:Int32 <>1__state
 0605: ldloca.s 9
 0607: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0612: ldarg.0 
 0613: ldfld field:<>c__DisplayClass31_0 <>8__1
 0618: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 0623: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResultType type
 0628: ldc.i4.1 
 0629: bne.un 1379
 0634: ldloc.1 
 0635: ldfld field:Godot.Control _fightBackstop
 0640: callvirt method:Godot.Node.Godot.Node GetParent()
 0645: stloc.s 10
 0647: ldarg.0 
 0648: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder <holder>5__4
 0653: ldloc.s 10
 0655: ldc.i4.1 
 0656: callvirt method:Godot.Node.Void Reparent(Godot.Node, Boolean)
 0661: ldloc.s 10
 0663: ldarg.0 
 0664: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder <holder>5__4
 0669: ldloc.1 
 0670: ldfld field:Godot.Control _fightBackstop
 0675: ldc.i4.0 
 0676: callvirt method:Godot.Node.Int32 GetIndex(Boolean)
 0681: ldc.i4.1 
 0682: add 
 0683: call method:MegaCrit.Sts2.Core.Helpers.GodotTreeExtensions.Void MoveChildSafely(Godot.Node, Godot.Node, Int32)
 0688: ldloc.1 
 0689: ldfld field:Godot.Control _fightBackstop
 0694: ldc.i4.1 
 0695: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0700: ldloc.1 
 0701: call method:Godot.Node.Godot.Tween CreateTween()
 0706: stloc.s 11
 0708: ldloc.s 11
 0710: ldarg.0 
 0711: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder <holder>5__4
 0716: ldstr str:global_position
 0721: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0726: ldloc.1 
 0727: ldfld field:Godot.Control _fightBackstop
 0732: callvirt method:Godot.Control.Godot.Vector2 get_Size()
 0737: ldarg.0 
 0738: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder <holder>5__4
 0743: callvirt method:Godot.Control.Godot.Vector2 get_Size()
 0748: call method:Godot.Vector2.Godot.Vector2 op_Subtraction(Godot.Vector2, Godot.Vector2)
 0753: ldc.r4 0.5
 0758: call method:Godot.Vector2.Godot.Vector2 op_Multiply(Godot.Vector2, Single)
 0763: call method:Godot.Variant.Godot.Variant op_Implicit(Godot.Vector2)
 0768: ldc.r8 0.25
 0777: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 0782: ldc.i4.s 10
 0784: conv.i8 
 0785: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetTrans(TransitionType)
 0790: ldc.i4.0 
 0791: conv.i8 
 0792: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetEase(EaseType)
 0797: pop 
 0798: ldloc.s 11
 0800: ldloc.1 
 0801: ldfld field:Godot.Control _fightBackstop
 0806: ldstr str:modulate:a
 0811: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0816: ldc.r4 1
 0821: call method:Godot.Variant.Godot.Variant op_Implicit(Single)
 0826: ldc.r8 0.25
 0835: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 0840: pop 
 0841: ldloc.1 
 0842: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImageCollection _hands
 0847: ldarg.0 
 0848: ldfld field:<>c__DisplayClass31_0 <>8__1
 0853: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 0858: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingFight fight
 0863: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Players.Player] playersInvolved
 0868: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImageCollection.Void BeforeFightStarted(System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Players.Player])
 0873: ldloc.s 11
 0875: ldloc.1 
 0876: ldfld field:System.Threading.CancellationTokenSource _cts
 0881: callvirt method:System.Threading.CancellationTokenSource.System.Threading.CancellationToken get_Token()
 0886: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.TweenHelper.System.Threading.Tasks.Task AwaitFinished(Godot.Tween, System.Threading.CancellationToken)
 0891: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0896: stloc.s 12
 0898: ldloca.s 12
 0900: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0905: brtrue.s 972
 0907: ldarg.0 
 0908: ldc.i4.1 
 0909: dup 
 0910: stloc.0 
 0911: stfld field:Int32 <>1__state
 0916: ldarg.0 
 0917: ldloc.s 12
 0919: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0924: ldarg.0 
 0925: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0930: ldloca.s 12
 0932: ldarg.0 
 0933: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<AnimateRelicAwards>d__31](System.Runtime.CompilerServices.TaskAwaiter ByRef, <AnimateRelicAwards>d__31 ByRef)
 0938: leave 2329
 0943: ldarg.0 
 0944: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0949: stloc.s 12
 0951: ldarg.0 
 0952: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0957: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0963: ldarg.0 
 0964: ldc.i4.m1 
 0965: dup 
 0966: stloc.0 
 0967: stfld field:Int32 <>1__state
 0972: ldloca.s 12
 0974: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0979: ldc.r4 1
 0984: ldloc.1 
 0985: ldfld field:System.Threading.CancellationTokenSource _cts
 0990: callvirt method:System.Threading.CancellationTokenSource.System.Threading.CancellationToken get_Token()
 0995: ldc.i4.0 
 0996: call method:MegaCrit.Sts2.Core.Commands.Cmd.System.Threading.Tasks.Task Wait(Single, System.Threading.CancellationToken, Boolean)
 1001: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 1006: stloc.s 13
 1008: ldloca.s 13
 1010: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 1015: brtrue.s 1082
 1017: ldarg.0 
 1018: ldc.i4.2 
 1019: dup 
 1020: stloc.0 
 1021: stfld field:Int32 <>1__state
 1026: ldarg.0 
 1027: ldloc.s 13
 1029: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1034: ldarg.0 
 1035: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 1040: ldloca.s 13
 1042: ldarg.0 
 1043: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<AnimateRelicAwards>d__31](System.Runtime.CompilerServices.TaskAwaiter ByRef, <AnimateRelicAwards>d__31 ByRef)
 1048: leave 2329
 1053: ldarg.0 
 1054: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1059: stloc.s 13
 1061: ldarg.0 
 1062: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1067: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 1073: ldarg.0 
 1074: ldc.i4.m1 
 1075: dup 
 1076: stloc.0 
 1077: stfld field:Int32 <>1__state
 1082: ldloca.s 13
 1084: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 1089: ldloc.1 
 1090: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImageCollection _hands
 1095: ldarg.0 
 1096: ldfld field:<>c__DisplayClass31_0 <>8__1
 1101: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 1106: ldarg.0 
 1107: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder <holder>5__4
 1112: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImageCollection.System.Threading.Tasks.Task DoFight(MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult, MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder)
 1117: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 1122: stloc.s 14
 1124: ldloca.s 14
 1126: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 1131: brtrue.s 1198
 1133: ldarg.0 
 1134: ldc.i4.3 
 1135: dup 
 1136: stloc.0 
 1137: stfld field:Int32 <>1__state
 1142: ldarg.0 
 1143: ldloc.s 14
 1145: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1150: ldarg.0 
 1151: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 1156: ldloca.s 14
 1158: ldarg.0 
 1159: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<AnimateRelicAwards>d__31](System.Runtime.CompilerServices.TaskAwaiter ByRef, <AnimateRelicAwards>d__31 ByRef)
 1164: leave 2329
 1169: ldarg.0 
 1170: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1175: stloc.s 14
 1177: ldarg.0 
 1178: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1183: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 1189: ldarg.0 
 1190: ldc.i4.m1 
 1191: dup 
 1192: stloc.0 
 1193: stfld field:Int32 <>1__state
 1198: ldloca.s 14
 1200: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 1205: ldloc.1 
 1206: call method:Godot.Node.Godot.Tween CreateTween()
 1211: stloc.s 11
 1213: ldloc.s 11
 1215: ldloc.1 
 1216: ldfld field:Godot.Control _fightBackstop
 1221: ldstr str:modulate:a
 1226: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 1231: ldc.r4 0
 1236: call method:Godot.Variant.Godot.Variant op_Implicit(Single)
 1241: ldc.r8 0.25
 1250: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 1255: pop 
 1256: ldloc.s 11
 1258: ldloc.1 
 1259: ldfld field:System.Threading.CancellationTokenSource _cts
 1264: callvirt method:System.Threading.CancellationTokenSource.System.Threading.CancellationToken get_Token()
 1269: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.TweenHelper.System.Threading.Tasks.Task AwaitFinished(Godot.Tween, System.Threading.CancellationToken)
 1274: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 1279: stloc.s 15
 1281: ldloca.s 15
 1283: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 1288: brtrue.s 1355
 1290: ldarg.0 
 1291: ldc.i4.4 
 1292: dup 
 1293: stloc.0 
 1294: stfld field:Int32 <>1__state
 1299: ldarg.0 
 1300: ldloc.s 15
 1302: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1307: ldarg.0 
 1308: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 1313: ldloca.s 15
 1315: ldarg.0 
 1316: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<AnimateRelicAwards>d__31](System.Runtime.CompilerServices.TaskAwaiter ByRef, <AnimateRelicAwards>d__31 ByRef)
 1321: leave 2329
 1326: ldarg.0 
 1327: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1332: stloc.s 15
 1334: ldarg.0 
 1335: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1340: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 1346: ldarg.0 
 1347: ldc.i4.m1 
 1348: dup 
 1349: stloc.0 
 1350: stfld field:Int32 <>1__state
 1355: ldloca.s 15
 1357: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 1362: ldloc.1 
 1363: ldfld field:Godot.Control _fightBackstop
 1368: ldc.i4.0 
 1369: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 1374: br 1581
 1379: ldarg.0 
 1380: ldfld field:<>c__DisplayClass31_0 <>8__1
 1385: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 1390: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResultType type
 1395: ldc.i4.3 
 1396: beq 1581
 1401: ldloc.1 
 1402: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImageCollection _hands
 1407: ldarg.0 
 1408: ldfld field:<>c__DisplayClass31_0 <>8__1
 1413: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 1418: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 1423: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 1428: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImageCollection.MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImage GetHand(UInt64)
 1433: stloc.s 16
 1435: ldloc.s 16
 1437: brfalse 1581
 1442: ldarg.0 
 1443: ldfld field:System.Collections.Generic.List`1[System.Threading.Tasks.Task] <tasksToWait>5__2
 1448: ldloc.s 16
 1450: ldarg.0 
 1451: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder <holder>5__4
 1456: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NHandImage.System.Threading.Tasks.Task GrabRelic(MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder)
 1461: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 1466: callvirt method:System.Collections.Generic.List`1[System.Threading.Tasks.Task].Void Add(System.Threading.Tasks.Task)
 1471: ldc.r4 0.25
 1476: ldloc.1 
 1477: ldfld field:System.Threading.CancellationTokenSource _cts
 1482: callvirt method:System.Threading.CancellationTokenSource.System.Threading.CancellationToken get_Token()
 1487: ldc.i4.0 
 1488: call method:MegaCrit.Sts2.Core.Commands.Cmd.System.Threading.Tasks.Task Wait(Single, System.Threading.CancellationToken, Boolean)
 1493: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 1498: stloc.s 17
 1500: ldloca.s 17
 1502: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 1507: brtrue.s 1574
 1509: ldarg.0 
 1510: ldc.i4.5 
 1511: dup 
 1512: stloc.0 
 1513: stfld field:Int32 <>1__state
 1518: ldarg.0 
 1519: ldloc.s 17
 1521: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1526: ldarg.0 
 1527: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 1532: ldloca.s 17
 1534: ldarg.0 
 1535: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<AnimateRelicAwards>d__31](System.Runtime.CompilerServices.TaskAwaiter ByRef, <AnimateRelicAwards>d__31 ByRef)
 1540: leave 2329
 1545: ldarg.0 
 1546: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1551: stloc.s 17
 1553: ldarg.0 
 1554: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1559: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 1565: ldarg.0 
 1566: ldc.i4.m1 
 1567: dup 
 1568: stloc.0 
 1569: stfld field:Int32 <>1__state
 1574: ldloca.s 17
 1576: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 1581: ldarg.0 
 1582: ldfld field:<>c__DisplayClass31_0 <>8__1
 1587: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 1592: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResultType type
 1597: newobj method:System.Nullable`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResultType].Void .ctor(MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResultType)
 1602: stloc.2 
 1603: ldarg.0 
 1604: ldnull 
 1605: stfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder <holder>5__4
 1610: ldarg.0 
 1611: ldnull 
 1612: stfld field:<>c__DisplayClass31_0 <>8__1
 1617: ldarg.0 
 1618: ldflda field:Enumerator <>7__wrap2
 1623: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult].Boolean MoveNext()
 1628: brtrue 374
 1633: leave.s 1657
 1635: ldloc.0 
 1636: ldc.i4.0 
 1637: bge.s 1656
 1639: ldarg.0 
 1640: ldflda field:Enumerator <>7__wrap2
 1645: constrained. type:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult]
 1651: callvirt method:System.IDisposable.Void Dispose()
 1656: endfinally 
 1657: ldarg.0 
 1658: ldflda field:Enumerator <>7__wrap2
 1663: initobj type:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult]
 1669: ldarg.0 
 1670: ldfld field:System.Collections.Generic.List`1[System.Threading.Tasks.Task] <tasksToWait>5__2
 1675: call method:System.Threading.Tasks.Task.System.Threading.Tasks.Task WhenAll(System.Collections.Generic.IEnumerable`1[System.Threading.Tasks.Task])
 1680: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 1685: stloc.s 18
 1687: ldloca.s 18
 1689: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 1694: brtrue.s 1761
 1696: ldarg.0 
 1697: ldc.i4.6 
 1698: dup 
 1699: stloc.0 
 1700: stfld field:Int32 <>1__state
 1705: ldarg.0 
 1706: ldloc.s 18
 1708: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1713: ldarg.0 
 1714: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 1719: ldloca.s 18
 1721: ldarg.0 
 1722: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<AnimateRelicAwards>d__31](System.Runtime.CompilerServices.TaskAwaiter ByRef, <AnimateRelicAwards>d__31 ByRef)
 1727: leave 2329
 1732: ldarg.0 
 1733: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1738: stloc.s 18
 1740: ldarg.0 
 1741: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1746: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 1752: ldarg.0 
 1753: ldc.i4.m1 
 1754: dup 
 1755: stloc.0 
 1756: stfld field:Int32 <>1__state
 1761: ldloca.s 18
 1763: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 1768: ldarg.0 
 1769: ldfld field:System.Collections.Generic.List`1[System.Threading.Tasks.Task] <tasksToWait>5__2
 1774: callvirt method:System.Collections.Generic.List`1[System.Threading.Tasks.Task].Int32 get_Count()
 1779: brtrue 1913
 1784: ldloc.1 
 1785: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 1790: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 1795: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Entities.Players.Player].Int32 get_Count()
 1800: ldc.i4.1 
 1801: ble.s 1913
 1803: ldc.r4 0.7
 1808: ldloc.1 
 1809: ldfld field:System.Threading.CancellationTokenSource _cts
 1814: callvirt method:System.Threading.CancellationTokenSource.System.Threading.CancellationToken get_Token()
 1819: ldc.i4.0 
 1820: call method:MegaCrit.Sts2.Core.Commands.Cmd.System.Threading.Tasks.Task Wait(Single, System.Threading.CancellationToken, Boolean)
 1825: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 1830: stloc.s 19
 1832: ldloca.s 19
 1834: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 1839: brtrue.s 1906
 1841: ldarg.0 
 1842: ldc.i4.7 
 1843: dup 
 1844: stloc.0 
 1845: stfld field:Int32 <>1__state
 1850: ldarg.0 
 1851: ldloc.s 19
 1853: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1858: ldarg.0 
 1859: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 1864: ldloca.s 19
 1866: ldarg.0 
 1867: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<AnimateRelicAwards>d__31](System.Runtime.CompilerServices.TaskAwaiter ByRef, <AnimateRelicAwards>d__31 ByRef)
 1872: leave 2329
 1877: ldarg.0 
 1878: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1883: stloc.s 19
 1885: ldarg.0 
 1886: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1891: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 1897: ldarg.0 
 1898: ldc.i4.m1 
 1899: dup 
 1900: stloc.0 
 1901: stfld field:Int32 <>1__state
 1906: ldloca.s 19
 1908: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 1913: ldarg.0 
 1914: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult] results
 1919: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult].Enumerator GetEnumerator()
 1924: stloc.s 20
 1926: br 2226
 1931: newobj method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection+<>c__DisplayClass31_1.Void .ctor()
 1936: stloc.s 21
 1938: ldloc.s 21
 1940: ldloca.s 20
 1942: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult].MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult get_Current()
 1947: stfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 1952: ldloc.1 
 1953: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder] _holdersInUse
 1958: ldloc.s 21
 1960: ldftn method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection+<>c__DisplayClass31_1.Boolean <AnimateRelicAwards>b__2(MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder)
 1966: newobj method:System.Func`2[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder,System.Boolean].Void .ctor(System.Object, IntPtr)
 1971: call method:System.Linq.Enumerable.MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder First[NTreasureRoomRelicHolder](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder], System.Func`2[MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicHolder,System.Boolean])
 1976: stloc.s 22
 1978: ldloc.s 21
 1980: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 1985: ldfld field:MegaCrit.Sts2.Core.Models.RelicModel relic
 1990: callvirt method:MegaCrit.Sts2.Core.Models.RelicModel.MegaCrit.Sts2.Core.Models.RelicModel ToMutable()
 1995: stloc.s 23
 1997: ldloc.s 21
 1999: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 2004: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResultType type
 2009: ldc.i4.3 
 2010: beq.s 2130
 2012: ldloc.s 23
 2014: ldloc.s 21
 2016: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 2021: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 2026: ldc.i4.m1 
 2027: call method:MegaCrit.Sts2.Core.Commands.RelicCmd.System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.Models.RelicModel] Obtain(MegaCrit.Sts2.Core.Models.RelicModel, MegaCrit.Sts2.Core.Entities.Players.Player, Int32)
 2032: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 2037: pop 
 2038: ldloc.s 21
 2040: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 2045: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 2050: call method:MegaCrit.Sts2.Core.Context.LocalContext.Boolean IsMe(MegaCrit.Sts2.Core.Entities.Players.Player)
 2055: brfalse.s 2103
 2057: call method:MegaCrit.Sts2.Core.Nodes.NRun.MegaCrit.Sts2.Core.Nodes.NRun get_Instance()
 2062: callvirt method:MegaCrit.Sts2.Core.Nodes.NRun.MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi get_GlobalUi()
 2067: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi.MegaCrit.Sts2.Core.Nodes.Relics.NRelicInventory get_RelicInventory()
 2072: ldloc.s 23
 2074: ldloc.s 22
 2076: callvirt method:Godot.Control.Godot.Vector2 get_GlobalPosition()
 2081: newobj method:System.Nullable`1[Godot.Vector2].Void .ctor(Godot.Vector2)
 2086: ldloc.s 22
 2088: callvirt method:Godot.Control.Godot.Vector2 get_Scale()
 2093: newobj method:System.Nullable`1[Godot.Vector2].Void .ctor(Godot.Vector2)
 2098: callvirt method:MegaCrit.Sts2.Core.Nodes.Relics.NRelicInventory.Void AnimateRelic(MegaCrit.Sts2.Core.Models.RelicModel, System.Nullable`1[Godot.Vector2], System.Nullable`1[Godot.Vector2])
 2103: ldloc.1 
 2104: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 2109: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 2114: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Entities.Players.Player].Int32 get_Count()
 2119: ldc.i4.1 
 2120: bne.un.s 2130
 2122: ldloc.s 22
 2124: ldc.i4.0 
 2125: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 2130: ldloc.1 
 2131: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 2136: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 2141: callvirt method:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Players.Player].System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Entities.Players.Player] GetEnumerator()
 2146: stloc.s 24
 2148: br.s 2199
 2150: ldloc.s 24
 2152: callvirt method:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Entities.Players.Player].MegaCrit.Sts2.Core.Entities.Players.Player get_Current()
 2157: stloc.s 25
 2159: ldloc.s 25
 2161: ldloc.s 21
 2163: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 2168: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 2173: beq.s 2199
 2175: ldloc.s 25
 2177: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.RelicGrabBag get_RelicGrabBag()
 2182: ldloc.s 21
 2184: ldfld field:MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult result
 2189: ldfld field:MegaCrit.Sts2.Core.Models.RelicModel relic
 2194: callvirt method:MegaCrit.Sts2.Core.Runs.RelicGrabBag.Void MoveToFallback(MegaCrit.Sts2.Core.Models.RelicModel)
 2199: ldloc.s 24
 2201: callvirt method:System.Collections.IEnumerator.Boolean MoveNext()
 2206: brtrue.s 2150
 2208: leave.s 2226
 2210: ldloc.0 
 2211: ldc.i4.0 
 2212: bge.s 2225
 2214: ldloc.s 24
 2216: brfalse.s 2225
 2218: ldloc.s 24
 2220: callvirt method:System.IDisposable.Void Dispose()
 2225: endfinally 
 2226: ldloca.s 20
 2228: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult].Boolean MoveNext()
 2233: brtrue 1931
 2238: leave.s 2258
 2240: ldloc.0 
 2241: ldc.i4.0 
 2242: bge.s 2257
 2244: ldloca.s 20
 2246: constrained. type:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult]
 2252: callvirt method:System.IDisposable.Void Dispose()
 2257: endfinally 
 2258: ldloc.1 
 2259: ldfld field:System.Threading.Tasks.TaskCompletionSource _relicPickingCompleteTaskCompletionSource
 2264: callvirt method:System.Threading.Tasks.TaskCompletionSource.Void SetResult()
 2269: leave.s 2303
 2271: stloc.s 26
 2273: ldarg.0 
 2274: ldc.i4.s -2
 2276: stfld field:Int32 <>1__state
 2281: ldarg.0 
 2282: ldnull 
 2283: stfld field:System.Collections.Generic.List`1[System.Threading.Tasks.Task] <tasksToWait>5__2
 2288: ldarg.0 
 2289: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 2294: ldloc.s 26
 2296: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 2301: leave.s 2329
 2303: ldarg.0 
 2304: ldc.i4.s -2
 2306: stfld field:Int32 <>1__state
 2311: ldarg.0 
 2312: ldnull 
 2313: stfld field:System.Collections.Generic.List`1[System.Threading.Tasks.Task] <tasksToWait>5__2
 2318: ldarg.0 
 2319: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 2324: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 2329: ret 
