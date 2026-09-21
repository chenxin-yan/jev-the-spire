METHOD Void EnqueueWithoutSynchronizing(MegaCrit.Sts2.Core.GameActions.GameAction)
 0000: ldarg.0 
 0001: ldfld field:System.Threading.Tasks.TaskCompletionSource _queuesEmptyCompletionSource
 0006: brfalse.s 26
 0008: ldarg.0 
 0009: ldfld field:System.Threading.Tasks.TaskCompletionSource _queuesEmptyCompletionSource
 0014: callvirt method:System.Threading.Tasks.TaskCompletionSource.System.Threading.Tasks.Task get_Task()
 0019: callvirt method:System.Threading.Tasks.Task.Boolean get_IsCompleted()
 0024: brfalse.s 37
 0026: ldarg.0 
 0027: newobj method:System.Threading.Tasks.TaskCompletionSource.Void .ctor()
 0032: stfld field:System.Threading.Tasks.TaskCompletionSource _queuesEmptyCompletionSource
 0037: ldarg.1 
 0038: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.System.Nullable`1[System.UInt32] get_Id()
 0043: stloc.1 
 0044: ldloca.s 1
 0046: call method:System.Nullable`1[System.UInt32].Boolean get_HasValue()
 0051: brfalse.s 133
 0053: ldloca.s 2
 0055: ldc.i4.s 111
 0057: ldc.i4.2 
 0058: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0063: ldloca.s 2
 0065: ldstr str:Attempting to enqueue GameAction 
 0070: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0075: ldloca.s 2
 0077: ldarg.1 
 0078: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0083: ldloca.s 2
 0085: ldstr str: which already has an ID 
 0090: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0095: ldloca.s 2
 0097: ldarg.1 
 0098: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.System.Nullable`1[System.UInt32] get_Id()
 0103: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Nullable`1](System.Nullable`1[System.UInt32])
 0108: ldloca.s 2
 0110: ldstr str:, indicating it was previously enqueued to the queue!
 0115: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0120: ldloca.s 2
 0122: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0127: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0132: throw 
 0133: ldarg.1 
 0134: ldarg.0 
 0135: ldftn method:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet.Void PopAction(MegaCrit.Sts2.Core.GameActions.GameAction)
 0141: newobj method:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction].Void .ctor(System.Object, IntPtr)
 0146: ldarg.0 
 0147: call method:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet.UInt32 GetAndIncrementActionId()
 0152: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.Void OnEnqueued(System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction], UInt32)
 0157: ldarg.0 
 0158: ldarg.1 
 0159: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.UInt64 get_OwnerId()
 0164: call method:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet.ActionQueue GetQueue(UInt64)
 0169: stloc.0 
 0170: ldarg.0 
 0171: ldfld field:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction] ActionEnqueued
 0176: dup 
 0177: brtrue.s 182
 0179: pop 
 0180: br.s 188
 0182: ldarg.1 
 0183: callvirt method:System.Action`1[MegaCrit.Sts2.Core.GameActions.GameAction].Void Invoke(MegaCrit.Sts2.Core.GameActions.GameAction)
 0188: leave.s 262
 0190: stloc.3 
 0191: ldloca.s 2
 0193: ldc.i4.s 53
 0195: ldc.i4.2 
 0196: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0201: ldloca.s 2
 0203: ldstr str:Exception encountered in ActionEnqueued for action 
 0208: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0213: ldloca.s 2
 0215: ldarg.1 
 0216: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0221: ldloca.s 2
 0223: ldstr str:: 
 0228: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0233: ldloca.s 2
 0235: ldloc.3 
 0236: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Exception](System.Exception)
 0241: ldloca.s 2
 0243: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0248: ldc.i4.2 
 0249: call method:MegaCrit.Sts2.Core.Logging.Log.Void Error(System.String, Int32)
 0254: ldloc.3 
 0255: call method:MegaCrit.Sts2.Core.Debug.SentryService.Void CaptureException(System.Exception)
 0260: leave.s 262
 0262: ldloc.0 
 0263: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet+ActionQueue.Boolean get_IsCancellingPlayCardActions()
 0268: brfalse.s 374
 0270: ldarg.1 
 0271: isinst type:MegaCrit.Sts2.Core.GameActions.PlayCardAction
 0276: brfalse.s 374
 0278: ldarg.0 
 0279: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0284: ldloca.s 2
 0286: ldc.i4 136
 0291: ldc.i4.2 
 0292: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0297: ldloca.s 2
 0299: ldstr str:Attempted to enqueue PlayCardAction 
 0304: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0309: ldloca.s 2
 0311: ldarg.1 
 0312: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0317: ldloca.s 2
 0319: ldstr str: to player queue owned by 
 0324: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0329: ldloca.s 2
 0331: ldarg.1 
 0332: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.UInt64 get_OwnerId()
 0337: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0342: ldloca.s 2
 0344: ldstr str:, but it's currently cancelling all play card actions due to player choice
 0349: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0354: ldloca.s 2
 0356: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0361: ldc.i4.1 
 0362: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0367: ldarg.1 
 0368: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.Void Cancel()
 0373: ret 
 0374: ldloc.0 
 0375: ldfld field:Boolean isCancellingPlayerDrivenCombatActions
 0380: brfalse.s 504
 0382: ldarg.1 
 0383: call method:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet.Boolean IsGameActionPlayerDriven(MegaCrit.Sts2.Core.GameActions.GameAction)
 0388: brfalse.s 504
 0390: ldarg.1 
 0391: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.MegaCrit.Sts2.Core.Entities.Multiplayer.GameActionType get_ActionType()
 0396: ldc.i4.3 
 0397: beq.s 504
 0399: ldarg.1 
 0400: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.MegaCrit.Sts2.Core.Entities.Multiplayer.GameActionType get_ActionType()
 0405: ldc.i4.4 
 0406: beq.s 504
 0408: ldarg.0 
 0409: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0414: ldloca.s 2
 0416: ldc.i4 129
 0421: ldc.i4.2 
 0422: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0427: ldloca.s 2
 0429: ldstr str:Attempted to enqueue GameAction 
 0434: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0439: ldloca.s 2
 0441: ldarg.1 
 0442: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0447: ldloca.s 2
 0449: ldstr str: to player queue owned by 
 0454: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0459: ldloca.s 2
 0461: ldarg.1 
 0462: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.UInt64 get_OwnerId()
 0467: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0472: ldloca.s 2
 0474: ldstr str:, but it's currently cancelling all non-hook actions due to end of turn
 0479: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0484: ldloca.s 2
 0486: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0491: ldc.i4.1 
 0492: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0497: ldarg.1 
 0498: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.Void Cancel()
 0503: ret 
 0504: ldloc.0 
 0505: ldfld field:Boolean isCancellingCombatActions
 0510: stloc.s 4
 0512: ldloc.s 4
 0514: stloc.s 5
 0516: ldloc.s 5
 0518: brfalse.s 547
 0520: ldarg.1 
 0521: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.MegaCrit.Sts2.Core.Entities.Multiplayer.GameActionType get_ActionType()
 0526: stloc.s 6
 0528: ldloc.s 6
 0530: ldc.i4.1 
 0531: sub 
 0532: ldc.i4.1 
 0533: bgt.un.s 540
 0535: ldc.i4.1 
 0536: stloc.s 7
 0538: br.s 543
 0540: ldc.i4.0 
 0541: stloc.s 7
 0543: ldloc.s 7
 0545: stloc.s 5
 0547: ldloc.s 5
 0549: brfalse.s 644
 0551: ldarg.0 
 0552: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0557: ldloca.s 2
 0559: ldc.i4.s 108
 0561: ldc.i4.2 
 0562: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0567: ldloca.s 2
 0569: ldstr str:Attempted to enqueue GameAction 
 0574: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0579: ldloca.s 2
 0581: ldarg.1 
 0582: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0587: ldloca.s 2
 0589: ldstr str: to player queue owned by 
 0594: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0599: ldloca.s 2
 0601: ldarg.1 
 0602: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.UInt64 get_OwnerId()
 0607: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0612: ldloca.s 2
 0614: ldstr str:, but it's currently cancelling all combat actions
 0619: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0624: ldloca.s 2
 0626: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0631: ldc.i4.1 
 0632: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0637: ldarg.1 
 0638: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.Void Cancel()
 0643: ret 
 0644: ldarg.0 
 0645: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0650: ldloca.s 2
 0652: ldc.i4.s 44
 0654: ldc.i4.2 
 0655: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0660: ldloca.s 2
 0662: ldstr str:Enqueueing action 
 0667: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0672: ldloca.s 2
 0674: ldarg.1 
 0675: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0680: ldloca.s 2
 0682: ldstr str: to player queue owned by 
 0687: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0692: ldloca.s 2
 0694: ldarg.1 
 0695: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.UInt64 get_OwnerId()
 0700: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0705: ldloca.s 2
 0707: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0712: ldc.i4.1 
 0713: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0718: ldloc.0 
 0719: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.GameActions.GameAction] actions
 0724: ldarg.1 
 0725: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.GameActions.GameAction].Void Add(MegaCrit.Sts2.Core.GameActions.GameAction)
 0730: ldarg.0 
 0731: ldfld field:System.Action ActionQueueChanged
 0736: dup 
 0737: brtrue.s 741
 0739: pop 
 0740: ret 
 0741: callvirt method:System.Action.Void Invoke()
 0746: ret 
