METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.GameActions.ActionExecutor <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: ldc.i4.3 
 0016: ble.un.s 40
 0018: ldloc.1 
 0019: newobj method:System.Threading.Tasks.TaskCompletionSource`1[System.Boolean].Void .ctor()
 0024: stfld field:System.Threading.Tasks.TaskCompletionSource`1[System.Boolean] _queueTaskCompletionSource
 0029: ldloc.1 
 0030: newobj method:System.Threading.CancellationTokenSource.Void .ctor()
 0035: stfld field:System.Threading.CancellationTokenSource _actionCancelToken
 0040: nop 
 0041: ldloc.0 
 0042: switch switch 4
 0063: ldarg.0 
 0064: ldloc.1 
 0065: ldfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet _actionQueueSet
 0070: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet.MegaCrit.Sts2.Core.GameActions.GameAction GetReadyAction()
 0075: stfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0080: br 1141
 0085: ldloc.1 
 0086: call method:MegaCrit.Sts2.Core.GameActions.ActionExecutor.System.Threading.Tasks.Task WaitForUnpause()
 0091: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0096: stloc.2 
 0097: ldloca.s 2
 0099: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0104: brtrue.s 169
 0106: ldarg.0 
 0107: ldc.i4.0 
 0108: dup 
 0109: stloc.0 
 0110: stfld field:Int32 <>1__state
 0115: ldarg.0 
 0116: ldloc.2 
 0117: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0122: ldarg.0 
 0123: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0128: ldloca.s 2
 0130: ldarg.0 
 0131: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<ExecuteActions>d__28](System.Runtime.CompilerServices.TaskAwaiter ByRef, <ExecuteActions>d__28 ByRef)
 0136: leave 1286
 0141: ldarg.0 
 0142: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0147: stloc.2 
 0148: ldarg.0 
 0149: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0154: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0160: ldarg.0 
 0161: ldc.i4.m1 
 0162: dup 
 0163: stloc.0 
 0164: stfld field:Int32 <>1__state
 0169: ldloca.s 2
 0171: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0176: ldarg.0 
 0177: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0182: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.MegaCrit.Sts2.Core.Entities.Actions.GameActionState get_State()
 0187: ldc.i4.6 
 0188: bne.un.s 212
 0190: ldarg.0 
 0191: ldloc.1 
 0192: ldfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet _actionQueueSet
 0197: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet.MegaCrit.Sts2.Core.GameActions.GameAction GetReadyAction()
 0202: stfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0207: br 1141
 0212: ldloc.1 
 0213: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0218: ldc.i4.s 18
 0220: ldc.i4.1 
 0221: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0226: stloc.3 
 0227: ldloca.s 3
 0229: ldstr str:Executing action: 
 0234: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0239: ldloca.s 3
 0241: ldarg.0 
 0242: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0247: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0252: ldloca.s 3
 0254: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0259: ldc.i4.1 
 0260: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0265: ldloc.1 
 0266: ldfld field:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction] BeforeActionExecuted
 0271: dup 
 0272: brtrue.s 277
 0274: pop 
 0275: br.s 288
 0277: ldarg.0 
 0278: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0283: callvirt method:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction].Void Invoke(MegaCrit.Sts2.Core.GameActions.GameAction)
 0288: call method:MegaCrit.Sts2.Core.Helpers.NonInteractiveMode.Boolean get_IsActive()
 0293: brfalse 426
 0298: ldloc.1 
 0299: ldarg.0 
 0300: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0305: call method:MegaCrit.Sts2.Core.GameActions.ActionExecutor.Void set_CurrentlyRunningAction(MegaCrit.Sts2.Core.GameActions.GameAction)
 0310: ldarg.0 
 0311: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0316: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.System.Threading.Tasks.Task Execute()
 0321: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0326: stloc.s 4
 0328: ldloca.s 4
 0330: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0335: brtrue.s 402
 0337: ldarg.0 
 0338: ldc.i4.1 
 0339: dup 
 0340: stloc.0 
 0341: stfld field:Int32 <>1__state
 0346: ldarg.0 
 0347: ldloc.s 4
 0349: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0354: ldarg.0 
 0355: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0360: ldloca.s 4
 0362: ldarg.0 
 0363: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<ExecuteActions>d__28](System.Runtime.CompilerServices.TaskAwaiter ByRef, <ExecuteActions>d__28 ByRef)
 0368: leave 1286
 0373: ldarg.0 
 0374: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0379: stloc.s 4
 0381: ldarg.0 
 0382: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0387: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0393: ldarg.0 
 0394: ldc.i4.m1 
 0395: dup 
 0396: stloc.0 
 0397: stfld field:Int32 <>1__state
 0402: ldloca.s 4
 0404: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0409: ldloc.1 
 0410: ldarg.0 
 0411: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0416: call method:MegaCrit.Sts2.Core.GameActions.ActionExecutor.Void AfterActionFinished(MegaCrit.Sts2.Core.GameActions.GameAction)
 0421: br 738
 0426: ldloc.1 
 0427: ldarg.0 
 0428: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0433: call method:MegaCrit.Sts2.Core.GameActions.ActionExecutor.Void set_CurrentlyRunningAction(MegaCrit.Sts2.Core.GameActions.GameAction)
 0438: ldarg.0 
 0439: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0444: ldloc.1 
 0445: ldftn method:MegaCrit.Sts2.Core.GameActions.ActionExecutor.Void JustBeforeActionFinished(MegaCrit.Sts2.Core.GameActions.GameAction)
 0451: newobj method:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction].Void .ctor(System.Object, IntPtr)
 0456: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.Void add_JustBeforeFinished(System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction])
 0461: ldarg.0 
 0462: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0467: ldloc.1 
 0468: ldftn method:MegaCrit.Sts2.Core.GameActions.ActionExecutor.Void AfterActionFinished(MegaCrit.Sts2.Core.GameActions.GameAction)
 0474: newobj method:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction].Void .ctor(System.Object, IntPtr)
 0479: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.Void add_AfterFinished(System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction])
 0484: ldarg.0 
 0485: ldarg.0 
 0486: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0491: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.System.Threading.Tasks.Task Execute()
 0496: stfld field:System.Threading.Tasks.Task <actionTask>5__3
 0501: br.s 612
 0503: call method:Godot.Engine.Godot.MainLoop GetMainLoop()
 0508: call method:Godot.Engine.Godot.MainLoop GetMainLoop()
 0513: ldsfld field:Godot.StringName ProcessFrame
 0518: callvirt method:Godot.GodotObject.Godot.SignalAwaiter ToSignal(Godot.GodotObject, Godot.StringName)
 0523: callvirt method:Godot.SignalAwaiter.Godot.IAwaiter`1[Godot.Variant[]] GetAwaiter()
 0528: stloc.s 5
 0530: ldloc.s 5
 0532: callvirt method:Godot.IAwaiter`1[Godot.Variant[]].Boolean get_IsCompleted()
 0537: brtrue.s 604
 0539: ldarg.0 
 0540: ldc.i4.2 
 0541: dup 
 0542: stloc.0 
 0543: stfld field:Int32 <>1__state
 0548: ldarg.0 
 0549: ldloc.s 5
 0551: stfld field:System.Object <>u__2
 0556: ldarg.0 
 0557: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0562: ldloca.s 5
 0564: ldarg.0 
 0565: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitOnCompleted[IAwaiter`1,<ExecuteActions>d__28](Godot.IAwaiter`1[Godot.Variant[]] ByRef, <ExecuteActions>d__28 ByRef)
 0570: leave 1286
 0575: ldarg.0 
 0576: ldfld field:System.Object <>u__2
 0581: castclass type:Godot.IAwaiter`1[Godot.Variant[]]
 0586: stloc.s 5
 0588: ldarg.0 
 0589: ldnull 
 0590: stfld field:System.Object <>u__2
 0595: ldarg.0 
 0596: ldc.i4.m1 
 0597: dup 
 0598: stloc.0 
 0599: stfld field:Int32 <>1__state
 0604: ldloc.s 5
 0606: callvirt method:Godot.IAwaiter`1[Godot.Variant[]].Godot.Variant[] GetResult()
 0611: pop 
 0612: ldarg.0 
 0613: ldfld field:System.Threading.Tasks.Task <actionTask>5__3
 0618: callvirt method:System.Threading.Tasks.Task.Boolean get_IsCompleted()
 0623: brtrue.s 641
 0625: ldloc.1 
 0626: ldfld field:System.Threading.CancellationTokenSource _actionCancelToken
 0631: callvirt method:System.Threading.CancellationTokenSource.Boolean get_IsCancellationRequested()
 0636: brfalse 503
 0641: ldarg.0 
 0642: ldfld field:System.Threading.Tasks.Task <actionTask>5__3
 0647: callvirt method:System.Threading.Tasks.Task.Boolean get_IsFaulted()
 0652: brfalse.s 731
 0654: ldc.i4.s 38
 0656: ldc.i4.2 
 0657: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0662: stloc.3 
 0663: ldloca.s 3
 0665: ldstr str:GameAction 
 0670: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0675: ldloca.s 3
 0677: ldarg.0 
 0678: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0683: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0688: ldloca.s 3
 0690: ldstr str: completed with exception: 
 0695: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0700: ldloca.s 3
 0702: ldarg.0 
 0703: ldfld field:System.Threading.Tasks.Task <actionTask>5__3
 0708: callvirt method:System.Threading.Tasks.Task.System.AggregateException get_Exception()
 0713: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[AggregateException](System.AggregateException)
 0718: ldloca.s 3
 0720: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0725: ldc.i4.2 
 0726: call method:MegaCrit.Sts2.Core.Logging.Log.Void Error(System.String, Int32)
 0731: ldarg.0 
 0732: ldnull 
 0733: stfld field:System.Threading.Tasks.Task <actionTask>5__3
 0738: call method:MegaCrit.Sts2.Core.Combat.CombatManager.MegaCrit.Sts2.Core.Combat.CombatManager get_Instance()
 0743: callvirt method:MegaCrit.Sts2.Core.Combat.CombatManager.Boolean get_IsInProgress()
 0748: stloc.s 6
 0750: ldloc.s 6
 0752: stloc.s 7
 0754: ldloc.s 7
 0756: brfalse.s 799
 0758: ldarg.0 
 0759: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0764: isinst type:MegaCrit.Sts2.Core.GameActions.EndPlayerTurnAction
 0769: brtrue.s 784
 0771: ldarg.0 
 0772: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0777: isinst type:MegaCrit.Sts2.Core.GameActions.ReadyToBeginEnemyTurnAction
 0782: brfalse.s 789
 0784: ldc.i4.1 
 0785: stloc.s 8
 0787: br.s 792
 0789: ldc.i4.0 
 0790: stloc.s 8
 0792: ldloc.s 8
 0794: ldc.i4.0 
 0795: ceq 
 0797: stloc.s 7
 0799: ldloc.s 7
 0801: brfalse.s 902
 0803: call method:MegaCrit.Sts2.Core.Combat.CombatManager.MegaCrit.Sts2.Core.Combat.CombatManager get_Instance()
 0808: callvirt method:MegaCrit.Sts2.Core.Combat.CombatManager.System.Threading.Tasks.Task`1[System.Boolean] CheckWinCondition()
 0813: callvirt method:System.Threading.Tasks.Task`1[System.Boolean].System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] GetAwaiter()
 0818: stloc.s 9
 0820: ldloca.s 9
 0822: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean].Boolean get_IsCompleted()
 0827: brtrue.s 894
 0829: ldarg.0 
 0830: ldc.i4.3 
 0831: dup 
 0832: stloc.0 
 0833: stfld field:Int32 <>1__state
 0838: ldarg.0 
 0839: ldloc.s 9
 0841: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__3
 0846: ldarg.0 
 0847: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0852: ldloca.s 9
 0854: ldarg.0 
 0855: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<ExecuteActions>d__28](System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] ByRef, <ExecuteActions>d__28 ByRef)
 0860: leave 1286
 0865: ldarg.0 
 0866: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__3
 0871: stloc.s 9
 0873: ldarg.0 
 0874: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__3
 0879: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean]
 0885: ldarg.0 
 0886: ldc.i4.m1 
 0887: dup 
 0888: stloc.0 
 0889: stfld field:Int32 <>1__state
 0894: ldloca.s 9
 0896: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean].Boolean GetResult()
 0901: pop 
 0902: ldarg.0 
 0903: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0908: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.MegaCrit.Sts2.Core.Entities.Actions.GameActionState get_State()
 0913: ldc.i4.5 
 0914: bne.un.s 983
 0916: ldloc.1 
 0917: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0922: ldc.i4.s 61
 0924: ldc.i4.1 
 0925: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0930: stloc.3 
 0931: ldloca.s 3
 0933: ldstr str:Completed execution of action 
 0938: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0943: ldloca.s 3
 0945: ldarg.0 
 0946: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 0951: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0956: ldloca.s 3
 0958: ldstr str:, attempting to find new action
 0963: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0968: ldloca.s 3
 0970: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0975: ldc.i4.1 
 0976: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0981: br.s 1078
 0983: ldloc.1 
 0984: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0989: ldc.i4.s 70
 0991: ldc.i4.2 
 0992: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0997: stloc.3 
 0998: ldloca.s 3
 1000: ldstr str:Paused execution of action 
 1005: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 1010: ldloca.s 3
 1012: ldarg.0 
 1013: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 1018: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 1023: ldloca.s 3
 1025: ldstr str: (state is 
 1030: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 1035: ldloca.s 3
 1037: ldarg.0 
 1038: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 1043: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.MegaCrit.Sts2.Core.Entities.Actions.GameActionState get_State()
 1048: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameActionState](MegaCrit.Sts2.Core.Entities.Actions.GameActionState)
 1053: ldloca.s 3
 1055: ldstr str:), attempting to find new action
 1060: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 1065: ldloca.s 3
 1067: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 1072: ldc.i4.1 
 1073: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 1078: ldarg.0 
 1079: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 1084: ldloc.1 
 1085: ldftn method:MegaCrit.Sts2.Core.GameActions.ActionExecutor.Void JustBeforeActionFinished(MegaCrit.Sts2.Core.GameActions.GameAction)
 1091: newobj method:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction].Void .ctor(System.Object, IntPtr)
 1096: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.Void remove_JustBeforeFinished(System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction])
 1101: ldarg.0 
 1102: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 1107: ldloc.1 
 1108: ldftn method:MegaCrit.Sts2.Core.GameActions.ActionExecutor.Void AfterActionFinished(MegaCrit.Sts2.Core.GameActions.GameAction)
 1114: newobj method:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction].Void .ctor(System.Object, IntPtr)
 1119: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.Void remove_AfterFinished(System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction])
 1124: ldarg.0 
 1125: ldloc.1 
 1126: ldfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet _actionQueueSet
 1131: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet.MegaCrit.Sts2.Core.GameActions.GameAction GetReadyAction()
 1136: stfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 1141: ldarg.0 
 1142: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 1147: brtrue 85
 1152: ldloc.1 
 1153: ldfld field:System.Threading.Tasks.TaskCompletionSource`1[System.Boolean] _queueTaskCompletionSource
 1158: dup 
 1159: brtrue.s 1164
 1161: pop 
 1162: br.s 1170
 1164: ldc.i4.1 
 1165: call method:System.Threading.Tasks.TaskCompletionSource`1[System.Boolean].Void SetResult(Boolean)
 1170: ldarg.0 
 1171: ldnull 
 1172: stfld field:MegaCrit.Sts2.Core.GameActions.GameAction <readyAction>5__2
 1177: leave.s 1240
 1179: stloc.s 10
 1181: ldstr str:ActionExecutor.ExecuteActions should never be canceled!
 1186: ldloc.s 10
 1188: newobj method:System.InvalidOperationException.Void .ctor(System.String, System.Exception)
 1193: stloc.s 11
 1195: ldloc.1 
 1196: ldfld field:System.Threading.Tasks.TaskCompletionSource`1[System.Boolean] _queueTaskCompletionSource
 1201: dup 
 1202: brtrue.s 1207
 1204: pop 
 1205: br.s 1214
 1207: ldloc.s 11
 1209: call method:System.Threading.Tasks.TaskCompletionSource`1[System.Boolean].Void SetException(System.Exception)
 1214: ldloc.s 11
 1216: throw 
 1217: stloc.s 12
 1219: ldloc.1 
 1220: ldfld field:System.Threading.Tasks.TaskCompletionSource`1[System.Boolean] _queueTaskCompletionSource
 1225: dup 
 1226: brtrue.s 1231
 1228: pop 
 1229: br.s 1238
 1231: ldloc.s 12
 1233: call method:System.Threading.Tasks.TaskCompletionSource`1[System.Boolean].Void SetException(System.Exception)
 1238: rethrow 
 1240: leave.s 1267
 1242: stloc.s 13
 1244: ldarg.0 
 1245: ldc.i4.s -2
 1247: stfld field:Int32 <>1__state
 1252: ldarg.0 
 1253: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 1258: ldloc.s 13
 1260: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 1265: leave.s 1286
 1267: ldarg.0 
 1268: ldc.i4.s -2
 1270: stfld field:Int32 <>1__state
 1275: ldarg.0 
 1276: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 1281: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 1286: ret 
