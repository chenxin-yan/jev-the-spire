METHOD System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] FromHand(MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext, MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs, System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean], MegaCrit.Sts2.Core.Models.AbstractModel)
 0000: ldloca.s 0
 0002: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] Create()
 0007: stfld field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0012: ldloca.s 0
 0014: ldarg.0 
 0015: stfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext context
 0020: ldloca.s 0
 0022: ldarg.1 
 0023: stfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0028: ldloca.s 0
 0030: ldarg.2 
 0031: stfld field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0036: ldloca.s 0
 0038: ldarg.3 
 0039: stfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0044: ldloca.s 0
 0046: ldarg.s 4
 0048: stfld field:MegaCrit.Sts2.Core.Models.AbstractModel source
 0053: ldloca.s 0
 0055: ldc.i4.m1 
 0056: stfld field:Int32 <>1__state
 0061: ldloca.s 0
 0063: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0068: ldloca.s 0
 0070: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void Start[<FromHand>d__28](<FromHand>d__28 ByRef)
 0075: ldloca.s 0
 0077: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0082: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] get_Task()
 0087: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldloc.0 
 0008: switch switch 6
 0037: call method:MegaCrit.Sts2.Core.Combat.CombatManager.MegaCrit.Sts2.Core.Combat.CombatManager get_Instance()
 0042: callvirt method:MegaCrit.Sts2.Core.Combat.CombatManager.Boolean get_IsOverOrEnding()
 0047: brfalse.s 60
 0049: call method:System.Array.MegaCrit.Sts2.Core.Models.CardModel[] Empty[CardModel]()
 0054: stloc.1 
 0055: leave 1189
 0060: ldarg.0 
 0061: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0066: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Boolean ShouldSelectLocalCard(MegaCrit.Sts2.Core.Entities.Players.Player)
 0071: brfalse.s 89
 0073: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand get_Instance()
 0078: dup 
 0079: brtrue.s 84
 0081: pop 
 0082: br.s 89
 0084: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void CancelAllCardPlay()
 0089: ldarg.0 
 0090: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0095: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Void UndoEndTurnIfNecessary(MegaCrit.Sts2.Core.Entities.Players.Player)
 0100: ldarg.0 
 0101: ldflda field:System.Nullable`1[System.UInt32] <choiceId>5__3
 0106: initobj type:System.Nullable`1[System.UInt32]
 0112: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0117: brtrue 257
 0122: ldarg.0 
 0123: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0128: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0133: ldarg.0 
 0134: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0139: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.UInt32 ReserveChoiceId(MegaCrit.Sts2.Core.Entities.Players.Player)
 0144: newobj method:System.Nullable`1[System.UInt32].Void .ctor(UInt32)
 0149: stfld field:System.Nullable`1[System.UInt32] <choiceId>5__3
 0154: ldarg.0 
 0155: ldfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext context
 0160: ldarg.0 
 0161: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0166: ldc.i4.1 
 0167: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext.System.Threading.Tasks.Task SignalPlayerChoiceBegun(MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.Entities.Multiplayer.PlayerChoiceOptions)
 0172: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0177: stloc.3 
 0178: ldloca.s 3
 0180: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0185: brtrue.s 250
 0187: ldarg.0 
 0188: ldc.i4.0 
 0189: dup 
 0190: stloc.0 
 0191: stfld field:Int32 <>1__state
 0196: ldarg.0 
 0197: ldloc.3 
 0198: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0203: ldarg.0 
 0204: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0209: ldloca.s 3
 0211: ldarg.0 
 0212: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter,<FromHand>d__28](System.Runtime.CompilerServices.TaskAwaiter ByRef, <FromHand>d__28 ByRef)
 0217: leave 1216
 0222: ldarg.0 
 0223: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0228: stloc.3 
 0229: ldarg.0 
 0230: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0235: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0241: ldarg.0 
 0242: ldc.i4.m1 
 0243: dup 
 0244: stloc.0 
 0245: stfld field:Int32 <>1__state
 0250: ldloca.s 3
 0252: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0257: ldc.i4.2 
 0258: ldarg.0 
 0259: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0264: call method:MegaCrit.Sts2.Core.Entities.Cards.PileTypeExtensions.MegaCrit.Sts2.Core.Entities.Cards.CardPile GetPile(MegaCrit.Sts2.Core.Entities.Cards.PileType, MegaCrit.Sts2.Core.Entities.Players.Player)
 0269: callvirt method:MegaCrit.Sts2.Core.Entities.Cards.CardPile.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel] get_Cards()
 0274: ldarg.0 
 0275: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0280: dup 
 0281: brtrue.s 315
 0283: pop 
 0284: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] <>9__28_0
 0289: dup 
 0290: brtrue.s 315
 0292: pop 
 0293: ldsfld field:<>c <>9
 0298: ldftn method:MegaCrit.Sts2.Core.Commands.CardSelectCmd+<>c.Boolean <FromHand>b__28_0(MegaCrit.Sts2.Core.Models.CardModel)
 0304: newobj method:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean].Void .ctor(System.Object, IntPtr)
 0309: dup 
 0310: stsfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] <>9__28_0
 0315: call method:System.Linq.Enumerable.System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] Where[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean])
 0320: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0325: stloc.2 
 0326: ldloc.2 
 0327: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0332: brtrue.s 346
 0334: ldarg.0 
 0335: ldloc.2 
 0336: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 0341: br 1022
 0346: ldarg.0 
 0347: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0352: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Boolean get_RequireManualConfirmation()
 0357: brtrue.s 390
 0359: ldloc.2 
 0360: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0365: ldarg.0 
 0366: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0371: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0376: bgt.s 390
 0378: ldarg.0 
 0379: ldloc.2 
 0380: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 0385: br 1022
 0390: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0395: brfalse 536
 0400: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0405: ldloc.2 
 0406: ldarg.0 
 0407: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0412: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0417: ldarg.0 
 0418: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0423: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MaxSelect()
 0428: callvirt method:MegaCrit.Sts2.Core.TestSupport.ICardSelector.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetSelectedCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], Int32, Int32)
 0433: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0438: stloc.s 5
 0440: ldloca.s 5
 0442: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0447: brtrue.s 514
 0449: ldarg.0 
 0450: ldc.i4.1 
 0451: dup 
 0452: stloc.0 
 0453: stfld field:Int32 <>1__state
 0458: ldarg.0 
 0459: ldloc.s 5
 0461: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0466: ldarg.0 
 0467: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0472: ldloca.s 5
 0474: ldarg.0 
 0475: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromHand>d__28](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromHand>d__28 ByRef)
 0480: leave 1216
 0485: ldarg.0 
 0486: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0491: stloc.s 5
 0493: ldarg.0 
 0494: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0499: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0505: ldarg.0 
 0506: ldc.i4.m1 
 0507: dup 
 0508: stloc.0 
 0509: stfld field:Int32 <>1__state
 0514: ldloca.s 5
 0516: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0521: stloc.s 4
 0523: ldarg.0 
 0524: ldloc.s 4
 0526: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 0531: br 1022
 0536: ldarg.0 
 0537: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0542: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Boolean ShouldSelectLocalCard(MegaCrit.Sts2.Core.Entities.Players.Player)
 0547: brfalse 883
 0552: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_LocalSelector()
 0557: brfalse 698
 0562: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_LocalSelector()
 0567: ldloc.2 
 0568: ldarg.0 
 0569: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0574: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0579: ldarg.0 
 0580: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0585: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MaxSelect()
 0590: callvirt method:MegaCrit.Sts2.Core.TestSupport.ICardSelector.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetSelectedCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], Int32, Int32)
 0595: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0600: stloc.s 7
 0602: ldloca.s 7
 0604: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0609: brtrue.s 676
 0611: ldarg.0 
 0612: ldc.i4.2 
 0613: dup 
 0614: stloc.0 
 0615: stfld field:Int32 <>1__state
 0620: ldarg.0 
 0621: ldloc.s 7
 0623: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0628: ldarg.0 
 0629: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0634: ldloca.s 7
 0636: ldarg.0 
 0637: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromHand>d__28](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromHand>d__28 ByRef)
 0642: leave 1216
 0647: ldarg.0 
 0648: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0653: stloc.s 7
 0655: ldarg.0 
 0656: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0661: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0667: ldarg.0 
 0668: ldc.i4.m1 
 0669: dup 
 0670: stloc.0 
 0671: stfld field:Int32 <>1__state
 0676: ldloca.s 7
 0678: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0683: stloc.s 6
 0685: ldarg.0 
 0686: ldloc.s 6
 0688: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 0693: br 1022
 0698: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom get_Instance()
 0703: callvirt method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Combat.NCombatUi get_Ui()
 0708: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NCombatUi.MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand get_Hand()
 0713: ldarg.0 
 0714: ldfld field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0719: ldarg.0 
 0720: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0725: ldarg.0 
 0726: ldfld field:MegaCrit.Sts2.Core.Models.AbstractModel source
 0731: ldc.i4.2 
 0732: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] SelectCards(MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs, System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean], MegaCrit.Sts2.Core.Models.AbstractModel, Mode)
 0737: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0742: stloc.s 9
 0744: ldloca.s 9
 0746: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0751: brtrue.s 818
 0753: ldarg.0 
 0754: ldc.i4.3 
 0755: dup 
 0756: stloc.0 
 0757: stfld field:Int32 <>1__state
 0762: ldarg.0 
 0763: ldloc.s 9
 0765: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0770: ldarg.0 
 0771: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0776: ldloca.s 9
 0778: ldarg.0 
 0779: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromHand>d__28](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromHand>d__28 ByRef)
 0784: leave 1216
 0789: ldarg.0 
 0790: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0795: stloc.s 9
 0797: ldarg.0 
 0798: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0803: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0809: ldarg.0 
 0810: ldc.i4.m1 
 0811: dup 
 0812: stloc.0 
 0813: stfld field:Int32 <>1__state
 0818: ldloca.s 9
 0820: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0825: stloc.s 8
 0827: ldarg.0 
 0828: ldloc.s 8
 0830: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 0835: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0840: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0845: ldarg.0 
 0846: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0851: ldarg.0 
 0852: ldflda field:System.Nullable`1[System.UInt32] <choiceId>5__3
 0857: call method:System.Nullable`1[System.UInt32].UInt32 get_Value()
 0862: ldarg.0 
 0863: ldfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 0868: call method:MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult.MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult FromMutableCombatCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0873: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.Void SyncLocalChoice(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32, MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult)
 0878: br 1022
 0883: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0888: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0893: ldarg.0 
 0894: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0899: ldarg.0 
 0900: ldflda field:System.Nullable`1[System.UInt32] <choiceId>5__3
 0905: call method:System.Nullable`1[System.UInt32].UInt32 get_Value()
 0910: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] WaitForRemoteChoice(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32)
 0915: callvirt method:System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] GetAwaiter()
 0920: stloc.s 12
 0922: ldloca.s 12
 0924: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].Boolean get_IsCompleted()
 0929: brtrue.s 996
 0931: ldarg.0 
 0932: ldc.i4.4 
 0933: dup 
 0934: stloc.0 
 0935: stfld field:Int32 <>1__state
 0940: ldarg.0 
 0941: ldloc.s 12
 0943: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__3
 0948: ldarg.0 
 0949: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0954: ldloca.s 12
 0956: ldarg.0 
 0957: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromHand>d__28](System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] ByRef, <FromHand>d__28 ByRef)
 0962: leave 1216
 0967: ldarg.0 
 0968: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__3
 0973: stloc.s 12
 0975: ldarg.0 
 0976: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__3
 0981: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult]
 0987: ldarg.0 
 0988: ldc.i4.m1 
 0989: dup 
 0990: stloc.0 
 0991: stfld field:Int32 <>1__state
 0996: ldloca.s 12
 0998: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult GetResult()
 1003: stloc.s 11
 1005: ldloc.s 11
 1007: stloc.s 10
 1009: ldarg.0 
 1010: ldloc.s 10
 1012: callvirt method:MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult.System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] AsCombatCards()
 1017: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 1022: ldarg.0 
 1023: ldflda field:System.Nullable`1[System.UInt32] <choiceId>5__3
 1028: call method:System.Nullable`1[System.UInt32].Boolean get_HasValue()
 1033: brfalse.s 1131
 1035: ldarg.0 
 1036: ldfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext context
 1041: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext.System.Threading.Tasks.Task SignalPlayerChoiceEnded()
 1046: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 1051: stloc.s 13
 1053: ldloca.s 13
 1055: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 1060: brtrue.s 1124
 1062: ldarg.0 
 1063: ldc.i4.5 
 1064: dup 
 1065: stloc.0 
 1066: stfld field:Int32 <>1__state
 1071: ldarg.0 
 1072: ldloc.s 13
 1074: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1079: ldarg.0 
 1080: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 1085: ldloca.s 13
 1087: ldarg.0 
 1088: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter,<FromHand>d__28](System.Runtime.CompilerServices.TaskAwaiter ByRef, <FromHand>d__28 ByRef)
 1093: leave.s 1216
 1095: ldarg.0 
 1096: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1101: stloc.s 13
 1103: ldarg.0 
 1104: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1109: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 1115: ldarg.0 
 1116: ldc.i4.m1 
 1117: dup 
 1118: stloc.0 
 1119: stfld field:Int32 <>1__state
 1124: ldloca.s 13
 1126: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 1131: ldarg.0 
 1132: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 1137: ldarg.0 
 1138: ldfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 1143: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Void LogChoice(MegaCrit.Sts2.Core.Entities.Players.Player, System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 1148: ldarg.0 
 1149: ldfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 1154: stloc.1 
 1155: leave.s 1189
 1157: stloc.s 14
 1159: ldarg.0 
 1160: ldc.i4.s -2
 1162: stfld field:Int32 <>1__state
 1167: ldarg.0 
 1168: ldnull 
 1169: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 1174: ldarg.0 
 1175: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 1180: ldloc.s 14
 1182: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetException(System.Exception)
 1187: leave.s 1216
 1189: ldarg.0 
 1190: ldc.i4.s -2
 1192: stfld field:Int32 <>1__state
 1197: ldarg.0 
 1198: ldnull 
 1199: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 1204: ldarg.0 
 1205: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 1210: ldloc.1 
 1211: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetResult(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 1216: ret 
METHOD System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] FromHandForDiscard(MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext, MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs, System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean], MegaCrit.Sts2.Core.Models.AbstractModel)
 0000: ldloca.s 0
 0002: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] Create()
 0007: stfld field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0012: ldloca.s 0
 0014: ldarg.0 
 0015: stfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext context
 0020: ldloca.s 0
 0022: ldarg.1 
 0023: stfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0028: ldloca.s 0
 0030: ldarg.2 
 0031: stfld field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0036: ldloca.s 0
 0038: ldarg.3 
 0039: stfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0044: ldloca.s 0
 0046: ldarg.s 4
 0048: stfld field:MegaCrit.Sts2.Core.Models.AbstractModel source
 0053: ldloca.s 0
 0055: ldc.i4.m1 
 0056: stfld field:Int32 <>1__state
 0061: ldloca.s 0
 0063: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0068: ldloca.s 0
 0070: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void Start[<FromHandForDiscard>d__29](<FromHandForDiscard>d__29 ByRef)
 0075: ldloca.s 0
 0077: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0082: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] get_Task()
 0087: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldloc.0 
 0008: brfalse.s 134
 0010: ldarg.0 
 0011: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0016: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] <>9__29_0
 0021: dup 
 0022: brtrue.s 47
 0024: pop 
 0025: ldsfld field:<>c <>9
 0030: ldftn method:MegaCrit.Sts2.Core.Commands.CardSelectCmd+<>c.Boolean <FromHandForDiscard>b__29_0(MegaCrit.Sts2.Core.Models.CardModel)
 0036: newobj method:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean].Void .ctor(System.Object, IntPtr)
 0041: dup 
 0042: stsfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] <>9__29_0
 0047: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Void set_ShouldGlowGold(System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean])
 0052: ldarg.0 
 0053: ldfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext context
 0058: ldarg.0 
 0059: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0064: ldarg.0 
 0065: ldfld field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0070: ldarg.0 
 0071: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0076: ldarg.0 
 0077: ldfld field:MegaCrit.Sts2.Core.Models.AbstractModel source
 0082: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] FromHand(MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext, MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs, System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean], MegaCrit.Sts2.Core.Models.AbstractModel)
 0087: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0092: stloc.3 
 0093: ldloca.s 3
 0095: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0100: brtrue.s 162
 0102: ldarg.0 
 0103: ldc.i4.0 
 0104: dup 
 0105: stloc.0 
 0106: stfld field:Int32 <>1__state
 0111: ldarg.0 
 0112: ldloc.3 
 0113: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0118: ldarg.0 
 0119: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0124: ldloca.s 3
 0126: ldarg.0 
 0127: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromHandForDiscard>d__29](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromHandForDiscard>d__29 ByRef)
 0132: leave.s 219
 0134: ldarg.0 
 0135: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0140: stloc.3 
 0141: ldarg.0 
 0142: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0147: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0153: ldarg.0 
 0154: ldc.i4.m1 
 0155: dup 
 0156: stloc.0 
 0157: stfld field:Int32 <>1__state
 0162: ldloca.s 3
 0164: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0169: stloc.2 
 0170: ldloc.2 
 0171: stloc.1 
 0172: leave.s 199
 0174: stloc.s 4
 0176: ldarg.0 
 0177: ldc.i4.s -2
 0179: stfld field:Int32 <>1__state
 0184: ldarg.0 
 0185: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0190: ldloc.s 4
 0192: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetException(System.Exception)
 0197: leave.s 219
 0199: ldarg.0 
 0200: ldc.i4.s -2
 0202: stfld field:Int32 <>1__state
 0207: ldarg.0 
 0208: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0213: ldloc.1 
 0214: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetResult(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0219: ret 
METHOD System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.Models.CardModel] FromHandForUpgrade(MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext, MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.Models.AbstractModel)
 0000: ldloca.s 0
 0002: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel].System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel] Create()
 0007: stfld field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel] <>t__builder
 0012: ldloca.s 0
 0014: ldarg.0 
 0015: stfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext context
 0020: ldloca.s 0
 0022: ldarg.1 
 0023: stfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0028: ldloca.s 0
 0030: ldarg.2 
 0031: stfld field:MegaCrit.Sts2.Core.Models.AbstractModel source
 0036: ldloca.s 0
 0038: ldc.i4.m1 
 0039: stfld field:Int32 <>1__state
 0044: ldloca.s 0
 0046: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel] <>t__builder
 0051: ldloca.s 0
 0053: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel].Void Start[<FromHandForUpgrade>d__30](<FromHandForUpgrade>d__30 ByRef)
 0058: ldloca.s 0
 0060: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel] <>t__builder
 0065: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel].System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.Models.CardModel] get_Task()
 0070: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldloc.0 
 0008: switch switch 6
 0037: call method:MegaCrit.Sts2.Core.Combat.CombatManager.MegaCrit.Sts2.Core.Combat.CombatManager get_Instance()
 0042: callvirt method:MegaCrit.Sts2.Core.Combat.CombatManager.Boolean get_IsOverOrEnding()
 0047: brfalse.s 56
 0049: ldnull 
 0050: stloc.1 
 0051: leave 1156
 0056: ldarg.0 
 0057: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0062: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Boolean ShouldSelectLocalCard(MegaCrit.Sts2.Core.Entities.Players.Player)
 0067: brfalse.s 85
 0069: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand get_Instance()
 0074: dup 
 0075: brtrue.s 80
 0077: pop 
 0078: br.s 85
 0080: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void CancelAllCardPlay()
 0085: ldarg.0 
 0086: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0091: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Void UndoEndTurnIfNecessary(MegaCrit.Sts2.Core.Entities.Players.Player)
 0096: ldarg.0 
 0097: ldflda field:System.Nullable`1[System.UInt32] <choiceId>5__2
 0102: initobj type:System.Nullable`1[System.UInt32]
 0108: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0113: brtrue 253
 0118: ldarg.0 
 0119: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0124: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0129: ldarg.0 
 0130: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0135: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.UInt32 ReserveChoiceId(MegaCrit.Sts2.Core.Entities.Players.Player)
 0140: newobj method:System.Nullable`1[System.UInt32].Void .ctor(UInt32)
 0145: stfld field:System.Nullable`1[System.UInt32] <choiceId>5__2
 0150: ldarg.0 
 0151: ldfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext context
 0156: ldarg.0 
 0157: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0162: ldc.i4.1 
 0163: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext.System.Threading.Tasks.Task SignalPlayerChoiceBegun(MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.Entities.Multiplayer.PlayerChoiceOptions)
 0168: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0173: stloc.3 
 0174: ldloca.s 3
 0176: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0181: brtrue.s 246
 0183: ldarg.0 
 0184: ldc.i4.0 
 0185: dup 
 0186: stloc.0 
 0187: stfld field:Int32 <>1__state
 0192: ldarg.0 
 0193: ldloc.3 
 0194: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0199: ldarg.0 
 0200: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel] <>t__builder
 0205: ldloca.s 3
 0207: ldarg.0 
 0208: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel].Void AwaitUnsafeOnCompleted[TaskAwaiter,<FromHandForUpgrade>d__30](System.Runtime.CompilerServices.TaskAwaiter ByRef, <FromHandForUpgrade>d__30 ByRef)
 0213: leave 1183
 0218: ldarg.0 
 0219: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0224: stloc.3 
 0225: ldarg.0 
 0226: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0231: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0237: ldarg.0 
 0238: ldc.i4.m1 
 0239: dup 
 0240: stloc.0 
 0241: stfld field:Int32 <>1__state
 0246: ldloca.s 3
 0248: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0253: ldc.i4.2 
 0254: ldarg.0 
 0255: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0260: call method:MegaCrit.Sts2.Core.Entities.Cards.PileTypeExtensions.MegaCrit.Sts2.Core.Entities.Cards.CardPile GetPile(MegaCrit.Sts2.Core.Entities.Cards.PileType, MegaCrit.Sts2.Core.Entities.Players.Player)
 0265: callvirt method:MegaCrit.Sts2.Core.Entities.Cards.CardPile.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel] get_Cards()
 0270: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] <>9__30_0
 0275: dup 
 0276: brtrue.s 301
 0278: pop 
 0279: ldsfld field:<>c <>9
 0284: ldftn method:MegaCrit.Sts2.Core.Commands.CardSelectCmd+<>c.Boolean <FromHandForUpgrade>b__30_0(MegaCrit.Sts2.Core.Models.CardModel)
 0290: newobj method:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean].Void .ctor(System.Object, IntPtr)
 0295: dup 
 0296: stsfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] <>9__30_0
 0301: call method:System.Linq.Enumerable.System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] Where[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean])
 0306: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0311: stloc.2 
 0312: ldloc.2 
 0313: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0318: ldc.i4.1 
 0319: bgt.s 338
 0321: ldarg.0 
 0322: ldloc.2 
 0323: call method:System.Linq.Enumerable.MegaCrit.Sts2.Core.Models.CardModel FirstOrDefault[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0328: stfld field:MegaCrit.Sts2.Core.Models.CardModel <result>5__3
 0333: br 984
 0338: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0343: brfalse.s 466
 0345: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0350: ldloc.2 
 0351: ldc.i4.1 
 0352: ldc.i4.1 
 0353: callvirt method:MegaCrit.Sts2.Core.TestSupport.ICardSelector.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetSelectedCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], Int32, Int32)
 0358: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0363: stloc.s 5
 0365: ldloca.s 5
 0367: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0372: brtrue.s 439
 0374: ldarg.0 
 0375: ldc.i4.1 
 0376: dup 
 0377: stloc.0 
 0378: stfld field:Int32 <>1__state
 0383: ldarg.0 
 0384: ldloc.s 5
 0386: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0391: ldarg.0 
 0392: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel] <>t__builder
 0397: ldloca.s 5
 0399: ldarg.0 
 0400: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromHandForUpgrade>d__30](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromHandForUpgrade>d__30 ByRef)
 0405: leave 1183
 0410: ldarg.0 
 0411: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0416: stloc.s 5
 0418: ldarg.0 
 0419: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0424: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0430: ldarg.0 
 0431: ldc.i4.m1 
 0432: dup 
 0433: stloc.0 
 0434: stfld field:Int32 <>1__state
 0439: ldloca.s 5
 0441: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0446: stloc.s 4
 0448: ldarg.0 
 0449: ldloc.s 4
 0451: call method:System.Linq.Enumerable.MegaCrit.Sts2.Core.Models.CardModel FirstOrDefault[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0456: stfld field:MegaCrit.Sts2.Core.Models.CardModel <result>5__3
 0461: br 984
 0466: ldarg.0 
 0467: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0472: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Boolean ShouldSelectLocalCard(MegaCrit.Sts2.Core.Entities.Players.Player)
 0477: brfalse 840
 0482: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_LocalSelector()
 0487: brfalse.s 610
 0489: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_LocalSelector()
 0494: ldloc.2 
 0495: ldc.i4.1 
 0496: ldc.i4.1 
 0497: callvirt method:MegaCrit.Sts2.Core.TestSupport.ICardSelector.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetSelectedCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], Int32, Int32)
 0502: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0507: stloc.s 7
 0509: ldloca.s 7
 0511: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0516: brtrue.s 583
 0518: ldarg.0 
 0519: ldc.i4.2 
 0520: dup 
 0521: stloc.0 
 0522: stfld field:Int32 <>1__state
 0527: ldarg.0 
 0528: ldloc.s 7
 0530: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0535: ldarg.0 
 0536: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel] <>t__builder
 0541: ldloca.s 7
 0543: ldarg.0 
 0544: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromHandForUpgrade>d__30](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromHandForUpgrade>d__30 ByRef)
 0549: leave 1183
 0554: ldarg.0 
 0555: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0560: stloc.s 7
 0562: ldarg.0 
 0563: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0568: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0574: ldarg.0 
 0575: ldc.i4.m1 
 0576: dup 
 0577: stloc.0 
 0578: stfld field:Int32 <>1__state
 0583: ldloca.s 7
 0585: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0590: stloc.s 6
 0592: ldarg.0 
 0593: ldloc.s 6
 0595: call method:System.Linq.Enumerable.MegaCrit.Sts2.Core.Models.CardModel FirstOrDefault[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0600: stfld field:MegaCrit.Sts2.Core.Models.CardModel <result>5__3
 0605: br 984
 0610: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom get_Instance()
 0615: callvirt method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Combat.NCombatUi get_Ui()
 0620: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NCombatUi.MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand get_Hand()
 0625: ldstr str:gameplay_ui
 0630: ldstr str:CHOOSE_CARD_UPGRADE_HEADER
 0635: newobj method:MegaCrit.Sts2.Core.Localization.LocString.Void .ctor(System.String, System.String)
 0640: ldc.i4.1 
 0641: newobj method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Void .ctor(MegaCrit.Sts2.Core.Localization.LocString, Int32)
 0646: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] <>9__30_1
 0651: dup 
 0652: brtrue.s 677
 0654: pop 
 0655: ldsfld field:<>c <>9
 0660: ldftn method:MegaCrit.Sts2.Core.Commands.CardSelectCmd+<>c.Boolean <FromHandForUpgrade>b__30_1(MegaCrit.Sts2.Core.Models.CardModel)
 0666: newobj method:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean].Void .ctor(System.Object, IntPtr)
 0671: dup 
 0672: stsfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] <>9__30_1
 0677: ldarg.0 
 0678: ldfld field:MegaCrit.Sts2.Core.Models.AbstractModel source
 0683: ldc.i4.3 
 0684: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] SelectCards(MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs, System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean], MegaCrit.Sts2.Core.Models.AbstractModel, Mode)
 0689: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0694: stloc.s 9
 0696: ldloca.s 9
 0698: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0703: brtrue.s 770
 0705: ldarg.0 
 0706: ldc.i4.3 
 0707: dup 
 0708: stloc.0 
 0709: stfld field:Int32 <>1__state
 0714: ldarg.0 
 0715: ldloc.s 9
 0717: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0722: ldarg.0 
 0723: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel] <>t__builder
 0728: ldloca.s 9
 0730: ldarg.0 
 0731: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromHandForUpgrade>d__30](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromHandForUpgrade>d__30 ByRef)
 0736: leave 1183
 0741: ldarg.0 
 0742: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0747: stloc.s 9
 0749: ldarg.0 
 0750: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0755: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0761: ldarg.0 
 0762: ldc.i4.m1 
 0763: dup 
 0764: stloc.0 
 0765: stfld field:Int32 <>1__state
 0770: ldloca.s 9
 0772: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0777: stloc.s 8
 0779: ldarg.0 
 0780: ldloc.s 8
 0782: call method:System.Linq.Enumerable.MegaCrit.Sts2.Core.Models.CardModel FirstOrDefault[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0787: stfld field:MegaCrit.Sts2.Core.Models.CardModel <result>5__3
 0792: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0797: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0802: ldarg.0 
 0803: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0808: ldarg.0 
 0809: ldflda field:System.Nullable`1[System.UInt32] <choiceId>5__2
 0814: call method:System.Nullable`1[System.UInt32].UInt32 get_Value()
 0819: ldarg.0 
 0820: ldfld field:MegaCrit.Sts2.Core.Models.CardModel <result>5__3
 0825: call method:MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult.MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult FromMutableCombatCard(MegaCrit.Sts2.Core.Models.CardModel)
 0830: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.Void SyncLocalChoice(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32, MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult)
 0835: br 984
 0840: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0845: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0850: ldarg.0 
 0851: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0856: ldarg.0 
 0857: ldflda field:System.Nullable`1[System.UInt32] <choiceId>5__2
 0862: call method:System.Nullable`1[System.UInt32].UInt32 get_Value()
 0867: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] WaitForRemoteChoice(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32)
 0872: callvirt method:System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] GetAwaiter()
 0877: stloc.s 12
 0879: ldloca.s 12
 0881: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].Boolean get_IsCompleted()
 0886: brtrue.s 953
 0888: ldarg.0 
 0889: ldc.i4.4 
 0890: dup 
 0891: stloc.0 
 0892: stfld field:Int32 <>1__state
 0897: ldarg.0 
 0898: ldloc.s 12
 0900: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__3
 0905: ldarg.0 
 0906: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel] <>t__builder
 0911: ldloca.s 12
 0913: ldarg.0 
 0914: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromHandForUpgrade>d__30](System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] ByRef, <FromHandForUpgrade>d__30 ByRef)
 0919: leave 1183
 0924: ldarg.0 
 0925: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__3
 0930: stloc.s 12
 0932: ldarg.0 
 0933: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__3
 0938: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult]
 0944: ldarg.0 
 0945: ldc.i4.m1 
 0946: dup 
 0947: stloc.0 
 0948: stfld field:Int32 <>1__state
 0953: ldloca.s 12
 0955: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult GetResult()
 0960: stloc.s 11
 0962: ldloc.s 11
 0964: stloc.s 10
 0966: ldarg.0 
 0967: ldloc.s 10
 0969: callvirt method:MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult.System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] AsCombatCards()
 0974: call method:System.Linq.Enumerable.MegaCrit.Sts2.Core.Models.CardModel FirstOrDefault[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0979: stfld field:MegaCrit.Sts2.Core.Models.CardModel <result>5__3
 0984: ldarg.0 
 0985: ldflda field:System.Nullable`1[System.UInt32] <choiceId>5__2
 0990: call method:System.Nullable`1[System.UInt32].Boolean get_HasValue()
 0995: brfalse.s 1093
 0997: ldarg.0 
 0998: ldfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext context
 1003: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext.System.Threading.Tasks.Task SignalPlayerChoiceEnded()
 1008: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 1013: stloc.s 13
 1015: ldloca.s 13
 1017: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 1022: brtrue.s 1086
 1024: ldarg.0 
 1025: ldc.i4.5 
 1026: dup 
 1027: stloc.0 
 1028: stfld field:Int32 <>1__state
 1033: ldarg.0 
 1034: ldloc.s 13
 1036: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1041: ldarg.0 
 1042: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel] <>t__builder
 1047: ldloca.s 13
 1049: ldarg.0 
 1050: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel].Void AwaitUnsafeOnCompleted[TaskAwaiter,<FromHandForUpgrade>d__30](System.Runtime.CompilerServices.TaskAwaiter ByRef, <FromHandForUpgrade>d__30 ByRef)
 1055: leave.s 1183
 1057: ldarg.0 
 1058: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1063: stloc.s 13
 1065: ldarg.0 
 1066: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1071: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 1077: ldarg.0 
 1078: ldc.i4.m1 
 1079: dup 
 1080: stloc.0 
 1081: stfld field:Int32 <>1__state
 1086: ldloca.s 13
 1088: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 1093: ldarg.0 
 1094: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 1099: ldarg.0 
 1100: ldfld field:MegaCrit.Sts2.Core.Models.CardModel <result>5__3
 1105: newobj method:<>z__ReadOnlySingleElementList`1[MegaCrit.Sts2.Core.Models.CardModel].Void .ctor(MegaCrit.Sts2.Core.Models.CardModel)
 1110: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Void LogChoice(MegaCrit.Sts2.Core.Entities.Players.Player, System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 1115: ldarg.0 
 1116: ldfld field:MegaCrit.Sts2.Core.Models.CardModel <result>5__3
 1121: stloc.1 
 1122: leave.s 1156
 1124: stloc.s 14
 1126: ldarg.0 
 1127: ldc.i4.s -2
 1129: stfld field:Int32 <>1__state
 1134: ldarg.0 
 1135: ldnull 
 1136: stfld field:MegaCrit.Sts2.Core.Models.CardModel <result>5__3
 1141: ldarg.0 
 1142: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel] <>t__builder
 1147: ldloc.s 14
 1149: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel].Void SetException(System.Exception)
 1154: leave.s 1183
 1156: ldarg.0 
 1157: ldc.i4.s -2
 1159: stfld field:Int32 <>1__state
 1164: ldarg.0 
 1165: ldnull 
 1166: stfld field:MegaCrit.Sts2.Core.Models.CardModel <result>5__3
 1171: ldarg.0 
 1172: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel] <>t__builder
 1177: ldloc.1 
 1178: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[MegaCrit.Sts2.Core.Models.CardModel].Void SetResult(MegaCrit.Sts2.Core.Models.CardModel)
 1183: ret 
