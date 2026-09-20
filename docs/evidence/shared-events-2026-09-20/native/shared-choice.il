METHOD Void ChooseLocalOption(Int32)
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer.Boolean get_IsShared()
 0006: brfalse 139
 0011: ldarg.0 
 0012: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0017: ldloca.s 1
 0019: ldc.i4.s 49
 0021: ldc.i4.1 
 0022: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0027: ldloca.s 1
 0029: ldstr str:Local player voted for shared event option index 
 0034: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0039: ldloca.s 1
 0041: ldarg.1 
 0042: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Int32](Int32)
 0047: ldloca.s 1
 0049: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0054: ldc.i4.1 
 0055: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0060: ldarg.0 
 0061: ldarg.0 
 0062: call method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer.MegaCrit.Sts2.Core.Entities.Players.Player get_LocalPlayer()
 0067: ldarg.1 
 0068: ldarg.0 
 0069: ldfld field:UInt32 _pageIndex
 0074: call method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer.Void PlayerVotedForSharedOptionIndex(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32, UInt32)
 0079: ldloca.s 0
 0081: initobj type:MegaCrit.Sts2.Core.Multiplayer.Messages.Game.Sync.VotedForSharedEventOptionMessage
 0087: ldloca.s 0
 0089: ldarg.1 
 0090: stfld field:UInt32 optionIndex
 0095: ldloca.s 0
 0097: ldarg.0 
 0098: ldfld field:UInt32 _pageIndex
 0103: stfld field:UInt32 pageIndex
 0108: ldloca.s 0
 0110: ldarg.0 
 0111: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.RunLocationTargetedMessageBuffer _messageBuffer
 0116: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RunLocationTargetedMessageBuffer.MegaCrit.Sts2.Core.Runs.RunLocation get_CurrentLocation()
 0121: stfld field:MegaCrit.Sts2.Core.Runs.RunLocation location
 0126: ldarg.0 
 0127: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService _netService
 0132: ldloc.0 
 0133: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService.Void SendMessage[VotedForSharedEventOptionMessage](MegaCrit.Sts2.Core.Multiplayer.Messages.Game.Sync.VotedForSharedEventOptionMessage)
 0138: ret 
 0139: ldarg.0 
 0140: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0145: ldloca.s 1
 0147: ldc.i4.s 38
 0149: ldc.i4.1 
 0150: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0155: ldloca.s 1
 0157: ldstr str:Local player chose event option index 
 0162: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0167: ldloca.s 1
 0169: ldarg.1 
 0170: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Int32](Int32)
 0175: ldloca.s 1
 0177: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0182: ldc.i4.1 
 0183: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0188: ldarg.0 
 0189: ldarg.0 
 0190: call method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer.MegaCrit.Sts2.Core.Entities.Players.Player get_LocalPlayer()
 0195: ldarg.1 
 0196: call method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer.Void ChooseOptionForEvent(MegaCrit.Sts2.Core.Entities.Players.Player, Int32)
 0201: ldloca.s 2
 0203: initobj type:MegaCrit.Sts2.Core.Multiplayer.Messages.Game.Sync.OptionIndexChosenMessage
 0209: ldloca.s 2
 0211: ldc.i4.0 
 0212: stfld field:MegaCrit.Sts2.Core.Multiplayer.Messages.Game.Sync.OptionIndexType type
 0217: ldloca.s 2
 0219: ldarg.1 
 0220: stfld field:UInt32 optionIndex
 0225: ldloca.s 2
 0227: ldarg.0 
 0228: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.RunLocationTargetedMessageBuffer _messageBuffer
 0233: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RunLocationTargetedMessageBuffer.MegaCrit.Sts2.Core.Runs.RunLocation get_CurrentLocation()
 0238: stfld field:MegaCrit.Sts2.Core.Runs.RunLocation location
 0243: ldarg.0 
 0244: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService _netService
 0249: ldloc.2 
 0250: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService.Void SendMessage[OptionIndexChosenMessage](MegaCrit.Sts2.Core.Multiplayer.Messages.Game.Sync.OptionIndexChosenMessage)
 0255: ret 
METHOD Void PlayerVotedForSharedOptionIndex(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32, UInt32)
 0000: ldarg.3 
 0001: ldarg.0 
 0002: ldfld field:UInt32 _pageIndex
 0007: bge.un 144
 0012: ldarg.0 
 0013: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0018: ldloca.s 1
 0020: ldc.i4.s 101
 0022: ldc.i4.4 
 0023: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0028: ldloca.s 1
 0030: ldstr str:Received message from player 
 0035: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0040: ldloca.s 1
 0042: ldarg.1 
 0043: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0048: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0053: ldloca.s 1
 0055: ldstr str: voting for option 
 0060: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0065: ldloca.s 1
 0067: ldarg.2 
 0068: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt32](UInt32)
 0073: ldloca.s 1
 0075: ldstr str: on page 
 0080: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0085: ldloca.s 1
 0087: ldarg.3 
 0088: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt32](UInt32)
 0093: ldloca.s 1
 0095: ldstr str:, but we are on greater page 
 0100: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0105: ldloca.s 1
 0107: ldarg.0 
 0108: ldfld field:UInt32 _pageIndex
 0113: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt32](UInt32)
 0118: ldloca.s 1
 0120: ldstr str:. Ignoring vote
 0125: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0130: ldloca.s 1
 0132: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0137: ldc.i4.1 
 0138: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Warn(System.String, Int32)
 0143: ret 
 0144: ldarg.3 
 0145: ldarg.0 
 0146: ldfld field:UInt32 _pageIndex
 0151: ble.un 288
 0156: ldarg.0 
 0157: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0162: ldloca.s 1
 0164: ldc.i4.s 101
 0166: ldc.i4.4 
 0167: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0172: ldloca.s 1
 0174: ldstr str:Received message from player 
 0179: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0184: ldloca.s 1
 0186: ldarg.1 
 0187: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0192: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0197: ldloca.s 1
 0199: ldstr str: voting for option 
 0204: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0209: ldloca.s 1
 0211: ldarg.2 
 0212: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt32](UInt32)
 0217: ldloca.s 1
 0219: ldstr str: on page 
 0224: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0229: ldloca.s 1
 0231: ldarg.3 
 0232: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt32](UInt32)
 0237: ldloca.s 1
 0239: ldstr str:, but we are on lesser page 
 0244: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0249: ldloca.s 1
 0251: ldarg.0 
 0252: ldfld field:UInt32 _pageIndex
 0257: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt32](UInt32)
 0262: ldloca.s 1
 0264: ldstr str:. This is a bug!
 0269: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0274: ldloca.s 1
 0276: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0281: ldc.i4.1 
 0282: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Error(System.String, Int32)
 0287: ret 
 0288: ldarg.0 
 0289: ldfld field:MegaCrit.Sts2.Core.Runs.IPlayerCollection _playerCollection
 0294: ldarg.1 
 0295: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.Int32 GetPlayerSlotIndex(MegaCrit.Sts2.Core.Entities.Players.Player)
 0300: stloc.0 
 0301: ldarg.0 
 0302: ldfld field:System.Collections.Generic.List`1[System.Nullable`1[System.UInt32]] _playerVotes
 0307: ldloc.0 
 0308: ldarg.2 
 0309: newobj method:System.Nullable`1[System.UInt32].Void .ctor(UInt32)
 0314: callvirt method:System.Collections.Generic.List`1[System.Nullable`1[System.UInt32]].Void set_Item(Int32, System.Nullable`1[System.UInt32])
 0319: ldarg.0 
 0320: ldfld field:System.Action`1[MegaCrit.Sts2.Core.Entities.Players.Player] PlayerVoteChanged
 0325: dup 
 0326: brtrue.s 331
 0328: pop 
 0329: br.s 337
 0331: ldarg.1 
 0332: callvirt method:System.Action`1[MegaCrit.Sts2.Core.Entities.Players.Player].Void Invoke(MegaCrit.Sts2.Core.Entities.Players.Player)
 0337: ldarg.0 
 0338: ldfld field:System.Collections.Generic.List`1[System.Nullable`1[System.UInt32]] _playerVotes
 0343: ldsfld field:System.Func`2[System.Nullable`1[System.UInt32],System.Boolean] <>9__25_0
 0348: dup 
 0349: brtrue.s 374
 0351: pop 
 0352: ldsfld field:<>c <>9
 0357: ldftn method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer+<>c.Boolean <PlayerVotedForSharedOptionIndex>b__25_0(System.Nullable`1[System.UInt32])
 0363: newobj method:System.Func`2[System.Nullable`1[System.UInt32],System.Boolean].Void .ctor(System.Object, IntPtr)
 0368: dup 
 0369: stsfld field:System.Func`2[System.Nullable`1[System.UInt32],System.Boolean] <>9__25_0
 0374: call method:System.Linq.Enumerable.Boolean All[Nullable`1](System.Collections.Generic.IEnumerable`1[System.Nullable`1[System.UInt32]], System.Func`2[System.Nullable`1[System.UInt32],System.Boolean])
 0379: brfalse.s 418
 0381: ldarg.0 
 0382: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService _netService
 0387: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService.MegaCrit.Sts2.Core.Multiplayer.Game.NetGameType get_Type()
 0392: ldc.i4.3 
 0393: beq.s 418
 0395: ldarg.0 
 0396: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0401: ldstr str:All votes received and we are host. Choosing shared event option
 0406: ldc.i4.1 
 0407: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0412: ldarg.0 
 0413: call method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer.Void ChooseSharedEventOption()
 0418: ret 
METHOD Void ChooseSharedEventOption()
 0000: ldarg.0 
 0001: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService _netService
 0006: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService.MegaCrit.Sts2.Core.Multiplayer.Game.NetGameType get_Type()
 0011: ldc.i4.3 
 0012: bne.un.s 25
 0014: ldstr str:Only host should be choosing shared event option!
 0019: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0024: throw 
 0025: ldarg.0 
 0026: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0031: ldloca.s 2
 0033: ldc.i4.s 61
 0035: ldc.i4.1 
 0036: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0041: ldloca.s 2
 0043: ldstr str:All votes received on host for shared event 
 0048: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0053: ldloca.s 2
 0055: ldarg.0 
 0056: ldfld field:MegaCrit.Sts2.Core.Models.EventModel _canonicalEvent
 0061: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[EventModel](MegaCrit.Sts2.Core.Models.EventModel)
 0066: ldloca.s 2
 0068: ldstr str:, choosing option
 0073: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0078: ldloca.s 2
 0080: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0085: ldc.i4.1 
 0086: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0091: ldarg.0 
 0092: ldfld field:MegaCrit.Sts2.Core.Random.Rng _multiplayerOptionSelectionRng
 0097: ldarg.0 
 0098: ldfld field:System.Collections.Generic.List`1[System.Nullable`1[System.UInt32]] _playerVotes
 0103: callvirt method:MegaCrit.Sts2.Core.Random.Rng.System.Nullable`1[System.UInt32] NextItem[Nullable`1](System.Collections.Generic.IEnumerable`1[System.Nullable`1[System.UInt32]])
 0108: stloc.3 
 0109: ldloca.s 3
 0111: call method:System.Nullable`1[System.UInt32].UInt32 get_Value()
 0116: stloc.0 
 0117: ldarg.0 
 0118: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0123: ldloca.s 2
 0125: ldc.i4.s 31
 0127: ldc.i4.1 
 0128: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0133: ldloca.s 2
 0135: ldstr str:Shared event option 
 0140: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0145: ldloca.s 2
 0147: ldloc.0 
 0148: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt32](UInt32)
 0153: ldloca.s 2
 0155: ldstr str: was chosen
 0160: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0165: ldloca.s 2
 0167: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0172: ldc.i4.1 
 0173: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0178: ldloca.s 4
 0180: initobj type:MegaCrit.Sts2.Core.Multiplayer.Messages.Game.Sync.SharedEventOptionChosenMessage
 0186: ldloca.s 4
 0188: ldloc.0 
 0189: stfld field:UInt32 optionIndex
 0194: ldloca.s 4
 0196: ldarg.0 
 0197: ldfld field:UInt32 _pageIndex
 0202: stfld field:UInt32 pageIndex
 0207: ldloca.s 4
 0209: ldarg.0 
 0210: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.RunLocationTargetedMessageBuffer _messageBuffer
 0215: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RunLocationTargetedMessageBuffer.MegaCrit.Sts2.Core.Runs.RunLocation get_CurrentLocation()
 0220: stfld field:MegaCrit.Sts2.Core.Runs.RunLocation location
 0225: ldloc.s 4
 0227: stloc.1 
 0228: ldarg.0 
 0229: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService _netService
 0234: ldloc.1 
 0235: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService.Void SendMessage[SharedEventOptionChosenMessage](MegaCrit.Sts2.Core.Multiplayer.Messages.Game.Sync.SharedEventOptionChosenMessage)
 0240: ldarg.0 
 0241: ldloc.0 
 0242: call method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer.Void ChooseOptionForSharedEvent(UInt32)
 0247: ret 
METHOD Void ChooseOptionForSharedEvent(UInt32)
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer.Boolean get_IsShared()
 0006: brtrue.s 19
 0008: ldstr str:ChooseOptionForSharedEvent called during non-shared event!
 0013: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0018: throw 
 0019: ldarg.0 
 0020: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0025: ldloca.s 0
 0027: ldc.i4.s 48
 0029: ldc.i4.2 
 0030: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0035: ldloca.s 0
 0037: ldstr str:Choosing option index 
 0042: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0047: ldloca.s 0
 0049: ldarg.1 
 0050: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt32](UInt32)
 0055: ldloca.s 0
 0057: ldstr str: for shared event on page 
 0062: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0067: ldloca.s 0
 0069: ldarg.0 
 0070: ldfld field:UInt32 _pageIndex
 0075: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt32](UInt32)
 0080: ldloca.s 0
 0082: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0087: ldc.i4.1 
 0088: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0093: ldarg.0 
 0094: call method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer.Void ClearPlayerVotes()
 0099: ldarg.0 
 0100: ldarg.0 
 0101: ldfld field:UInt32 _pageIndex
 0106: ldc.i4.1 
 0107: add 
 0108: stfld field:UInt32 _pageIndex
 0113: ldarg.0 
 0114: ldfld field:MegaCrit.Sts2.Core.Runs.IPlayerCollection _playerCollection
 0119: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0124: callvirt method:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Players.Player].System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Entities.Players.Player] GetEnumerator()
 0129: stloc.1 
 0130: br.s 147
 0132: ldloc.1 
 0133: callvirt method:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Entities.Players.Player].MegaCrit.Sts2.Core.Entities.Players.Player get_Current()
 0138: stloc.2 
 0139: ldarg.0 
 0140: ldloc.2 
 0141: ldarg.1 
 0142: call method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer.Void ChooseOptionForEvent(MegaCrit.Sts2.Core.Entities.Players.Player, Int32)
 0147: ldloc.1 
 0148: callvirt method:System.Collections.IEnumerator.Boolean MoveNext()
 0153: brtrue.s 132
 0155: leave.s 167
 0157: ldloc.1 
 0158: brfalse.s 166
 0160: ldloc.1 
 0161: callvirt method:System.IDisposable.Void Dispose()
 0166: endfinally 
 0167: ret 
METHOD Void ChooseOptionForEvent(MegaCrit.Sts2.Core.Entities.Players.Player, Int32)
 0000: ldarg.0 
 0001: ldarg.1 
 0002: call method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer.MegaCrit.Sts2.Core.Models.EventModel GetEventForPlayer(MegaCrit.Sts2.Core.Entities.Players.Player)
 0007: stloc.0 
 0008: ldloc.0 
 0009: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.Boolean get_IsFinished()
 0014: brfalse.s 91
 0016: ldloca.s 2
 0018: ldc.i4.s 58
 0020: ldc.i4.2 
 0021: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0026: ldloca.s 2
 0028: ldstr str:Option chosen for player 
 0033: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0038: ldloca.s 2
 0040: ldarg.1 
 0041: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Player](MegaCrit.Sts2.Core.Entities.Players.Player)
 0046: ldloca.s 2
 0048: ldstr str: on 
 0053: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0058: ldloca.s 2
 0060: ldloc.0 
 0061: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[EventModel](MegaCrit.Sts2.Core.Models.EventModel)
 0066: ldloca.s 2
 0068: ldstr str:, but it is already finished!
 0073: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0078: ldloca.s 2
 0080: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0085: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0090: throw 
 0091: ldarg.2 
 0092: ldloc.0 
 0093: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Events.EventOption] get_CurrentOptions()
 0098: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Events.EventOption].Int32 get_Count()
 0103: blt 243
 0108: ldloca.s 2
 0110: ldc.i4.s 92
 0112: ldc.i4.4 
 0113: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0118: ldloca.s 2
 0120: ldstr str:Player 
 0125: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0130: ldloca.s 2
 0132: ldarg.1 
 0133: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0138: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0143: ldloca.s 2
 0145: ldstr str: attempted to choose option index 
 0150: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0155: ldloca.s 2
 0157: ldarg.2 
 0158: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Int32](Int32)
 0163: ldloca.s 2
 0165: ldstr str: in event 
 0170: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0175: ldloca.s 2
 0177: ldloc.0 
 0178: callvirt method:MegaCrit.Sts2.Core.Models.AbstractModel.MegaCrit.Sts2.Core.Models.ModelId get_Id()
 0183: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[ModelId](MegaCrit.Sts2.Core.Models.ModelId)
 0188: ldloca.s 2
 0190: ldstr str:, but there were only 
 0195: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0200: ldloca.s 2
 0202: ldloc.0 
 0203: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Events.EventOption] get_CurrentOptions()
 0208: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Events.EventOption].Int32 get_Count()
 0213: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Int32](Int32)
 0218: ldloca.s 2
 0220: ldstr str: options available!
 0225: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0230: ldloca.s 2
 0232: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0237: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0242: throw 
 0243: ldarg.0 
 0244: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0249: ldloca.s 2
 0251: ldc.i4.s 56
 0253: ldc.i4.4 
 0254: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0259: ldloca.s 2
 0261: ldstr str:Option index 
 0266: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0271: ldloca.s 2
 0273: ldarg.2 
 0274: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Int32](Int32)
 0279: ldloca.s 2
 0281: ldstr str: chosen for player 
 0286: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0291: ldloca.s 2
 0293: ldarg.1 
 0294: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0299: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0304: ldloca.s 2
 0306: ldstr str: in event 
 0311: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0316: ldloca.s 2
 0318: ldloc.0 
 0319: callvirt method:MegaCrit.Sts2.Core.Models.AbstractModel.MegaCrit.Sts2.Core.Models.ModelId get_Id()
 0324: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[ModelId](MegaCrit.Sts2.Core.Models.ModelId)
 0329: ldloca.s 2
 0331: ldstr str:. Choice key: 
 0336: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0341: ldloca.s 2
 0343: ldloc.0 
 0344: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Events.EventOption] get_CurrentOptions()
 0349: ldarg.2 
 0350: callvirt method:System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Events.EventOption].MegaCrit.Sts2.Core.Events.EventOption get_Item(Int32)
 0355: callvirt method:MegaCrit.Sts2.Core.Events.EventOption.System.String get_TextKey()
 0360: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted(System.String)
 0365: ldloca.s 2
 0367: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0372: ldc.i4.1 
 0373: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0378: ldloc.0 
 0379: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Events.EventOption] get_CurrentOptions()
 0384: ldarg.2 
 0385: callvirt method:System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Events.EventOption].MegaCrit.Sts2.Core.Events.EventOption get_Item(Int32)
 0390: stloc.1 
 0391: ldarg.0 
 0392: ldfld field:System.Collections.Generic.List`1[System.Threading.Tasks.Task] _pendingOptionTasks
 0397: ldloc.1 
 0398: callvirt method:MegaCrit.Sts2.Core.Events.EventOption.System.Threading.Tasks.Task Chosen()
 0403: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0408: callvirt method:System.Collections.Generic.List`1[System.Threading.Tasks.Task].Void Add(System.Threading.Tasks.Task)
 0413: ldarg.0 
 0414: ldarg.1 
 0415: ldloc.1 
 0416: call method:MegaCrit.Sts2.Core.Multiplayer.Game.EventSynchronizer.Void SaveEventOptionToHistory(MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.Events.EventOption)
 0421: ret 
