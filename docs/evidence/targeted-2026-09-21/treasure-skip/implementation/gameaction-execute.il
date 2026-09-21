METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.GameActions.GameAction <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse 315
 0020: ldloc.1 
 0021: newobj method:System.Threading.Tasks.TaskCompletionSource.Void .ctor()
 0026: stfld field:System.Threading.Tasks.TaskCompletionSource _pauseForPlayerChoiceTaskSource
 0031: ldloc.1 
 0032: call method:MegaCrit.Sts2.Core.GameActions.GameAction.MegaCrit.Sts2.Core.Entities.Actions.GameActionState get_State()
 0037: stloc.2 
 0038: ldloc.2 
 0039: ldc.i4.1 
 0040: beq.s 51
 0042: ldloc.2 
 0043: ldc.i4.4 
 0044: beq.s 157
 0046: br 236
 0051: ldsfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0056: ldc.i4.s 23
 0058: ldc.i4.1 
 0059: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0064: stloc.3 
 0065: ldloca.s 3
 0067: ldstr str:Action 
 0072: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0077: ldloca.s 3
 0079: ldloc.1 
 0080: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0085: ldloca.s 3
 0087: ldstr str: began executing
 0092: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0097: ldloca.s 3
 0099: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0104: ldc.i4.1 
 0105: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void VeryDebug(System.String, Int32)
 0110: ldloc.1 
 0111: ldc.i4.2 
 0112: call method:MegaCrit.Sts2.Core.GameActions.GameAction.Void set_State(MegaCrit.Sts2.Core.Entities.Actions.GameActionState)
 0117: ldloc.1 
 0118: ldfld field:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction] BeforeExecuted
 0123: dup 
 0124: brtrue.s 129
 0126: pop 
 0127: br.s 135
 0129: ldloc.1 
 0130: callvirt method:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction].Void Invoke(MegaCrit.Sts2.Core.GameActions.GameAction)
 0135: ldloc.1 
 0136: ldloc.1 
 0137: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.System.Threading.Tasks.Task ExecuteAction()
 0142: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0147: stfld field:System.Threading.Tasks.Task _executionTask
 0152: br 315
 0157: ldsfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0162: ldc.i4.s 25
 0164: ldc.i4.1 
 0165: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0170: stloc.3 
 0171: ldloca.s 3
 0173: ldstr str:Action 
 0178: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0183: ldloca.s 3
 0185: ldloc.1 
 0186: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0191: ldloca.s 3
 0193: ldstr str: resumed execution
 0198: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0203: ldloca.s 3
 0205: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0210: ldc.i4.1 
 0211: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void VeryDebug(System.String, Int32)
 0216: ldloc.1 
 0217: ldc.i4.2 
 0218: call method:MegaCrit.Sts2.Core.GameActions.GameAction.Void set_State(MegaCrit.Sts2.Core.Entities.Actions.GameActionState)
 0223: ldloc.1 
 0224: ldfld field:System.Threading.Tasks.TaskCompletionSource _executeAfterResumptionTaskSource
 0229: callvirt method:System.Threading.Tasks.TaskCompletionSource.Void SetResult()
 0234: br.s 315
 0236: ldc.i4.s 108
 0238: ldc.i4.2 
 0239: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0244: stloc.3 
 0245: ldloca.s 3
 0247: ldstr str:Attempted to execute GameAction 
 0252: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0257: ldloca.s 3
 0259: ldloc.1 
 0260: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0265: ldloca.s 3
 0267: ldstr str: from invalid state 
 0272: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0277: ldloca.s 3
 0279: ldloc.1 
 0280: call method:MegaCrit.Sts2.Core.GameActions.GameAction.MegaCrit.Sts2.Core.Entities.Actions.GameActionState get_State()
 0285: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameActionState](MegaCrit.Sts2.Core.Entities.Actions.GameActionState)
 0290: ldloca.s 3
 0292: ldstr str:! Expected WaitingForExecution or ReadyToResumeExecuting
 0297: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0302: ldloca.s 3
 0304: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0309: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0314: throw 
 0315: nop 
 0316: ldloc.0 
 0317: brfalse.s 405
 0319: ldc.i4.2 
 0320: newarr type:System.Threading.Tasks.Task
 0325: dup 
 0326: ldc.i4.0 
 0327: ldloc.1 
 0328: ldfld field:System.Threading.Tasks.Task _executionTask
 0333: stelem.ref 
 0334: dup 
 0335: ldc.i4.1 
 0336: ldloc.1 
 0337: ldfld field:System.Threading.Tasks.TaskCompletionSource _pauseForPlayerChoiceTaskSource
 0342: callvirt method:System.Threading.Tasks.TaskCompletionSource.System.Threading.Tasks.Task get_Task()
 0347: stelem.ref 
 0348: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task WhenAny(System.Threading.Tasks.Task[])
 0353: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0358: stloc.s 4
 0360: ldloca.s 4
 0362: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0367: brtrue.s 434
 0369: ldarg.0 
 0370: ldc.i4.0 
 0371: dup 
 0372: stloc.0 
 0373: stfld field:Int32 <>1__state
 0378: ldarg.0 
 0379: ldloc.s 4
 0381: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0386: ldarg.0 
 0387: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0392: ldloca.s 4
 0394: ldarg.0 
 0395: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<Execute>d__45](System.Runtime.CompilerServices.TaskAwaiter ByRef, <Execute>d__45 ByRef)
 0400: leave 821
 0405: ldarg.0 
 0406: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0411: stloc.s 4
 0413: ldarg.0 
 0414: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0419: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0425: ldarg.0 
 0426: ldc.i4.m1 
 0427: dup 
 0428: stloc.0 
 0429: stfld field:Int32 <>1__state
 0434: ldloca.s 4
 0436: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0441: leave 775
 0446: ldloc.0 
 0447: ldc.i4.0 
 0448: bge 774
 0453: ldloc.1 
 0454: ldfld field:System.Threading.Tasks.Task _executionTask
 0459: callvirt method:System.Threading.Tasks.Task.Boolean get_IsCompleted()
 0464: brfalse 715
 0469: ldloc.1 
 0470: call method:MegaCrit.Sts2.Core.GameActions.GameAction.MegaCrit.Sts2.Core.Entities.Actions.GameActionState get_State()
 0475: stloc.s 5
 0477: ldsfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0482: ldc.i4.s 26
 0484: ldc.i4.1 
 0485: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0490: stloc.3 
 0491: ldloca.s 3
 0493: ldstr str:Action 
 0498: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0503: ldloca.s 3
 0505: ldloc.1 
 0506: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0511: ldloca.s 3
 0513: ldstr str: finished execution
 0518: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0523: ldloca.s 3
 0525: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0530: ldc.i4.1 
 0531: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void VeryDebug(System.String, Int32)
 0536: ldloc.1 
 0537: ldc.i4.5 
 0538: call method:MegaCrit.Sts2.Core.GameActions.GameAction.Void set_State(MegaCrit.Sts2.Core.Entities.Actions.GameActionState)
 0543: ldloc.1 
 0544: ldfld field:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction] JustBeforeFinished
 0549: dup 
 0550: brtrue.s 555
 0552: pop 
 0553: br.s 561
 0555: ldloc.1 
 0556: callvirt method:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction].Void Invoke(MegaCrit.Sts2.Core.GameActions.GameAction)
 0561: ldloc.1 
 0562: ldfld field:System.Threading.Tasks.TaskCompletionSource _completionSource
 0567: callvirt method:System.Threading.Tasks.TaskCompletionSource.Boolean TrySetResult()
 0572: pop 
 0573: ldloc.1 
 0574: ldfld field:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction] AfterFinished
 0579: dup 
 0580: brtrue.s 585
 0582: pop 
 0583: br.s 591
 0585: ldloc.1 
 0586: callvirt method:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction].Void Invoke(MegaCrit.Sts2.Core.GameActions.GameAction)
 0591: ldloc.s 5
 0593: ldc.i4.2 
 0594: beq 774
 0599: ldc.i4 128
 0604: ldc.i4.2 
 0605: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0610: stloc.3 
 0611: ldloca.s 3
 0613: ldstr str:GameAction 
 0618: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0623: ldloca.s 3
 0625: ldloc.1 
 0626: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0631: ldloca.s 3
 0633: ldstr str: finished execution, but was in state 
 0638: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0643: ldloca.s 3
 0645: ldloc.s 5
 0647: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameActionState](MegaCrit.Sts2.Core.Entities.Actions.GameActionState)
 0652: ldloca.s 3
 0654: ldstr str:! The task probably kept executing in a paused state without properly resuming.
 0659: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0664: ldloca.s 3
 0666: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0671: stloc.s 6
 0673: ldloc.s 6
 0675: ldloc.1 
 0676: call method:MegaCrit.Sts2.Core.GameActions.GameAction.System.Exception get_Exception()
 0681: newobj method:System.InvalidOperationException.Void .ctor(System.String, System.Exception)
 0686: stloc.s 7
 0688: call method:MegaCrit.Sts2.Core.Helpers.NonInteractiveMode.Boolean get_IsActive()
 0693: brfalse.s 698
 0695: ldloc.s 7
 0697: throw 
 0698: ldloc.s 6
 0700: ldc.i4.2 
 0701: call method:MegaCrit.Sts2.Core.Logging.Log.Void Error(System.String, Int32)
 0706: ldloc.s 7
 0708: call method:MegaCrit.Sts2.Core.Debug.SentryService.Void CaptureException(System.Exception)
 0713: br.s 774
 0715: ldsfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0720: ldc.i4.s 24
 0722: ldc.i4.1 
 0723: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0728: stloc.3 
 0729: ldloca.s 3
 0731: ldstr str:Action 
 0736: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0741: ldloca.s 3
 0743: ldloc.1 
 0744: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0749: ldloca.s 3
 0751: ldstr str: paused execution
 0756: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0761: ldloca.s 3
 0763: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0768: ldc.i4.1 
 0769: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void VeryDebug(System.String, Int32)
 0774: endfinally 
 0775: leave.s 802
 0777: stloc.s 8
 0779: ldarg.0 
 0780: ldc.i4.s -2
 0782: stfld field:Int32 <>1__state
 0787: ldarg.0 
 0788: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0793: ldloc.s 8
 0795: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0800: leave.s 821
 0802: ldarg.0 
 0803: ldc.i4.s -2
 0805: stfld field:Int32 <>1__state
 0810: ldarg.0 
 0811: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0816: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0821: ret 
