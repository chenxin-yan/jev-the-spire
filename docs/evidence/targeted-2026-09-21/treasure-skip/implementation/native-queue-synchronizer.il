METHOD Void RequestEnqueue(MegaCrit.Sts2.Core.GameActions.GameAction)
 0000: ldarg.1 
 0001: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.MegaCrit.Sts2.Core.Entities.Multiplayer.GameActionType get_ActionType()
 0006: ldc.i4.2 
 0007: bne.un.s 92
 0009: ldarg.0 
 0010: call method:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSynchronizer.MegaCrit.Sts2.Core.Entities.Multiplayer.ActionSynchronizerCombatState get_CombatState()
 0015: ldc.i4.4 
 0016: bne.un.s 92
 0018: ldarg.0 
 0019: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0024: ldloca.s 0
 0026: ldc.i4.s 105
 0028: ldc.i4.1 
 0029: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0034: ldloca.s 0
 0036: ldstr str:Attempted to request enqueue of action 
 0041: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0046: ldloca.s 0
 0048: ldarg.1 
 0049: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0054: ldloca.s 0
 0056: ldstr str: during the enemy turn. Deferring the action until the player turn
 0061: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0066: ldloca.s 0
 0068: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0073: ldc.i4.1 
 0074: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0079: ldarg.0 
 0080: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.GameActions.GameAction] _requestedActionsWaitingForPlayerTurn
 0085: ldarg.1 
 0086: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.GameActions.GameAction].Void Add(MegaCrit.Sts2.Core.GameActions.GameAction)
 0091: ret 
 0092: ldarg.0 
 0093: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService _netService
 0098: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService.MegaCrit.Sts2.Core.Multiplayer.Game.NetGameType get_Type()
 0103: stloc.2 
 0104: ldloc.2 
 0105: ldc.i4.1 
 0106: sub 
 0107: ldc.i4.1 
 0108: ble.un 245
 0113: ldloc.2 
 0114: ldc.i4.3 
 0115: bne.un 263
 0120: ldarg.0 
 0121: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0126: ldloca.s 0
 0128: ldc.i4.s 57
 0130: ldc.i4.2 
 0131: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0136: ldloca.s 0
 0138: ldstr str:Sending message to host requesting to enqueue action 
 0143: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0148: ldloca.s 0
 0150: ldarg.1 
 0151: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0156: ldloca.s 0
 0158: ldstr str: at 
 0163: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0168: ldloca.s 0
 0170: call method:MegaCrit.Sts2.Core.Logging.Log.System.String get_Timestamp()
 0175: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted(System.String)
 0180: ldloca.s 0
 0182: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0187: ldc.i4.1 
 0188: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0193: ldloca.s 1
 0195: initobj type:MegaCrit.Sts2.Core.Multiplayer.Messages.Game.RequestEnqueueActionMessage
 0201: ldloca.s 1
 0203: ldarg.1 
 0204: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.MegaCrit.Sts2.Core.GameActions.Multiplayer.INetAction ToNetAction()
 0209: stfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.INetAction action
 0214: ldloca.s 1
 0216: ldarg.0 
 0217: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.RunLocationTargetedMessageBuffer _messageBuffer
 0222: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RunLocationTargetedMessageBuffer.MegaCrit.Sts2.Core.Runs.RunLocation get_CurrentLocation()
 0227: stfld field:MegaCrit.Sts2.Core.Runs.RunLocation location
 0232: ldarg.0 
 0233: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService _netService
 0238: ldloc.1 
 0239: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService.Void SendMessage[RequestEnqueueActionMessage](MegaCrit.Sts2.Core.Multiplayer.Messages.Game.RequestEnqueueActionMessage)
 0244: ret 
 0245: ldarg.0 
 0246: ldarg.1 
 0247: ldarg.0 
 0248: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService _netService
 0253: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService.UInt64 get_NetId()
 0258: call method:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSynchronizer.Void EnqueueAction(MegaCrit.Sts2.Core.GameActions.GameAction, UInt64)
 0263: ret 
METHOD Void EnqueueAction(MegaCrit.Sts2.Core.GameActions.GameAction, UInt64)
 0000: ldarg.0 
 0001: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService _netService
 0006: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService.MegaCrit.Sts2.Core.Multiplayer.Game.NetGameType get_Type()
 0011: ldc.i4.2 
 0012: bne.un 149
 0017: ldarg.0 
 0018: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0023: ldloca.s 1
 0025: ldc.i4.s 49
 0027: ldc.i4.2 
 0028: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0033: ldloca.s 1
 0035: ldstr str:Sending message to clients to enqueue action 
 0040: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0045: ldloca.s 1
 0047: ldarg.1 
 0048: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0053: ldloca.s 1
 0055: ldstr str: at 
 0060: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0065: ldloca.s 1
 0067: call method:MegaCrit.Sts2.Core.Logging.Log.System.String get_Timestamp()
 0072: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted(System.String)
 0077: ldloca.s 1
 0079: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0084: ldc.i4.1 
 0085: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0090: ldloca.s 0
 0092: initobj type:MegaCrit.Sts2.Core.Multiplayer.Messages.Game.ActionEnqueuedMessage
 0098: ldloca.s 0
 0100: ldarg.2 
 0101: stfld field:UInt64 playerId
 0106: ldloca.s 0
 0108: ldarg.0 
 0109: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.RunLocationTargetedMessageBuffer _messageBuffer
 0114: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RunLocationTargetedMessageBuffer.MegaCrit.Sts2.Core.Runs.RunLocation get_CurrentLocation()
 0119: stfld field:MegaCrit.Sts2.Core.Runs.RunLocation location
 0124: ldloca.s 0
 0126: ldarg.1 
 0127: callvirt method:MegaCrit.Sts2.Core.GameActions.GameAction.MegaCrit.Sts2.Core.GameActions.Multiplayer.INetAction ToNetAction()
 0132: stfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.INetAction action
 0137: ldarg.0 
 0138: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService _netService
 0143: ldloc.0 
 0144: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService.Void SendMessage[ActionEnqueuedMessage](MegaCrit.Sts2.Core.Multiplayer.Messages.Game.ActionEnqueuedMessage)
 0149: ldarg.0 
 0150: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0155: ldloca.s 1
 0157: ldc.i4.s 30
 0159: ldc.i4.2 
 0160: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0165: ldloca.s 1
 0167: ldstr str:Enqueueing action 
 0172: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0177: ldloca.s 1
 0179: ldarg.1 
 0180: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[GameAction](MegaCrit.Sts2.Core.GameActions.GameAction)
 0185: ldloca.s 1
 0187: ldstr str: from owner 
 0192: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0197: ldloca.s 1
 0199: ldarg.2 
 0200: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0205: ldloca.s 1
 0207: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0212: ldc.i4.1 
 0213: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0218: ldarg.0 
 0219: ldfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet _actionQueueSet
 0224: ldarg.1 
 0225: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSet.Void EnqueueWithoutSynchronizing(MegaCrit.Sts2.Core.GameActions.GameAction)
 0230: ret 
