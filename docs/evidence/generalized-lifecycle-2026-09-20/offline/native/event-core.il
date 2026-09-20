METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Models.EventModel <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse 181
 0020: ldloc.1 
 0021: call method:MegaCrit.Sts2.Core.Models.AbstractModel.Void AssertMutable()
 0026: ldloc.1 
 0027: call method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0032: brfalse.s 45
 0034: ldstr str:Tried to begin event, but it already has an owner!
 0039: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0044: throw 
 0045: ldloc.1 
 0046: ldarg.0 
 0047: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0052: call method:MegaCrit.Sts2.Core.Models.EventModel.Void set_Owner(MegaCrit.Sts2.Core.Entities.Players.Player)
 0057: ldloc.1 
 0058: ldloc.1 
 0059: call method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0064: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0069: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.MegaCrit.Sts2.Core.Runs.RunRngSet get_Rng()
 0074: callvirt method:MegaCrit.Sts2.Core.Runs.RunRngSet.UInt64 get_Seed()
 0079: ldloc.1 
 0080: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.Boolean get_IsShared()
 0085: brtrue.s 112
 0087: ldloc.1 
 0088: call method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0093: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0098: ldloc.1 
 0099: call method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0104: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.Int32 GetPlayerSlotIndex(MegaCrit.Sts2.Core.Entities.Players.Player)
 0109: conv.i8 
 0110: br.s 114
 0112: ldc.i4.0 
 0113: conv.i8 
 0114: add 
 0115: ldloc.1 
 0116: call method:MegaCrit.Sts2.Core.Models.AbstractModel.MegaCrit.Sts2.Core.Models.ModelId get_Id()
 0121: callvirt method:MegaCrit.Sts2.Core.Models.ModelId.System.String get_Entry()
 0126: call method:MegaCrit.Sts2.Core.Helpers.StringHelper.UInt64 GetDeterministicHashCode(System.String)
 0131: add 
 0132: newobj method:MegaCrit.Sts2.Core.Random.Rng.Void .ctor(UInt64)
 0137: call method:MegaCrit.Sts2.Core.Models.EventModel.Void set_Rng(MegaCrit.Sts2.Core.Random.Rng)
 0142: ldloc.1 
 0143: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Models.EncounterModel get_CanonicalEncounter()
 0148: brfalse.s 169
 0150: ldarg.0 
 0151: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.EventCombatSynchronizer combatSynchronizer
 0156: brtrue.s 169
 0158: ldstr str:Combat synchronizer must be passed to events that may transition to combat!
 0163: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0168: throw 
 0169: ldloc.1 
 0170: ldarg.0 
 0171: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.EventCombatSynchronizer combatSynchronizer
 0176: stfld field:MegaCrit.Sts2.Core.Multiplayer.Game.EventCombatSynchronizer _combatSynchronizer
 0181: nop 
 0182: ldloc.0 
 0183: brfalse.s 247
 0185: ldloc.1 
 0186: ldarg.0 
 0187: ldfld field:Boolean isPreFinished
 0192: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.System.Threading.Tasks.Task BeforeEventStarted(Boolean)
 0197: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0202: stloc.2 
 0203: ldloca.s 2
 0205: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0210: brtrue.s 275
 0212: ldarg.0 
 0213: ldc.i4.0 
 0214: dup 
 0215: stloc.0 
 0216: stfld field:Int32 <>1__state
 0221: ldarg.0 
 0222: ldloc.2 
 0223: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0228: ldarg.0 
 0229: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0234: ldloca.s 2
 0236: ldarg.0 
 0237: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<BeginEvent>d__28](System.Runtime.CompilerServices.TaskAwaiter ByRef, <BeginEvent>d__28 ByRef)
 0242: leave 403
 0247: ldarg.0 
 0248: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0253: stloc.2 
 0254: ldarg.0 
 0255: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0260: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0266: ldarg.0 
 0267: ldc.i4.m1 
 0268: dup 
 0269: stloc.0 
 0270: stfld field:Int32 <>1__state
 0275: ldloca.s 2
 0277: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0282: ldloc.1 
 0283: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.Void CalculateVars()
 0288: ldarg.0 
 0289: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0294: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Entities.Creatures.Creature get_Creature()
 0299: callvirt method:MegaCrit.Sts2.Core.Entities.Creatures.Creature.Boolean get_IsDead()
 0304: brfalse.s 336
 0306: ldstr str:The generic event death message should not appear!
 0311: ldc.i4.2 
 0312: call method:MegaCrit.Sts2.Core.Logging.Log.Void Error(System.String, Int32)
 0317: ldloc.1 
 0318: ldloc.1 
 0319: ldstr str:GENERIC.youAreDead.description
 0324: call method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Localization.LocString L10NLookup(System.String)
 0329: call method:MegaCrit.Sts2.Core.Models.EventModel.Void SetEventFinished(MegaCrit.Sts2.Core.Localization.LocString)
 0334: br.s 348
 0336: ldloc.1 
 0337: ldarg.0 
 0338: ldfld field:Boolean isPreFinished
 0343: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.Void SetInitialEventState(Boolean)
 0348: leave.s 359
 0350: pop 
 0351: ldloc.1 
 0352: call method:MegaCrit.Sts2.Core.Models.EventModel.Void EnsureCleanup()
 0357: rethrow 
 0359: leave.s 384
 0361: stloc.3 
 0362: ldarg.0 
 0363: ldc.i4.s -2
 0365: stfld field:Int32 <>1__state
 0370: ldarg.0 
 0371: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0376: ldloc.3 
 0377: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0382: leave.s 403
 0384: ldarg.0 
 0385: ldc.i4.s -2
 0387: stfld field:Int32 <>1__state
 0392: ldarg.0 
 0393: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0398: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0403: ret 
METHOD Void EnterCombatWithoutExitingEvent(MegaCrit.Sts2.Core.Models.EncounterModel, System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Rewards.Reward], Boolean)
 0000: ldarg.0 
 0001: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.Boolean get_IsShared()
 0006: brtrue.s 63
 0008: ldloca.s 0
 0010: ldc.i4.s 43
 0012: ldc.i4.1 
 0013: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0018: ldloca.s 0
 0020: ldstr str:Tried to enter combat in non-shared event 
 0025: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0030: ldloca.s 0
 0032: ldarg.0 
 0033: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[EventModel](MegaCrit.Sts2.Core.Models.EventModel)
 0038: ldloca.s 0
 0040: ldstr str:!
 0045: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0050: ldloca.s 0
 0052: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0057: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0062: throw 
 0063: ldarg.3 
 0064: brfalse.s 145
 0066: ldarg.0 
 0067: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Events.EventLayoutType get_LayoutType()
 0072: ldc.i4.1 
 0073: bne.un.s 145
 0075: ldloca.s 0
 0077: ldc.i4.s 67
 0079: ldc.i4.1 
 0080: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0085: ldloca.s 0
 0087: ldstr str:Cannot resume event 
 0092: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0097: ldloca.s 0
 0099: ldarg.0 
 0100: call method:MegaCrit.Sts2.Core.Models.AbstractModel.MegaCrit.Sts2.Core.Models.ModelId get_Id()
 0105: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[ModelId](MegaCrit.Sts2.Core.Models.ModelId)
 0110: ldloca.s 0
 0112: ldstr str: after combat because it has a Combat layout — 
 0117: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0122: ldloca.s 0
 0124: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0129: ldstr str:there is no event layout to return to.
 0134: call method:System.String.System.String Concat(System.String, System.String)
 0139: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0144: throw 
 0145: ldarg.0 
 0146: ldfld field:System.Action EnteringEventCombat
 0151: dup 
 0152: brtrue.s 157
 0154: pop 
 0155: br.s 162
 0157: callvirt method:System.Action.Void Invoke()
 0162: ldarg.0 
 0163: call method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0168: call method:MegaCrit.Sts2.Core.Context.LocalContext.Boolean IsMe(MegaCrit.Sts2.Core.Entities.Players.Player)
 0173: brfalse.s 182
 0175: ldarg.0 
 0176: ldnull 
 0177: call method:MegaCrit.Sts2.Core.Models.EventModel.Void set_Node(Godot.Control)
 0182: ldarg.0 
 0183: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.EventCombatSynchronizer _combatSynchronizer
 0188: ldarg.1 
 0189: ldarg.0 
 0190: call method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0195: ldarg.2 
 0196: ldarg.3 
 0197: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.EventCombatSynchronizer.Void ReadyToEnterCombat(MegaCrit.Sts2.Core.Models.EncounterModel, MegaCrit.Sts2.Core.Entities.Players.Player, System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Rewards.Reward], Boolean)
 0202: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Models.EventModel <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse.s 113
 0017: ldloc.0 
 0018: ldc.i4.1 
 0019: beq 217
 0024: ldarg.0 
 0025: newobj method:MegaCrit.Sts2.Core.Models.EventModel+<>c__DisplayClass113_0.Void .ctor()
 0030: stfld field:<>c__DisplayClass113_0 <>8__1
 0035: newobj method:MegaCrit.Sts2.Core.GameActions.Multiplayer.BlockingPlayerChoiceContext.Void .ctor()
 0040: ldarg.0 
 0041: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult] cards
 0046: ldloc.1 
 0047: call method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0052: ldarg.0 
 0053: ldfld field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0058: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] FromSimpleGridForRewards(MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext, System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult], MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs)
 0063: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0068: stloc.3 
 0069: ldloca.s 3
 0071: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0076: brtrue.s 141
 0078: ldarg.0 
 0079: ldc.i4.0 
 0080: dup 
 0081: stloc.0 
 0082: stfld field:Int32 <>1__state
 0087: ldarg.0 
 0088: ldloc.3 
 0089: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0094: ldarg.0 
 0095: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0100: ldloca.s 3
 0102: ldarg.0 
 0103: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<SelectCardsToAddToDeckFromGrid>d__113](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <SelectCardsToAddToDeckFromGrid>d__113 ByRef)
 0108: leave 587
 0113: ldarg.0 
 0114: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0119: stloc.3 
 0120: ldarg.0 
 0121: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0126: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0132: ldarg.0 
 0133: ldc.i4.m1 
 0134: dup 
 0135: stloc.0 
 0136: stfld field:Int32 <>1__state
 0141: ldloca.s 3
 0143: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0148: stloc.2 
 0149: ldarg.0 
 0150: ldfld field:<>c__DisplayClass113_0 <>8__1
 0155: ldloc.2 
 0156: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] selectedCards
 0161: ldarg.0 
 0162: ldarg.0 
 0163: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult] cards
 0168: ldarg.0 
 0169: ldfld field:<>c__DisplayClass113_0 <>8__1
 0174: ldftn method:MegaCrit.Sts2.Core.Models.EventModel+<>c__DisplayClass113_0.Boolean <SelectCardsToAddToDeckFromGrid>b__0(MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult)
 0180: newobj method:System.Func`2[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult,System.Boolean].Void .ctor(System.Object, IntPtr)
 0185: call method:System.Linq.Enumerable.System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult] Where[CardCreationResult](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult], System.Func`2[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult,System.Boolean])
 0190: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult] <unselectedCards>5__2
 0195: ldarg.0 
 0196: ldarg.0 
 0197: ldfld field:<>c__DisplayClass113_0 <>8__1
 0202: ldfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] selectedCards
 0207: callvirt method:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel].System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Models.CardModel] GetEnumerator()
 0212: stfld field:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Models.CardModel] <>7__wrap2
 0217: nop 
 0218: ldloc.0 
 0219: ldc.i4.1 
 0220: beq.s 303
 0222: br 358
 0227: ldarg.0 
 0228: ldfld field:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Models.CardModel] <>7__wrap2
 0233: callvirt method:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Models.CardModel].MegaCrit.Sts2.Core.Models.CardModel get_Current()
 0238: stloc.s 4
 0240: ldloc.s 4
 0242: ldc.i4.6 
 0243: ldc.i4.1 
 0244: ldnull 
 0245: ldc.i4.0 
 0246: call method:MegaCrit.Sts2.Core.Commands.CardPileCmd.System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.Entities.Cards.CardPileAddResult] Add(MegaCrit.Sts2.Core.Models.CardModel, MegaCrit.Sts2.Core.Entities.Cards.PileType, MegaCrit.Sts2.Core.Entities.Cards.CardPilePosition, MegaCrit.Sts2.Core.Models.AbstractModel, Boolean)
 0251: callvirt method:System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.Entities.Cards.CardPileAddResult].System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.Entities.Cards.CardPileAddResult] GetAwaiter()
 0256: stloc.s 7
 0258: ldloca.s 7
 0260: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.Entities.Cards.CardPileAddResult].Boolean get_IsCompleted()
 0265: brtrue.s 332
 0267: ldarg.0 
 0268: ldc.i4.1 
 0269: dup 
 0270: stloc.0 
 0271: stfld field:Int32 <>1__state
 0276: ldarg.0 
 0277: ldloc.s 7
 0279: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.Entities.Cards.CardPileAddResult] <>u__2
 0284: ldarg.0 
 0285: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0290: ldloca.s 7
 0292: ldarg.0 
 0293: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<SelectCardsToAddToDeckFromGrid>d__113](System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.Entities.Cards.CardPileAddResult] ByRef, <SelectCardsToAddToDeckFromGrid>d__113 ByRef)
 0298: leave 587
 0303: ldarg.0 
 0304: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.Entities.Cards.CardPileAddResult] <>u__2
 0309: stloc.s 7
 0311: ldarg.0 
 0312: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.Entities.Cards.CardPileAddResult] <>u__2
 0317: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.Entities.Cards.CardPileAddResult]
 0323: ldarg.0 
 0324: ldc.i4.m1 
 0325: dup 
 0326: stloc.0 
 0327: stfld field:Int32 <>1__state
 0332: ldloca.s 7
 0334: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.Entities.Cards.CardPileAddResult].MegaCrit.Sts2.Core.Entities.Cards.CardPileAddResult GetResult()
 0339: stloc.s 6
 0341: ldloc.s 6
 0343: stloc.s 5
 0345: ldloc.s 5
 0347: ldc.r4 1.2
 0352: ldc.i4.1 
 0353: call method:MegaCrit.Sts2.Core.Commands.CardCmd.Void PreviewCardPileAdd(MegaCrit.Sts2.Core.Entities.Cards.CardPileAddResult, Single, MegaCrit.Sts2.Core.Nodes.CommonUi.CardPreviewStyle)
 0358: ldarg.0 
 0359: ldfld field:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Models.CardModel] <>7__wrap2
 0364: callvirt method:System.Collections.IEnumerator.Boolean MoveNext()
 0369: brtrue 227
 0374: leave.s 400
 0376: ldloc.0 
 0377: ldc.i4.0 
 0378: bge.s 399
 0380: ldarg.0 
 0381: ldfld field:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Models.CardModel] <>7__wrap2
 0386: brfalse.s 399
 0388: ldarg.0 
 0389: ldfld field:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Models.CardModel] <>7__wrap2
 0394: callvirt method:System.IDisposable.Void Dispose()
 0399: endfinally 
 0400: ldarg.0 
 0401: ldnull 
 0402: stfld field:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Models.CardModel] <>7__wrap2
 0407: ldarg.0 
 0408: ldfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult] <unselectedCards>5__2
 0413: callvirt method:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult].System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult] GetEnumerator()
 0418: stloc.s 8
 0420: br.s 486
 0422: ldloc.s 8
 0424: callvirt method:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult].MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult get_Current()
 0429: stloc.s 9
 0431: ldloc.1 
 0432: call method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0437: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0442: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.MegaCrit.Sts2.Core.Runs.History.MapPointHistoryEntry get_CurrentMapPointHistoryEntry()
 0447: ldloc.1 
 0448: call method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0453: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0458: callvirt method:MegaCrit.Sts2.Core.Runs.History.MapPointHistoryEntry.MegaCrit.Sts2.Core.Runs.PlayerMapPointHistoryEntry GetEntry(UInt64)
 0463: callvirt method:MegaCrit.Sts2.Core.Runs.PlayerMapPointHistoryEntry.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Runs.History.CardChoiceHistoryEntry] get_CardChoices()
 0468: ldloc.s 9
 0470: callvirt method:MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult.MegaCrit.Sts2.Core.Models.CardModel get_Card()
 0475: ldc.i4.0 
 0476: newobj method:MegaCrit.Sts2.Core.Runs.History.CardChoiceHistoryEntry.Void .ctor(MegaCrit.Sts2.Core.Models.CardModel, Boolean)
 0481: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Runs.History.CardChoiceHistoryEntry].Void Add(MegaCrit.Sts2.Core.Runs.History.CardChoiceHistoryEntry)
 0486: ldloc.s 8
 0488: callvirt method:System.Collections.IEnumerator.Boolean MoveNext()
 0493: brtrue.s 422
 0495: leave.s 513
 0497: ldloc.0 
 0498: ldc.i4.0 
 0499: bge.s 512
 0501: ldloc.s 8
 0503: brfalse.s 512
 0505: ldloc.s 8
 0507: callvirt method:System.IDisposable.Void Dispose()
 0512: endfinally 
 0513: leave.s 554
 0515: stloc.s 10
 0517: ldarg.0 
 0518: ldc.i4.s -2
 0520: stfld field:Int32 <>1__state
 0525: ldarg.0 
 0526: ldnull 
 0527: stfld field:<>c__DisplayClass113_0 <>8__1
 0532: ldarg.0 
 0533: ldnull 
 0534: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult] <unselectedCards>5__2
 0539: ldarg.0 
 0540: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0545: ldloc.s 10
 0547: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0552: leave.s 587
 0554: ldarg.0 
 0555: ldc.i4.s -2
 0557: stfld field:Int32 <>1__state
 0562: ldarg.0 
 0563: ldnull 
 0564: stfld field:<>c__DisplayClass113_0 <>8__1
 0569: ldarg.0 
 0570: ldnull 
 0571: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Cards.CardCreationResult] <unselectedCards>5__2
 0576: ldarg.0 
 0577: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0582: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0587: ret 
