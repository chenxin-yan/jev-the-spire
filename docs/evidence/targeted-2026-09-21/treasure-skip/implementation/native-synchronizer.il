METHOD Void OnPicked(MegaCrit.Sts2.Core.Entities.Players.Player, System.Nullable`1[System.Int32])
 0000: ldarga.s 2
 0002: call method:System.Nullable`1[System.Int32].Boolean get_HasValue()
 0007: brfalse.s 124
 0009: ldarg.0 
 0010: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0015: ldloca.s 1
 0017: ldc.i4.s 32
 0019: ldc.i4.3 
 0020: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0025: ldloca.s 1
 0027: ldstr str:Player 
 0032: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0037: ldloca.s 1
 0039: ldarg.1 
 0040: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Player](MegaCrit.Sts2.Core.Entities.Players.Player)
 0045: ldloca.s 1
 0047: ldstr str: picked relic at index 
 0052: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0057: ldloca.s 1
 0059: ldarg.2 
 0060: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Nullable`1](System.Nullable`1[System.Int32])
 0065: ldloca.s 1
 0067: ldstr str:: 
 0072: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0077: ldloca.s 1
 0079: ldarg.0 
 0080: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel] _currentRelics
 0085: dup 
 0086: brtrue.s 92
 0088: pop 
 0089: ldnull 
 0090: br.s 104
 0092: ldarga.s 2
 0094: call method:System.Nullable`1[System.Int32].Int32 get_Value()
 0099: call method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel].MegaCrit.Sts2.Core.Models.RelicModel get_Item(Int32)
 0104: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[RelicModel](MegaCrit.Sts2.Core.Models.RelicModel)
 0109: ldloca.s 1
 0111: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0116: ldc.i4.1 
 0117: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0122: br.s 185
 0124: ldarg.0 
 0125: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0130: ldloca.s 1
 0132: ldc.i4.s 21
 0134: ldc.i4.1 
 0135: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0140: ldloca.s 1
 0142: ldstr str:Player 
 0147: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0152: ldloca.s 1
 0154: ldarg.1 
 0155: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Player](MegaCrit.Sts2.Core.Entities.Players.Player)
 0160: ldloca.s 1
 0162: ldstr str: skipped relic
 0167: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0172: ldloca.s 1
 0174: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0179: ldc.i4.1 
 0180: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0185: ldarg.0 
 0186: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel] _currentRelics
 0191: brtrue.s 211
 0193: ldarg.0 
 0194: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0199: ldstr str:Attempted to pick relic while relic picking is not active!
 0204: ldc.i4.1 
 0205: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Warn(System.String, Int32)
 0210: ret 
 0211: ldarg.2 
 0212: stloc.2 
 0213: ldarg.0 
 0214: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel] _currentRelics
 0219: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel].Int32 get_Count()
 0224: stloc.3 
 0225: ldloca.s 2
 0227: call method:System.Nullable`1[System.Int32].Int32 GetValueOrDefault()
 0232: ldloc.3 
 0233: clt 
 0235: ldc.i4.0 
 0236: ceq 
 0238: ldloca.s 2
 0240: call method:System.Nullable`1[System.Int32].Boolean get_HasValue()
 0245: and 
 0246: brfalse.s 333
 0248: ldloca.s 1
 0250: ldc.i4.s 70
 0252: ldc.i4.2 
 0253: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0258: ldloca.s 1
 0260: ldstr str:Attempted to pick relic at index 
 0265: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0270: ldloca.s 1
 0272: ldarg.2 
 0273: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Nullable`1](System.Nullable`1[System.Int32])
 0278: ldloca.s 1
 0280: ldstr str:, but there are only 
 0285: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0290: ldloca.s 1
 0292: ldarg.0 
 0293: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel] _currentRelics
 0298: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel].Int32 get_Count()
 0303: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Int32](Int32)
 0308: ldloca.s 1
 0310: ldstr str: to choose from!
 0315: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0320: ldloca.s 1
 0322: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0327: newobj method:System.IndexOutOfRangeException.Void .ctor(System.String)
 0332: throw 
 0333: ldarga.s 2
 0335: call method:System.Nullable`1[System.Int32].Boolean get_HasValue()
 0340: brtrue.s 369
 0342: ldarg.0 
 0343: ldfld field:MegaCrit.Sts2.Core.Runs.IPlayerCollection _playerCollection
 0348: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0353: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Entities.Players.Player].Int32 get_Count()
 0358: ldc.i4.1 
 0359: bne.un.s 369
 0361: ldarg.0 
 0362: ldc.i4.1 
 0363: stfld field:Boolean _singleplayerSkipped
 0368: ret 
 0369: ldarg.0 
 0370: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote] _votes
 0375: ldarg.0 
 0376: ldfld field:MegaCrit.Sts2.Core.Runs.IPlayerCollection _playerCollection
 0381: ldarg.1 
 0382: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.Int32 GetPlayerSlotIndex(MegaCrit.Sts2.Core.Entities.Players.Player)
 0387: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote].PlayerVote get_Item(Int32)
 0392: stloc.0 
 0393: ldloc.0 
 0394: ldarg.2 
 0395: stfld field:System.Nullable`1[System.Int32] index
 0400: ldloc.0 
 0401: ldc.i4.1 
 0402: stfld field:Boolean voteReceived
 0407: ldarg.0 
 0408: ldfld field:System.Action VotesChanged
 0413: dup 
 0414: brtrue.s 419
 0416: pop 
 0417: br.s 424
 0419: callvirt method:System.Action.Void Invoke()
 0424: ldarg.0 
 0425: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote] _votes
 0430: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote,System.Boolean] <>9__25_0
 0435: dup 
 0436: brtrue.s 461
 0438: pop 
 0439: ldsfld field:<>c <>9
 0444: ldftn method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+<>c.Boolean <OnPicked>b__25_0(PlayerVote)
 0450: newobj method:System.Func`2[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote,System.Boolean].Void .ctor(System.Object, IntPtr)
 0455: dup 
 0456: stsfld field:System.Func`2[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote,System.Boolean] <>9__25_0
 0461: call method:System.Linq.Enumerable.Boolean All[PlayerVote](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote], System.Func`2[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote,System.Boolean])
 0466: brfalse 601
 0471: ldarg.0 
 0472: ldfld field:PlayerVote _predictedVote
 0477: brfalse.s 589
 0479: ldarg.0 
 0480: ldfld field:PlayerVote _predictedVote
 0485: stloc.s 4
 0487: ldarg.0 
 0488: ldnull 
 0489: stfld field:PlayerVote _predictedVote
 0494: ldarg.0 
 0495: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote] _votes
 0500: ldarg.0 
 0501: ldfld field:MegaCrit.Sts2.Core.Runs.IPlayerCollection _playerCollection
 0506: ldarg.0 
 0507: call method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.MegaCrit.Sts2.Core.Entities.Players.Player get_LocalPlayer()
 0512: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.Int32 GetPlayerSlotIndex(MegaCrit.Sts2.Core.Entities.Players.Player)
 0517: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote].PlayerVote get_Item(Int32)
 0522: ldfld field:System.Nullable`1[System.Int32] index
 0527: stloc.2 
 0528: ldloc.s 4
 0530: ldfld field:System.Nullable`1[System.Int32] index
 0535: stloc.s 5
 0537: ldloca.s 2
 0539: call method:System.Nullable`1[System.Int32].Int32 GetValueOrDefault()
 0544: ldloca.s 5
 0546: call method:System.Nullable`1[System.Int32].Int32 GetValueOrDefault()
 0551: ceq 
 0553: ldloca.s 2
 0555: call method:System.Nullable`1[System.Int32].Boolean get_HasValue()
 0560: ldloca.s 5
 0562: call method:System.Nullable`1[System.Int32].Boolean get_HasValue()
 0567: ceq 
 0569: and 
 0570: brtrue.s 589
 0572: ldarg.0 
 0573: ldfld field:System.Action VotesChanged
 0578: dup 
 0579: brtrue.s 584
 0581: pop 
 0582: br.s 589
 0584: callvirt method:System.Action.Void Invoke()
 0589: ldarg.0 
 0590: call method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.Void AwardRelics()
 0595: ldarg.0 
 0596: call method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.Void EndRelicVoting()
 0601: ret 
METHOD Void PickRelicLocally(System.Nullable`1[System.Int32])
 0000: ldarga.s 1
 0002: call method:System.Nullable`1[System.Int32].Boolean get_HasValue()
 0007: brfalse.s 134
 0009: ldarg.0 
 0010: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0015: ldloca.s 0
 0017: ldc.i4.s 48
 0019: ldc.i4.3 
 0020: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0025: ldloca.s 0
 0027: ldstr str:Relic index 
 0032: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0037: ldloca.s 0
 0039: ldarg.1 
 0040: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Nullable`1](System.Nullable`1[System.Int32])
 0045: ldloca.s 0
 0047: ldstr str: (
 0052: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0057: ldloca.s 0
 0059: ldarg.0 
 0060: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel] _currentRelics
 0065: dup 
 0066: brtrue.s 72
 0068: pop 
 0069: ldnull 
 0070: br.s 84
 0072: ldarga.s 1
 0074: call method:System.Nullable`1[System.Int32].Int32 get_Value()
 0079: call method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel].MegaCrit.Sts2.Core.Models.RelicModel get_Item(Int32)
 0084: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[RelicModel](MegaCrit.Sts2.Core.Models.RelicModel)
 0089: ldloca.s 0
 0091: ldstr str:) is being picked by local player 
 0096: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0101: ldloca.s 0
 0103: ldarg.0 
 0104: call method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.MegaCrit.Sts2.Core.Entities.Players.Player get_LocalPlayer()
 0109: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0114: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0119: ldloca.s 0
 0121: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0126: ldc.i4.1 
 0127: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0132: br.s 193
 0134: ldarg.0 
 0135: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0140: ldloca.s 0
 0142: ldc.i4.s 39
 0144: ldc.i4.1 
 0145: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0150: ldloca.s 0
 0152: ldstr str:Relic has been skipped by local player 
 0157: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0162: ldloca.s 0
 0164: ldarg.0 
 0165: call method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.MegaCrit.Sts2.Core.Entities.Players.Player get_LocalPlayer()
 0170: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0175: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0180: ldloca.s 0
 0182: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0187: ldc.i4.1 
 0188: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0193: ldarg.0 
 0194: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel] _currentRelics
 0199: brtrue.s 219
 0201: ldarg.0 
 0202: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0207: ldstr str:Attempted to pick relic while relic picking is not active!
 0212: ldc.i4.1 
 0213: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Warn(System.String, Int32)
 0218: ret 
 0219: ldarg.0 
 0220: newobj method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote.Void .ctor()
 0225: dup 
 0226: ldarg.1 
 0227: stfld field:System.Nullable`1[System.Int32] index
 0232: dup 
 0233: ldc.i4.1 
 0234: stfld field:Boolean voteReceived
 0239: stfld field:PlayerVote _predictedVote
 0244: ldarg.0 
 0245: ldfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSynchronizer _actionQueueSynchronizer
 0250: ldarg.0 
 0251: call method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.MegaCrit.Sts2.Core.Entities.Players.Player get_LocalPlayer()
 0256: ldarg.1 
 0257: newobj method:MegaCrit.Sts2.Core.GameActions.PickRelicAction.Void .ctor(MegaCrit.Sts2.Core.Entities.Players.Player, System.Nullable`1[System.Int32])
 0262: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.ActionQueueSynchronizer.Void RequestEnqueue(MegaCrit.Sts2.Core.GameActions.GameAction)
 0267: ldarg.0 
 0268: ldfld field:System.Action VotesChanged
 0273: dup 
 0274: brtrue.s 278
 0276: pop 
 0277: ret 
 0278: callvirt method:System.Action.Void Invoke()
 0283: ret 
METHOD Void SkipRelicLocally()
 0000: ldarg.0 
 0001: ldloca.s 0
 0003: initobj type:System.Nullable`1[System.Int32]
 0009: ldloc.0 
 0010: call method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.Void PickRelicLocally(System.Nullable`1[System.Int32])
 0015: ret 
METHOD Void OnRoomExited()
 0000: ldarg.0 
 0001: ldfld field:Boolean _singleplayerSkipped
 0006: brfalse.s 14
 0008: ldarg.0 
 0009: call method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.Void EndRelicVoting()
 0014: ret 
METHOD Void EndRelicVoting()
 0000: ldarg.0 
 0001: ldnull 
 0002: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel] _currentRelics
 0007: ldarg.0 
 0008: ldc.i4.0 
 0009: stfld field:Boolean _singleplayerSkipped
 0014: ret 
METHOD Void BeginRelicPicking()
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.RelicModel] get_CurrentRelics()
 0006: brfalse.s 19
 0008: ldstr str:Attempted to start new relic picking session while one was already occurring!
 0013: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0018: throw 
 0019: ldarg.0 
 0020: newobj method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel].Void .ctor()
 0025: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel] _currentRelics
 0030: ldarg.0 
 0031: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote] _votes
 0036: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote].Void Clear()
 0041: ldarg.0 
 0042: ldnull 
 0043: stfld field:PlayerVote _predictedVote
 0048: ldarg.0 
 0049: ldfld field:MegaCrit.Sts2.Core.Runs.IPlayerCollection _playerCollection
 0054: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0059: callvirt method:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Players.Player].System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Entities.Players.Player] GetEnumerator()
 0064: stloc.0 
 0065: br.s 173
 0067: ldloc.0 
 0068: callvirt method:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Entities.Players.Player].MegaCrit.Sts2.Core.Entities.Players.Player get_Current()
 0073: stloc.1 
 0074: ldarg.0 
 0075: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote] _votes
 0080: newobj method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote.Void .ctor()
 0085: dup 
 0086: ldc.i4.0 
 0087: stfld field:Boolean voteReceived
 0092: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote].Void Add(PlayerVote)
 0097: ldloc.1 
 0098: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0103: stloc.2 
 0104: ldloc.2 
 0105: ldloc.1 
 0106: call method:MegaCrit.Sts2.Core.Hooks.Hook.Boolean ShouldGenerateTreasure(MegaCrit.Sts2.Core.Runs.IRunState, MegaCrit.Sts2.Core.Entities.Players.Player)
 0111: brfalse.s 173
 0113: ldarg.0 
 0114: ldfld field:MegaCrit.Sts2.Core.Random.Rng _rng
 0119: call method:MegaCrit.Sts2.Core.Factories.RelicFactory.MegaCrit.Sts2.Core.Entities.Relics.RelicRarity RollRarity(MegaCrit.Sts2.Core.Random.Rng)
 0124: stloc.3 
 0125: ldarg.0 
 0126: ldloc.1 
 0127: call method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.MegaCrit.Sts2.Core.Models.RelicModel TryGetRelicForTutorial(MegaCrit.Sts2.Core.Entities.Players.Player)
 0132: dup 
 0133: brtrue.s 158
 0135: pop 
 0136: ldarg.0 
 0137: ldfld field:MegaCrit.Sts2.Core.Runs.RelicGrabBag _sharedGrabBag
 0142: ldloc.3 
 0143: ldloc.2 
 0144: callvirt method:MegaCrit.Sts2.Core.Runs.RelicGrabBag.MegaCrit.Sts2.Core.Models.RelicModel PullFromFront(MegaCrit.Sts2.Core.Entities.Relics.RelicRarity, MegaCrit.Sts2.Core.Runs.IRunState)
 0149: dup 
 0150: brtrue.s 158
 0152: pop 
 0153: call method:MegaCrit.Sts2.Core.Factories.RelicFactory.MegaCrit.Sts2.Core.Models.RelicModel get_FallbackRelic()
 0158: stloc.s 4
 0160: ldarg.0 
 0161: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel] _currentRelics
 0166: ldloc.s 4
 0168: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel].Void Add(MegaCrit.Sts2.Core.Models.RelicModel)
 0173: ldloc.0 
 0174: callvirt method:System.Collections.IEnumerator.Boolean MoveNext()
 0179: brtrue.s 67
 0181: leave.s 193
 0183: ldloc.0 
 0184: brfalse.s 192
 0186: ldloc.0 
 0187: callvirt method:System.IDisposable.Void Dispose()
 0192: endfinally 
 0193: ldarg.0 
 0194: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel] _currentRelics
 0199: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel].Int32 get_Count()
 0204: ldc.i4.0 
 0205: ble 394
 0210: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0215: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.Boolean get_IsSingleplayerOrFakeMultiplayer()
 0220: brfalse 377
 0225: ldarg.0 
 0226: ldfld field:MegaCrit.Sts2.Core.Runs.IPlayerCollection _playerCollection
 0231: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0236: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Entities.Players.Player].Int32 get_Count()
 0241: ldc.i4.1 
 0242: ble 377
 0247: ldarg.0 
 0248: ldfld field:MegaCrit.Sts2.Core.Runs.IPlayerCollection _playerCollection
 0253: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0258: callvirt method:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Players.Player].System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Entities.Players.Player] GetEnumerator()
 0263: stloc.s 5
 0265: br.s 354
 0267: ldloc.s 5
 0269: callvirt method:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Entities.Players.Player].MegaCrit.Sts2.Core.Entities.Players.Player get_Current()
 0274: stloc.s 6
 0276: ldloc.s 6
 0278: ldarg.0 
 0279: call method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.MegaCrit.Sts2.Core.Entities.Players.Player get_LocalPlayer()
 0284: beq.s 354
 0286: ldarg.0 
 0287: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote] _votes
 0292: ldarg.0 
 0293: ldfld field:MegaCrit.Sts2.Core.Runs.IPlayerCollection _playerCollection
 0298: ldloc.s 6
 0300: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.Int32 GetPlayerSlotIndex(MegaCrit.Sts2.Core.Entities.Players.Player)
 0305: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer+PlayerVote].PlayerVote get_Item(Int32)
 0310: stloc.s 7
 0312: ldloc.s 7
 0314: ldarg.0 
 0315: ldfld field:MegaCrit.Sts2.Core.Random.Rng _rng
 0320: ldarg.0 
 0321: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel] _currentRelics
 0326: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.RelicModel].Int32 get_Count()
 0331: callvirt method:MegaCrit.Sts2.Core.Random.Rng.Int32 NextInt(Int32)
 0336: newobj method:System.Nullable`1[System.Int32].Void .ctor(Int32)
 0341: stfld field:System.Nullable`1[System.Int32] index
 0346: ldloc.s 7
 0348: ldc.i4.1 
 0349: stfld field:Boolean voteReceived
 0354: ldloc.s 5
 0356: callvirt method:System.Collections.IEnumerator.Boolean MoveNext()
 0361: brtrue.s 267
 0363: leave.s 377
 0365: ldloc.s 5
 0367: brfalse.s 376
 0369: ldloc.s 5
 0371: callvirt method:System.IDisposable.Void Dispose()
 0376: endfinally 
 0377: ldarg.0 
 0378: ldfld field:System.Action VotesChanged
 0383: dup 
 0384: brtrue.s 388
 0386: pop 
 0387: ret 
 0388: callvirt method:System.Action.Void Invoke()
 0393: ret 
 0394: ldarg.0 
 0395: call method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.Void EndRelicVoting()
 0400: ret 
