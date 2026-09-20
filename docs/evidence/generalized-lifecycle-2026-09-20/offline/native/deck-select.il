METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldloc.0 
 0008: switch switch 4
 0029: ldc.i4.6 
 0030: ldarg.0 
 0031: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0036: call method:MegaCrit.Sts2.Core.Entities.Cards.PileTypeExtensions.MegaCrit.Sts2.Core.Entities.Cards.CardPile GetPile(MegaCrit.Sts2.Core.Entities.Cards.PileType, MegaCrit.Sts2.Core.Entities.Players.Player)
 0041: callvirt method:MegaCrit.Sts2.Core.Entities.Cards.CardPile.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel] get_Cards()
 0046: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0051: stloc.2 
 0052: ldarg.0 
 0053: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0058: brfalse.s 79
 0060: ldloc.2 
 0061: ldarg.0 
 0062: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0067: call method:System.Linq.Enumerable.System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] Where[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean])
 0072: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0077: br.s 85
 0079: ldloc.2 
 0080: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0085: stloc.3 
 0086: ldarg.0 
 0087: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0092: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Entities.Creatures.Creature get_Creature()
 0097: callvirt method:MegaCrit.Sts2.Core.Entities.Creatures.Creature.Boolean get_IsDead()
 0102: brfalse.s 115
 0104: call method:System.Array.MegaCrit.Sts2.Core.Models.CardModel[] Empty[CardModel]()
 0109: stloc.1 
 0110: leave 860
 0115: ldarg.0 
 0116: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Int32] sortingOrder
 0121: brfalse.s 141
 0123: ldloc.3 
 0124: ldarg.0 
 0125: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Int32] sortingOrder
 0130: call method:System.Linq.Enumerable.System.Linq.IOrderedEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] OrderBy[CardModel,Int32](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Int32])
 0135: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0140: stloc.3 
 0141: ldloc.3 
 0142: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0147: brtrue.s 160
 0149: call method:System.Array.MegaCrit.Sts2.Core.Models.CardModel[] Empty[CardModel]()
 0154: stloc.1 
 0155: leave 860
 0160: ldarg.0 
 0161: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0166: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Boolean get_RequireManualConfirmation()
 0171: brtrue.s 200
 0173: ldloc.3 
 0174: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0179: ldarg.0 
 0180: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0185: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0190: bgt.s 200
 0192: ldloc.3 
 0193: stloc.s 4
 0195: br 817
 0200: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0205: brfalse 342
 0210: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0215: ldloc.3 
 0216: ldarg.0 
 0217: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0222: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0227: ldarg.0 
 0228: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0233: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MaxSelect()
 0238: callvirt method:MegaCrit.Sts2.Core.TestSupport.ICardSelector.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetSelectedCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], Int32, Int32)
 0243: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0248: stloc.s 6
 0250: ldloca.s 6
 0252: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0257: brtrue.s 324
 0259: ldarg.0 
 0260: ldc.i4.0 
 0261: dup 
 0262: stloc.0 
 0263: stfld field:Int32 <>1__state
 0268: ldarg.0 
 0269: ldloc.s 6
 0271: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0276: ldarg.0 
 0277: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0282: ldloca.s 6
 0284: ldarg.0 
 0285: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromDeckGeneric>d__27](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromDeckGeneric>d__27 ByRef)
 0290: leave 880
 0295: ldarg.0 
 0296: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0301: stloc.s 6
 0303: ldarg.0 
 0304: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0309: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0315: ldarg.0 
 0316: ldc.i4.m1 
 0317: dup 
 0318: stloc.0 
 0319: stfld field:Int32 <>1__state
 0324: ldloca.s 6
 0326: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0331: stloc.s 5
 0333: ldloc.s 5
 0335: stloc.s 4
 0337: br 817
 0342: ldarg.0 
 0343: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0348: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0353: ldarg.0 
 0354: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0359: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.UInt32 ReserveChoiceId(MegaCrit.Sts2.Core.Entities.Players.Player)
 0364: stfld field:UInt32 <choiceId>5__2
 0369: ldarg.0 
 0370: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0375: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Boolean ShouldSelectLocalCard(MegaCrit.Sts2.Core.Entities.Players.Player)
 0380: brfalse 690
 0385: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_LocalSelector()
 0390: brfalse 527
 0395: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_LocalSelector()
 0400: ldloc.3 
 0401: ldarg.0 
 0402: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0407: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0412: ldarg.0 
 0413: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0418: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MaxSelect()
 0423: callvirt method:MegaCrit.Sts2.Core.TestSupport.ICardSelector.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetSelectedCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], Int32, Int32)
 0428: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0433: stloc.s 8
 0435: ldloca.s 8
 0437: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0442: brtrue.s 509
 0444: ldarg.0 
 0445: ldc.i4.1 
 0446: dup 
 0447: stloc.0 
 0448: stfld field:Int32 <>1__state
 0453: ldarg.0 
 0454: ldloc.s 8
 0456: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0461: ldarg.0 
 0462: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0467: ldloca.s 8
 0469: ldarg.0 
 0470: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromDeckGeneric>d__27](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromDeckGeneric>d__27 ByRef)
 0475: leave 880
 0480: ldarg.0 
 0481: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0486: stloc.s 8
 0488: ldarg.0 
 0489: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0494: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0500: ldarg.0 
 0501: ldc.i4.m1 
 0502: dup 
 0503: stloc.0 
 0504: stfld field:Int32 <>1__state
 0509: ldloca.s 8
 0511: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0516: stloc.s 7
 0518: ldloc.s 7
 0520: stloc.s 4
 0522: br 817
 0527: ldloc.3 
 0528: ldarg.0 
 0529: ldfld field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0534: call method:MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NDeckCardSelectScreen.MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NDeckCardSelectScreen Create(System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel], MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs)
 0539: stloc.s 9
 0541: call method:MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack.MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack get_Instance()
 0546: ldloc.s 9
 0548: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack.Void Push(MegaCrit.Sts2.Core.Nodes.Screens.Overlays.IOverlayScreen)
 0553: ldloc.s 9
 0555: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NCardGridSelectionScreen.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] CardsSelected()
 0560: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0565: stloc.s 11
 0567: ldloca.s 11
 0569: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0574: brtrue.s 641
 0576: ldarg.0 
 0577: ldc.i4.2 
 0578: dup 
 0579: stloc.0 
 0580: stfld field:Int32 <>1__state
 0585: ldarg.0 
 0586: ldloc.s 11
 0588: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0593: ldarg.0 
 0594: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0599: ldloca.s 11
 0601: ldarg.0 
 0602: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromDeckGeneric>d__27](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromDeckGeneric>d__27 ByRef)
 0607: leave 880
 0612: ldarg.0 
 0613: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0618: stloc.s 11
 0620: ldarg.0 
 0621: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0626: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0632: ldarg.0 
 0633: ldc.i4.m1 
 0634: dup 
 0635: stloc.0 
 0636: stfld field:Int32 <>1__state
 0641: ldloca.s 11
 0643: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0648: stloc.s 10
 0650: ldloc.s 10
 0652: stloc.s 4
 0654: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0659: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0664: ldarg.0 
 0665: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0670: ldarg.0 
 0671: ldfld field:UInt32 <choiceId>5__2
 0676: ldloc.s 4
 0678: call method:MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult.MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult FromMutableDeckCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0683: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.Void SyncLocalChoice(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32, MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult)
 0688: br.s 817
 0690: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0695: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0700: ldarg.0 
 0701: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0706: ldarg.0 
 0707: ldfld field:UInt32 <choiceId>5__2
 0712: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] WaitForRemoteChoice(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32)
 0717: callvirt method:System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] GetAwaiter()
 0722: stloc.s 14
 0724: ldloca.s 14
 0726: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].Boolean get_IsCompleted()
 0731: brtrue.s 795
 0733: ldarg.0 
 0734: ldc.i4.3 
 0735: dup 
 0736: stloc.0 
 0737: stfld field:Int32 <>1__state
 0742: ldarg.0 
 0743: ldloc.s 14
 0745: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__2
 0750: ldarg.0 
 0751: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0756: ldloca.s 14
 0758: ldarg.0 
 0759: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromDeckGeneric>d__27](System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] ByRef, <FromDeckGeneric>d__27 ByRef)
 0764: leave.s 880
 0766: ldarg.0 
 0767: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__2
 0772: stloc.s 14
 0774: ldarg.0 
 0775: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__2
 0780: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult]
 0786: ldarg.0 
 0787: ldc.i4.m1 
 0788: dup 
 0789: stloc.0 
 0790: stfld field:Int32 <>1__state
 0795: ldloca.s 14
 0797: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult GetResult()
 0802: stloc.s 13
 0804: ldloc.s 13
 0806: stloc.s 12
 0808: ldloc.s 12
 0810: callvirt method:MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult.System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] AsDeckCards()
 0815: stloc.s 4
 0817: ldarg.0 
 0818: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0823: ldloc.s 4
 0825: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Void LogChoice(MegaCrit.Sts2.Core.Entities.Players.Player, System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0830: ldloc.s 4
 0832: stloc.1 
 0833: leave.s 860
 0835: stloc.s 15
 0837: ldarg.0 
 0838: ldc.i4.s -2
 0840: stfld field:Int32 <>1__state
 0845: ldarg.0 
 0846: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0851: ldloc.s 15
 0853: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetException(System.Exception)
 0858: leave.s 880
 0860: ldarg.0 
 0861: ldc.i4.s -2
 0863: stfld field:Int32 <>1__state
 0868: ldarg.0 
 0869: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0874: ldloc.1 
 0875: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetResult(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0880: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldloc.0 
 0008: switch switch 4
 0029: ldc.i4.6 
 0030: ldarg.0 
 0031: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0036: call method:MegaCrit.Sts2.Core.Entities.Cards.PileTypeExtensions.MegaCrit.Sts2.Core.Entities.Cards.CardPile GetPile(MegaCrit.Sts2.Core.Entities.Cards.PileType, MegaCrit.Sts2.Core.Entities.Players.Player)
 0041: callvirt method:MegaCrit.Sts2.Core.Entities.Cards.CardPile.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel] get_Cards()
 0046: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] <>9__21_0
 0051: dup 
 0052: brtrue.s 77
 0054: pop 
 0055: ldsfld field:<>c <>9
 0060: ldftn method:MegaCrit.Sts2.Core.Commands.CardSelectCmd+<>c.Boolean <FromDeckForUpgrade>b__21_0(MegaCrit.Sts2.Core.Models.CardModel)
 0066: newobj method:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean].Void .ctor(System.Object, IntPtr)
 0071: dup 
 0072: stsfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] <>9__21_0
 0077: call method:System.Linq.Enumerable.System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] Where[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean])
 0082: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0087: stloc.2 
 0088: ldloc.2 
 0089: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0094: brtrue.s 107
 0096: call method:System.Array.MegaCrit.Sts2.Core.Models.CardModel[] Empty[CardModel]()
 0101: stloc.1 
 0102: leave 798
 0107: ldloc.2 
 0108: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0113: ldarg.0 
 0114: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0119: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0124: bgt.s 146
 0126: ldarg.0 
 0127: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0132: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Boolean get_RequireManualConfirmation()
 0137: brtrue.s 146
 0139: ldloc.2 
 0140: stloc.3 
 0141: br 757
 0146: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0151: brfalse 287
 0156: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0161: ldloc.2 
 0162: ldarg.0 
 0163: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0168: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0173: ldarg.0 
 0174: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0179: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MaxSelect()
 0184: callvirt method:MegaCrit.Sts2.Core.TestSupport.ICardSelector.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetSelectedCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], Int32, Int32)
 0189: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0194: stloc.s 5
 0196: ldloca.s 5
 0198: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0203: brtrue.s 270
 0205: ldarg.0 
 0206: ldc.i4.0 
 0207: dup 
 0208: stloc.0 
 0209: stfld field:Int32 <>1__state
 0214: ldarg.0 
 0215: ldloc.s 5
 0217: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0222: ldarg.0 
 0223: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0228: ldloca.s 5
 0230: ldarg.0 
 0231: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromDeckForUpgrade>d__21](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromDeckForUpgrade>d__21 ByRef)
 0236: leave 818
 0241: ldarg.0 
 0242: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0247: stloc.s 5
 0249: ldarg.0 
 0250: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0255: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0261: ldarg.0 
 0262: ldc.i4.m1 
 0263: dup 
 0264: stloc.0 
 0265: stfld field:Int32 <>1__state
 0270: ldloca.s 5
 0272: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0277: stloc.s 4
 0279: ldloc.s 4
 0281: stloc.3 
 0282: br 757
 0287: ldarg.0 
 0288: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0293: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0298: ldarg.0 
 0299: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0304: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.UInt32 ReserveChoiceId(MegaCrit.Sts2.Core.Entities.Players.Player)
 0309: stfld field:UInt32 <choiceId>5__2
 0314: ldarg.0 
 0315: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0320: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Boolean ShouldSelectLocalCard(MegaCrit.Sts2.Core.Entities.Players.Player)
 0325: brfalse 631
 0330: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_LocalSelector()
 0335: brfalse 471
 0340: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_LocalSelector()
 0345: ldloc.2 
 0346: ldarg.0 
 0347: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0352: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0357: ldarg.0 
 0358: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0363: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MaxSelect()
 0368: callvirt method:MegaCrit.Sts2.Core.TestSupport.ICardSelector.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetSelectedCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], Int32, Int32)
 0373: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0378: stloc.s 7
 0380: ldloca.s 7
 0382: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0387: brtrue.s 454
 0389: ldarg.0 
 0390: ldc.i4.1 
 0391: dup 
 0392: stloc.0 
 0393: stfld field:Int32 <>1__state
 0398: ldarg.0 
 0399: ldloc.s 7
 0401: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0406: ldarg.0 
 0407: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0412: ldloca.s 7
 0414: ldarg.0 
 0415: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromDeckForUpgrade>d__21](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromDeckForUpgrade>d__21 ByRef)
 0420: leave 818
 0425: ldarg.0 
 0426: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0431: stloc.s 7
 0433: ldarg.0 
 0434: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0439: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0445: ldarg.0 
 0446: ldc.i4.m1 
 0447: dup 
 0448: stloc.0 
 0449: stfld field:Int32 <>1__state
 0454: ldloca.s 7
 0456: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0461: stloc.s 6
 0463: ldloc.s 6
 0465: stloc.3 
 0466: br 757
 0471: ldloc.2 
 0472: ldarg.0 
 0473: ldfld field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0478: ldarg.0 
 0479: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0484: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0489: call method:MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NDeckUpgradeSelectScreen.MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NDeckUpgradeSelectScreen ShowScreen(System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel], MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs, MegaCrit.Sts2.Core.Runs.IRunState)
 0494: stloc.s 8
 0496: ldloc.s 8
 0498: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NCardGridSelectionScreen.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] CardsSelected()
 0503: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0508: stloc.s 10
 0510: ldloca.s 10
 0512: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0517: brtrue.s 584
 0519: ldarg.0 
 0520: ldc.i4.2 
 0521: dup 
 0522: stloc.0 
 0523: stfld field:Int32 <>1__state
 0528: ldarg.0 
 0529: ldloc.s 10
 0531: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0536: ldarg.0 
 0537: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0542: ldloca.s 10
 0544: ldarg.0 
 0545: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromDeckForUpgrade>d__21](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromDeckForUpgrade>d__21 ByRef)
 0550: leave 818
 0555: ldarg.0 
 0556: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0561: stloc.s 10
 0563: ldarg.0 
 0564: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0569: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0575: ldarg.0 
 0576: ldc.i4.m1 
 0577: dup 
 0578: stloc.0 
 0579: stfld field:Int32 <>1__state
 0584: ldloca.s 10
 0586: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0591: stloc.s 9
 0593: ldloc.s 9
 0595: stloc.3 
 0596: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0601: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0606: ldarg.0 
 0607: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0612: ldarg.0 
 0613: ldfld field:UInt32 <choiceId>5__2
 0618: ldloc.3 
 0619: call method:MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult.MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult FromMutableDeckCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0624: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.Void SyncLocalChoice(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32, MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult)
 0629: br.s 757
 0631: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0636: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0641: ldarg.0 
 0642: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0647: ldarg.0 
 0648: ldfld field:UInt32 <choiceId>5__2
 0653: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] WaitForRemoteChoice(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32)
 0658: callvirt method:System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] GetAwaiter()
 0663: stloc.s 13
 0665: ldloca.s 13
 0667: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].Boolean get_IsCompleted()
 0672: brtrue.s 736
 0674: ldarg.0 
 0675: ldc.i4.3 
 0676: dup 
 0677: stloc.0 
 0678: stfld field:Int32 <>1__state
 0683: ldarg.0 
 0684: ldloc.s 13
 0686: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__2
 0691: ldarg.0 
 0692: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0697: ldloca.s 13
 0699: ldarg.0 
 0700: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromDeckForUpgrade>d__21](System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] ByRef, <FromDeckForUpgrade>d__21 ByRef)
 0705: leave.s 818
 0707: ldarg.0 
 0708: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__2
 0713: stloc.s 13
 0715: ldarg.0 
 0716: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__2
 0721: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult]
 0727: ldarg.0 
 0728: ldc.i4.m1 
 0729: dup 
 0730: stloc.0 
 0731: stfld field:Int32 <>1__state
 0736: ldloca.s 13
 0738: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult GetResult()
 0743: stloc.s 12
 0745: ldloc.s 12
 0747: stloc.s 11
 0749: ldloc.s 11
 0751: callvirt method:MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult.System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] AsDeckCards()
 0756: stloc.3 
 0757: ldarg.0 
 0758: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0763: ldloc.3 
 0764: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Void LogChoice(MegaCrit.Sts2.Core.Entities.Players.Player, System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0769: ldloc.3 
 0770: stloc.1 
 0771: leave.s 798
 0773: stloc.s 14
 0775: ldarg.0 
 0776: ldc.i4.s -2
 0778: stfld field:Int32 <>1__state
 0783: ldarg.0 
 0784: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0789: ldloc.s 14
 0791: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetException(System.Exception)
 0796: leave.s 818
 0798: ldarg.0 
 0799: ldc.i4.s -2
 0801: stfld field:Int32 <>1__state
 0806: ldarg.0 
 0807: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0812: ldloc.1 
 0813: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetResult(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0818: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldloc.0 
 0008: switch switch 6
 0037: ldarg.0 
 0038: newobj method:MegaCrit.Sts2.Core.Commands.CardSelectCmd+<>c__DisplayClass18_0.Void .ctor()
 0043: stfld field:<>c__DisplayClass18_0 <>8__1
 0048: call method:MegaCrit.Sts2.Core.Combat.CombatManager.MegaCrit.Sts2.Core.Combat.CombatManager get_Instance()
 0053: callvirt method:MegaCrit.Sts2.Core.Combat.CombatManager.Boolean get_IsEnding()
 0058: brfalse.s 71
 0060: call method:System.Array.MegaCrit.Sts2.Core.Models.CardModel[] Empty[CardModel]()
 0065: stloc.1 
 0066: leave 1284
 0071: ldarg.0 
 0072: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0077: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Void UndoEndTurnIfNecessary(MegaCrit.Sts2.Core.Entities.Players.Player)
 0082: ldarg.0 
 0083: ldfld field:<>c__DisplayClass18_0 <>8__1
 0088: ldarg.0 
 0089: ldfld field:System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel] cardsIn
 0094: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0099: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] cards
 0104: ldarg.0 
 0105: ldflda field:System.Nullable`1[System.UInt32] <choiceId>5__3
 0110: initobj type:System.Nullable`1[System.UInt32]
 0116: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0121: brtrue 261
 0126: ldarg.0 
 0127: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0132: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0137: ldarg.0 
 0138: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0143: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.UInt32 ReserveChoiceId(MegaCrit.Sts2.Core.Entities.Players.Player)
 0148: newobj method:System.Nullable`1[System.UInt32].Void .ctor(UInt32)
 0153: stfld field:System.Nullable`1[System.UInt32] <choiceId>5__3
 0158: ldarg.0 
 0159: ldfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext context
 0164: ldarg.0 
 0165: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0170: ldc.i4.0 
 0171: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext.System.Threading.Tasks.Task SignalPlayerChoiceBegun(MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.Entities.Multiplayer.PlayerChoiceOptions)
 0176: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0181: stloc.2 
 0182: ldloca.s 2
 0184: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0189: brtrue.s 254
 0191: ldarg.0 
 0192: ldc.i4.0 
 0193: dup 
 0194: stloc.0 
 0195: stfld field:Int32 <>1__state
 0200: ldarg.0 
 0201: ldloc.2 
 0202: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0207: ldarg.0 
 0208: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0213: ldloca.s 2
 0215: ldarg.0 
 0216: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter,<FromSimpleGrid>d__18](System.Runtime.CompilerServices.TaskAwaiter ByRef, <FromSimpleGrid>d__18 ByRef)
 0221: leave 1318
 0226: ldarg.0 
 0227: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0232: stloc.2 
 0233: ldarg.0 
 0234: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0239: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0245: ldarg.0 
 0246: ldc.i4.m1 
 0247: dup 
 0248: stloc.0 
 0249: stfld field:Int32 <>1__state
 0254: ldloca.s 2
 0256: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0261: ldarg.0 
 0262: ldfld field:<>c__DisplayClass18_0 <>8__1
 0267: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] cards
 0272: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0277: brtrue.s 295
 0279: ldarg.0 
 0280: newobj method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Void .ctor()
 0285: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 0290: br 1107
 0295: ldarg.0 
 0296: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0301: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Boolean get_RequireManualConfirmation()
 0306: brtrue.s 364
 0308: ldarg.0 
 0309: ldfld field:<>c__DisplayClass18_0 <>8__1
 0314: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] cards
 0319: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0324: ldarg.0 
 0325: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0330: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0335: bgt.s 364
 0337: ldarg.0 
 0338: ldarg.0 
 0339: ldfld field:<>c__DisplayClass18_0 <>8__1
 0344: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] cards
 0349: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0354: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 0359: br 1107
 0364: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0369: brfalse 523
 0374: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_Selector()
 0379: ldarg.0 
 0380: ldfld field:<>c__DisplayClass18_0 <>8__1
 0385: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] cards
 0390: ldarg.0 
 0391: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0396: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0401: ldarg.0 
 0402: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0407: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MaxSelect()
 0412: callvirt method:MegaCrit.Sts2.Core.TestSupport.ICardSelector.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetSelectedCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], Int32, Int32)
 0417: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0422: stloc.s 4
 0424: ldloca.s 4
 0426: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0431: brtrue.s 498
 0433: ldarg.0 
 0434: ldc.i4.1 
 0435: dup 
 0436: stloc.0 
 0437: stfld field:Int32 <>1__state
 0442: ldarg.0 
 0443: ldloc.s 4
 0445: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0450: ldarg.0 
 0451: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0456: ldloca.s 4
 0458: ldarg.0 
 0459: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromSimpleGrid>d__18](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromSimpleGrid>d__18 ByRef)
 0464: leave 1318
 0469: ldarg.0 
 0470: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0475: stloc.s 4
 0477: ldarg.0 
 0478: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0483: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0489: ldarg.0 
 0490: ldc.i4.m1 
 0491: dup 
 0492: stloc.0 
 0493: stfld field:Int32 <>1__state
 0498: ldloca.s 4
 0500: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0505: stloc.3 
 0506: ldarg.0 
 0507: ldloc.3 
 0508: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0513: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 0518: br 1107
 0523: ldarg.0 
 0524: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0529: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Boolean ShouldSelectLocalCard(MegaCrit.Sts2.Core.Entities.Players.Player)
 0534: brfalse 941
 0539: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_LocalSelector()
 0544: brfalse 700
 0549: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.MegaCrit.Sts2.Core.TestSupport.ICardSelector get_LocalSelector()
 0554: ldarg.0 
 0555: ldfld field:<>c__DisplayClass18_0 <>8__1
 0560: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] cards
 0565: ldarg.0 
 0566: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0571: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0576: ldarg.0 
 0577: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0582: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MaxSelect()
 0587: callvirt method:MegaCrit.Sts2.Core.TestSupport.ICardSelector.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetSelectedCards(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], Int32, Int32)
 0592: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0597: stloc.s 6
 0599: ldloca.s 6
 0601: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0606: brtrue.s 673
 0608: ldarg.0 
 0609: ldc.i4.2 
 0610: dup 
 0611: stloc.0 
 0612: stfld field:Int32 <>1__state
 0617: ldarg.0 
 0618: ldloc.s 6
 0620: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0625: ldarg.0 
 0626: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0631: ldloca.s 6
 0633: ldarg.0 
 0634: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromSimpleGrid>d__18](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromSimpleGrid>d__18 ByRef)
 0639: leave 1318
 0644: ldarg.0 
 0645: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0650: stloc.s 6
 0652: ldarg.0 
 0653: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0658: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0664: ldarg.0 
 0665: ldc.i4.m1 
 0666: dup 
 0667: stloc.0 
 0668: stfld field:Int32 <>1__state
 0673: ldloca.s 6
 0675: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0680: stloc.s 5
 0682: ldarg.0 
 0683: ldloc.s 5
 0685: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0690: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 0695: br 1107
 0700: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand get_Instance()
 0705: dup 
 0706: brtrue.s 711
 0708: pop 
 0709: br.s 716
 0711: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void CancelAllCardPlay()
 0716: ldarg.0 
 0717: ldfld field:<>c__DisplayClass18_0 <>8__1
 0722: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] cards
 0727: ldarg.0 
 0728: ldfld field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0733: call method:MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NSimpleCardSelectScreen.MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NSimpleCardSelectScreen Create(System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel], MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs)
 0738: stloc.s 7
 0740: call method:MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack.MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack get_Instance()
 0745: ldloc.s 7
 0747: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack.Void Push(MegaCrit.Sts2.Core.Nodes.Screens.Overlays.IOverlayScreen)
 0752: ldloc.s 7
 0754: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NCardGridSelectionScreen.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] CardsSelected()
 0759: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0764: stloc.s 10
 0766: ldloca.s 10
 0768: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0773: brtrue.s 840
 0775: ldarg.0 
 0776: ldc.i4.3 
 0777: dup 
 0778: stloc.0 
 0779: stfld field:Int32 <>1__state
 0784: ldarg.0 
 0785: ldloc.s 10
 0787: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0792: ldarg.0 
 0793: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0798: ldloca.s 10
 0800: ldarg.0 
 0801: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromSimpleGrid>d__18](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <FromSimpleGrid>d__18 ByRef)
 0806: leave 1318
 0811: ldarg.0 
 0812: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0817: stloc.s 10
 0819: ldarg.0 
 0820: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__2
 0825: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0831: ldarg.0 
 0832: ldc.i4.m1 
 0833: dup 
 0834: stloc.0 
 0835: stfld field:Int32 <>1__state
 0840: ldloca.s 10
 0842: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0847: stloc.s 9
 0849: ldarg.0 
 0850: ldloc.s 9
 0852: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0857: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 0862: ldarg.0 
 0863: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 0868: ldarg.0 
 0869: ldfld field:<>c__DisplayClass18_0 <>8__1
 0874: ldftn method:MegaCrit.Sts2.Core.Commands.CardSelectCmd+<>c__DisplayClass18_0.Int32 <FromSimpleGrid>b__0(MegaCrit.Sts2.Core.Models.CardModel)
 0880: newobj method:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Int32].Void .ctor(System.Object, IntPtr)
 0885: call method:System.Linq.Enumerable.System.Collections.Generic.IEnumerable`1[System.Int32] Select[CardModel,Int32](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel], System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Int32])
 0890: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[System.Int32] ToList[Int32](System.Collections.Generic.IEnumerable`1[System.Int32])
 0895: stloc.s 8
 0897: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0902: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0907: ldarg.0 
 0908: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0913: ldarg.0 
 0914: ldflda field:System.Nullable`1[System.UInt32] <choiceId>5__3
 0919: call method:System.Nullable`1[System.UInt32].UInt32 get_Value()
 0924: ldloc.s 8
 0926: call method:MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult.MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult FromIndexes(System.Collections.Generic.List`1[System.Int32])
 0931: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.Void SyncLocalChoice(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32, MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult)
 0936: br 1107
 0941: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0946: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0951: ldarg.0 
 0952: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0957: ldarg.0 
 0958: ldflda field:System.Nullable`1[System.UInt32] <choiceId>5__3
 0963: call method:System.Nullable`1[System.UInt32].UInt32 get_Value()
 0968: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] WaitForRemoteChoice(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32)
 0973: callvirt method:System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] GetAwaiter()
 0978: stloc.s 13
 0980: ldloca.s 13
 0982: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].Boolean get_IsCompleted()
 0987: brtrue.s 1054
 0989: ldarg.0 
 0990: ldc.i4.4 
 0991: dup 
 0992: stloc.0 
 0993: stfld field:Int32 <>1__state
 0998: ldarg.0 
 0999: ldloc.s 13
 1001: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__3
 1006: ldarg.0 
 1007: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 1012: ldloca.s 13
 1014: ldarg.0 
 1015: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromSimpleGrid>d__18](System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] ByRef, <FromSimpleGrid>d__18 ByRef)
 1020: leave 1318
 1025: ldarg.0 
 1026: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__3
 1031: stloc.s 13
 1033: ldarg.0 
 1034: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__3
 1039: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult]
 1045: ldarg.0 
 1046: ldc.i4.m1 
 1047: dup 
 1048: stloc.0 
 1049: stfld field:Int32 <>1__state
 1054: ldloca.s 13
 1056: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult GetResult()
 1061: stloc.s 12
 1063: ldloc.s 12
 1065: stloc.s 11
 1067: ldarg.0 
 1068: ldloc.s 11
 1070: callvirt method:MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult.System.Collections.Generic.List`1[System.Int32] AsIndexes()
 1075: ldarg.0 
 1076: ldfld field:<>c__DisplayClass18_0 <>8__1
 1081: ldftn method:MegaCrit.Sts2.Core.Commands.CardSelectCmd+<>c__DisplayClass18_0.MegaCrit.Sts2.Core.Models.CardModel <FromSimpleGrid>b__1(Int32)
 1087: newobj method:System.Func`2[System.Int32,MegaCrit.Sts2.Core.Models.CardModel].Void .ctor(System.Object, IntPtr)
 1092: call method:System.Linq.Enumerable.System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] Select[Int32,CardModel](System.Collections.Generic.IEnumerable`1[System.Int32], System.Func`2[System.Int32,MegaCrit.Sts2.Core.Models.CardModel])
 1097: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 1102: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 1107: ldarg.0 
 1108: ldflda field:System.Nullable`1[System.UInt32] <choiceId>5__3
 1113: call method:System.Nullable`1[System.UInt32].Boolean get_HasValue()
 1118: brfalse.s 1219
 1120: ldarg.0 
 1121: ldfld field:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext context
 1126: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceContext.System.Threading.Tasks.Task SignalPlayerChoiceEnded()
 1131: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 1136: stloc.s 14
 1138: ldloca.s 14
 1140: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 1145: brtrue.s 1212
 1147: ldarg.0 
 1148: ldc.i4.5 
 1149: dup 
 1150: stloc.0 
 1151: stfld field:Int32 <>1__state
 1156: ldarg.0 
 1157: ldloc.s 14
 1159: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1164: ldarg.0 
 1165: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 1170: ldloca.s 14
 1172: ldarg.0 
 1173: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter,<FromSimpleGrid>d__18](System.Runtime.CompilerServices.TaskAwaiter ByRef, <FromSimpleGrid>d__18 ByRef)
 1178: leave 1318
 1183: ldarg.0 
 1184: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1189: stloc.s 14
 1191: ldarg.0 
 1192: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 1197: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 1203: ldarg.0 
 1204: ldc.i4.m1 
 1205: dup 
 1206: stloc.0 
 1207: stfld field:Int32 <>1__state
 1212: ldloca.s 14
 1214: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 1219: ldarg.0 
 1220: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 1225: ldarg.0 
 1226: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 1231: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Void LogChoice(MegaCrit.Sts2.Core.Entities.Players.Player, System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 1236: ldarg.0 
 1237: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 1242: stloc.1 
 1243: leave.s 1284
 1245: stloc.s 15
 1247: ldarg.0 
 1248: ldc.i4.s -2
 1250: stfld field:Int32 <>1__state
 1255: ldarg.0 
 1256: ldnull 
 1257: stfld field:<>c__DisplayClass18_0 <>8__1
 1262: ldarg.0 
 1263: ldnull 
 1264: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 1269: ldarg.0 
 1270: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 1275: ldloc.s 15
 1277: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetException(System.Exception)
 1282: leave.s 1318
 1284: ldarg.0 
 1285: ldc.i4.s -2
 1287: stfld field:Int32 <>1__state
 1292: ldarg.0 
 1293: ldnull 
 1294: stfld field:<>c__DisplayClass18_0 <>8__1
 1299: ldarg.0 
 1300: ldnull 
 1301: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] <result>5__2
 1306: ldarg.0 
 1307: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 1312: ldloc.1 
 1313: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetResult(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 1318: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldloc.0 
 0008: brfalse 210
 0013: ldloc.0 
 0014: ldc.i4.1 
 0015: beq 398
 0020: call method:MegaCrit.Sts2.Core.Combat.CombatManager.MegaCrit.Sts2.Core.Combat.CombatManager get_Instance()
 0025: callvirt method:MegaCrit.Sts2.Core.Combat.CombatManager.Boolean get_IsEnding()
 0030: brfalse.s 43
 0032: call method:System.Array.MegaCrit.Sts2.Core.Models.CardModel[] Empty[CardModel]()
 0037: stloc.1 
 0038: leave 520
 0043: ldarg.0 
 0044: ldfld field:System.Collections.Generic.IReadOnlyList`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]] bundles
 0049: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]].Int32 get_Count()
 0054: brtrue.s 72
 0056: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Void ReportSoftlock()
 0061: call method:System.Array.MegaCrit.Sts2.Core.Models.CardModel[] Empty[CardModel]()
 0066: stloc.1 
 0067: leave 520
 0072: ldarg.0 
 0073: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0078: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0083: ldarg.0 
 0084: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0089: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.UInt32 ReserveChoiceId(MegaCrit.Sts2.Core.Entities.Players.Player)
 0094: stfld field:UInt32 <choiceId>5__2
 0099: call method:MegaCrit.Sts2.Core.TestSupport.TestMode.Boolean get_IsOn()
 0104: brfalse.s 124
 0106: ldarg.0 
 0107: ldfld field:System.Collections.Generic.IReadOnlyList`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]] bundles
 0112: ldc.i4.0 
 0113: callvirt method:System.Collections.Generic.IReadOnlyList`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel] get_Item(Int32)
 0118: stloc.2 
 0119: br 479
 0124: ldarg.0 
 0125: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0130: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Boolean ShouldSelectLocalCard(MegaCrit.Sts2.Core.Entities.Players.Player)
 0135: brfalse 319
 0140: ldarg.0 
 0141: ldfld field:System.Collections.Generic.IReadOnlyList`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]] bundles
 0146: call method:MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NChooseABundleSelectionScreen.MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NChooseABundleSelectionScreen ShowScreen(System.Collections.Generic.IReadOnlyList`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]])
 0151: stloc.3 
 0152: ldloc.3 
 0153: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NChooseABundleSelectionScreen.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]] CardsSelected()
 0158: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]] GetAwaiter()
 0163: stloc.s 5
 0165: ldloca.s 5
 0167: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]].Boolean get_IsCompleted()
 0172: brtrue.s 239
 0174: ldarg.0 
 0175: ldc.i4.0 
 0176: dup 
 0177: stloc.0 
 0178: stfld field:Int32 <>1__state
 0183: ldarg.0 
 0184: ldloc.s 5
 0186: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]] <>u__1
 0191: ldarg.0 
 0192: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0197: ldloca.s 5
 0199: ldarg.0 
 0200: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromChooseABundleScreen>d__31](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]] ByRef, <FromChooseABundleScreen>d__31 ByRef)
 0205: leave 540
 0210: ldarg.0 
 0211: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]] <>u__1
 0216: stloc.s 5
 0218: ldarg.0 
 0219: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]] <>u__1
 0224: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]]
 0230: ldarg.0 
 0231: ldc.i4.m1 
 0232: dup 
 0233: stloc.0 
 0234: stfld field:Int32 <>1__state
 0239: ldloca.s 5
 0241: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]].System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]] GetResult()
 0246: stloc.s 4
 0248: ldloc.s 4
 0250: call method:System.Linq.Enumerable.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel] FirstOrDefault[IReadOnlyList`1](System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]])
 0255: dup 
 0256: brtrue.s 264
 0258: pop 
 0259: call method:System.Array.MegaCrit.Sts2.Core.Models.CardModel[] Empty[CardModel]()
 0264: stloc.2 
 0265: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0270: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0275: ldarg.0 
 0276: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0281: ldarg.0 
 0282: ldfld field:UInt32 <choiceId>5__2
 0287: ldarg.0 
 0288: ldfld field:System.Collections.Generic.IReadOnlyList`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]] bundles
 0293: ldloc.2 
 0294: call method:MegaCrit.Sts2.Core.Extensions.ListExtensions.Int32 IndexOf[IReadOnlyList`1](System.Collections.Generic.IReadOnlyList`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]], System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel])
 0299: newobj method:System.Nullable`1[System.Int32].Void .ctor(Int32)
 0304: call method:MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult.MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult FromIndex(System.Nullable`1[System.Int32])
 0309: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.Void SyncLocalChoice(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32, MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult)
 0314: br 479
 0319: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0324: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer get_PlayerChoiceSynchronizer()
 0329: ldarg.0 
 0330: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0335: ldarg.0 
 0336: ldfld field:UInt32 <choiceId>5__2
 0341: callvirt method:MegaCrit.Sts2.Core.GameActions.Multiplayer.PlayerChoiceSynchronizer.System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] WaitForRemoteChoice(MegaCrit.Sts2.Core.Entities.Players.Player, UInt32)
 0346: callvirt method:System.Threading.Tasks.Task`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] GetAwaiter()
 0351: stloc.s 9
 0353: ldloca.s 9
 0355: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].Boolean get_IsCompleted()
 0360: brtrue.s 427
 0362: ldarg.0 
 0363: ldc.i4.1 
 0364: dup 
 0365: stloc.0 
 0366: stfld field:Int32 <>1__state
 0371: ldarg.0 
 0372: ldloc.s 9
 0374: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__2
 0379: ldarg.0 
 0380: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0385: ldloca.s 9
 0387: ldarg.0 
 0388: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<FromChooseABundleScreen>d__31](System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] ByRef, <FromChooseABundleScreen>d__31 ByRef)
 0393: leave 540
 0398: ldarg.0 
 0399: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__2
 0404: stloc.s 9
 0406: ldarg.0 
 0407: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult] <>u__2
 0412: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult]
 0418: ldarg.0 
 0419: ldc.i4.m1 
 0420: dup 
 0421: stloc.0 
 0422: stfld field:Int32 <>1__state
 0427: ldloca.s 9
 0429: call method:System.Runtime.CompilerServices.TaskAwaiter`1[MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult].MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult GetResult()
 0434: stloc.s 8
 0436: ldloc.s 8
 0438: stloc.s 6
 0440: ldloc.s 6
 0442: callvirt method:MegaCrit.Sts2.Core.GameActions.PlayerChoiceResult.Int32 AsIndex()
 0447: stloc.s 7
 0449: ldloc.s 7
 0451: ldc.i4.0 
 0452: blt.s 469
 0454: ldarg.0 
 0455: ldfld field:System.Collections.Generic.IReadOnlyList`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]] bundles
 0460: ldloc.s 7
 0462: callvirt method:System.Collections.Generic.IReadOnlyList`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel] get_Item(Int32)
 0467: br.s 478
 0469: call method:System.Array.MegaCrit.Sts2.Core.Models.CardModel[] Empty[CardModel]()
 0474: stloc.s 10
 0476: ldloc.s 10
 0478: stloc.2 
 0479: ldarg.0 
 0480: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0485: ldloc.2 
 0486: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.Void LogChoice(MegaCrit.Sts2.Core.Entities.Players.Player, System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0491: ldloc.2 
 0492: stloc.1 
 0493: leave.s 520
 0495: stloc.s 11
 0497: ldarg.0 
 0498: ldc.i4.s -2
 0500: stfld field:Int32 <>1__state
 0505: ldarg.0 
 0506: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0511: ldloc.s 11
 0513: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetException(System.Exception)
 0518: leave.s 540
 0520: ldarg.0 
 0521: ldc.i4.s -2
 0523: stfld field:Int32 <>1__state
 0528: ldarg.0 
 0529: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0534: ldloc.1 
 0535: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetResult(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0540: ret 
