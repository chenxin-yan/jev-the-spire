METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: switch switch 5
 0040: ldloc.1 
 0041: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NCommonBanner _banner
 0046: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NCommonBanner.Void AnimateIn()
 0051: ldloc.1 
 0052: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0057: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Disable()
 0062: ldloc.1 
 0063: ldfld field:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton _chestButton
 0068: ldc.i4.0 
 0069: callvirt method:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton.Void UpdateChestSkin(Boolean)
 0074: ldloc.1 
 0075: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0080: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.MegaCrit.Sts2.Core.Models.ActModel get_Act()
 0085: callvirt method:MegaCrit.Sts2.Core.Models.ActModel.System.String get_ChestOpenSfx()
 0090: ldc.r4 1
 0095: call method:MegaCrit.Sts2.Core.Commands.SfxCmd.Void Play(System.String, Single)
 0100: ldloc.1 
 0101: ldfld field:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton _chestButton
 0106: ldc.i4.2 
 0107: conv.i8 
 0108: callvirt method:Godot.Control.Void set_MouseFilter(MouseFilterEnum)
 0113: ldloc.1 
 0114: ldfld field:MegaCrit.Sts2.Core.Rooms.TreasureRoom _room
 0119: callvirt method:MegaCrit.Sts2.Core.Rooms.TreasureRoom.System.Threading.Tasks.Task`1[System.Int32] DoNormalRewards()
 0124: callvirt method:System.Threading.Tasks.Task`1[System.Int32].System.Runtime.CompilerServices.TaskAwaiter`1[System.Int32] GetAwaiter()
 0129: stloc.s 4
 0131: ldloca.s 4
 0133: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Int32].Boolean get_IsCompleted()
 0138: brtrue.s 205
 0140: ldarg.0 
 0141: ldc.i4.0 
 0142: dup 
 0143: stloc.0 
 0144: stfld field:Int32 <>1__state
 0149: ldarg.0 
 0150: ldloc.s 4
 0152: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Int32] <>u__1
 0157: ldarg.0 
 0158: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0163: ldloca.s 4
 0165: ldarg.0 
 0166: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<OpenChest>d__26](System.Runtime.CompilerServices.TaskAwaiter`1[System.Int32] ByRef, <OpenChest>d__26 ByRef)
 0171: leave 950
 0176: ldarg.0 
 0177: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Int32] <>u__1
 0182: stloc.s 4
 0184: ldarg.0 
 0185: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Int32] <>u__1
 0190: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Int32]
 0196: ldarg.0 
 0197: ldc.i4.m1 
 0198: dup 
 0199: stloc.0 
 0200: stfld field:Int32 <>1__state
 0205: ldloca.s 4
 0207: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Int32].Int32 GetResult()
 0212: stloc.3 
 0213: ldloc.3 
 0214: stloc.2 
 0215: ldloc.2 
 0216: ldc.i4.0 
 0217: ble.s 243
 0219: ldloc.1 
 0220: ldfld field:Godot.GpuParticles2D _goldParticles
 0225: ldloc.2 
 0226: callvirt method:Godot.GpuParticles2D.Void set_Amount(Int32)
 0231: ldloc.1 
 0232: ldfld field:Godot.GpuParticles2D _goldParticles
 0237: ldc.i4.1 
 0238: callvirt method:Godot.GpuParticles2D.Void set_Emitting(Boolean)
 0243: ldloc.1 
 0244: ldfld field:MegaCrit.Sts2.Core.Rooms.TreasureRoom _room
 0249: callvirt method:MegaCrit.Sts2.Core.Rooms.TreasureRoom.System.Threading.Tasks.Task DoExtraRewardsIfNeeded()
 0254: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0259: stloc.s 5
 0261: ldloca.s 5
 0263: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0268: brtrue.s 335
 0270: ldarg.0 
 0271: ldc.i4.1 
 0272: dup 
 0273: stloc.0 
 0274: stfld field:Int32 <>1__state
 0279: ldarg.0 
 0280: ldloc.s 5
 0282: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0287: ldarg.0 
 0288: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0293: ldloca.s 5
 0295: ldarg.0 
 0296: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<OpenChest>d__26](System.Runtime.CompilerServices.TaskAwaiter ByRef, <OpenChest>d__26 ByRef)
 0301: leave 950
 0306: ldarg.0 
 0307: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0312: stloc.s 5
 0314: ldarg.0 
 0315: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0320: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0326: ldarg.0 
 0327: ldc.i4.m1 
 0328: dup 
 0329: stloc.0 
 0330: stfld field:Int32 <>1__state
 0335: ldloca.s 5
 0337: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0342: ldloc.1 
 0343: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection _relicCollection
 0348: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection.Void InitializeRelics()
 0353: ldloc.1 
 0354: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection _relicCollection
 0359: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection.Void AnimIn()
 0364: ldloc.1 
 0365: ldfld field:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton _chestButton
 0370: callvirt method:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton.Void AnimOut()
 0375: ldloc.1 
 0376: ldc.i4.1 
 0377: stfld field:Boolean _isRelicCollectionOpen
 0382: ldloc.1 
 0383: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom.Godot.Control get_DefaultFocusedControl()
 0388: dup 
 0389: brtrue.s 394
 0391: pop 
 0392: br.s 399
 0394: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.Void TryGrabFocus(Godot.Control)
 0399: ldloc.1 
 0400: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom.System.Threading.Tasks.Task RelicFtueCheck()
 0405: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0410: pop 
 0411: ldarg.0 
 0412: newobj method:System.Threading.CancellationTokenSource.Void .ctor()
 0417: stfld field:System.Threading.CancellationTokenSource <cancelSource>5__2
 0422: ldloc.1 
 0423: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0428: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0433: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Entities.Players.Player].Int32 get_Count()
 0438: ldc.i4.1 
 0439: bne.un.s 485
 0441: ldloc.1 
 0442: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0447: call method:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton.MegaCrit.Sts2.Core.Localization.LocString get_SkipLoc()
 0452: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton.Void UpdateText(MegaCrit.Sts2.Core.Localization.LocString)
 0457: ldloc.1 
 0458: ldc.r4 2.5
 0463: ldarg.0 
 0464: ldfld field:System.Threading.CancellationTokenSource <cancelSource>5__2
 0469: callvirt method:System.Threading.CancellationTokenSource.System.Threading.CancellationToken get_Token()
 0474: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom.System.Threading.Tasks.Task EnableSkipAfterDelay(Single, System.Threading.CancellationToken)
 0479: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0484: pop 
 0485: ldloc.1 
 0486: ldc.i4.1 
 0487: stfld field:Boolean _hasChestBeenOpened
 0492: ldloc.1 
 0493: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection _relicCollection
 0498: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection.System.Threading.Tasks.Task RelicPickingBegan()
 0503: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0508: stloc.s 6
 0510: ldloca.s 6
 0512: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0517: brtrue.s 584
 0519: ldarg.0 
 0520: ldc.i4.2 
 0521: dup 
 0522: stloc.0 
 0523: stfld field:Int32 <>1__state
 0528: ldarg.0 
 0529: ldloc.s 6
 0531: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0536: ldarg.0 
 0537: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0542: ldloca.s 6
 0544: ldarg.0 
 0545: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<OpenChest>d__26](System.Runtime.CompilerServices.TaskAwaiter ByRef, <OpenChest>d__26 ByRef)
 0550: leave 950
 0555: ldarg.0 
 0556: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0561: stloc.s 6
 0563: ldarg.0 
 0564: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0569: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0575: ldarg.0 
 0576: ldc.i4.m1 
 0577: dup 
 0578: stloc.0 
 0579: stfld field:Int32 <>1__state
 0584: ldloca.s 6
 0586: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0591: ldarg.0 
 0592: ldfld field:System.Threading.CancellationTokenSource <cancelSource>5__2
 0597: callvirt method:System.Threading.CancellationTokenSource.System.Threading.Tasks.Task CancelAsync()
 0602: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0607: stloc.s 7
 0609: ldloca.s 7
 0611: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0616: brtrue.s 683
 0618: ldarg.0 
 0619: ldc.i4.3 
 0620: dup 
 0621: stloc.0 
 0622: stfld field:Int32 <>1__state
 0627: ldarg.0 
 0628: ldloc.s 7
 0630: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0635: ldarg.0 
 0636: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0641: ldloca.s 7
 0643: ldarg.0 
 0644: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<OpenChest>d__26](System.Runtime.CompilerServices.TaskAwaiter ByRef, <OpenChest>d__26 ByRef)
 0649: leave 950
 0654: ldarg.0 
 0655: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0660: stloc.s 7
 0662: ldarg.0 
 0663: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0668: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0674: ldarg.0 
 0675: ldc.i4.m1 
 0676: dup 
 0677: stloc.0 
 0678: stfld field:Int32 <>1__state
 0683: ldloca.s 7
 0685: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0690: ldloc.1 
 0691: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0696: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Disable()
 0701: ldloc.1 
 0702: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection _relicCollection
 0707: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection.System.Threading.Tasks.Task RelicPickingFinished()
 0712: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0717: stloc.s 8
 0719: ldloca.s 8
 0721: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0726: brtrue.s 793
 0728: ldarg.0 
 0729: ldc.i4.4 
 0730: dup 
 0731: stloc.0 
 0732: stfld field:Int32 <>1__state
 0737: ldarg.0 
 0738: ldloc.s 8
 0740: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0745: ldarg.0 
 0746: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0751: ldloca.s 8
 0753: ldarg.0 
 0754: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<OpenChest>d__26](System.Runtime.CompilerServices.TaskAwaiter ByRef, <OpenChest>d__26 ByRef)
 0759: leave 950
 0764: ldarg.0 
 0765: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0770: stloc.s 8
 0772: ldarg.0 
 0773: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0778: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0784: ldarg.0 
 0785: ldc.i4.m1 
 0786: dup 
 0787: stloc.0 
 0788: stfld field:Int32 <>1__state
 0793: ldloca.s 8
 0795: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0800: ldloc.1 
 0801: ldc.i4.0 
 0802: stfld field:Boolean _isRelicCollectionOpen
 0807: ldloc.1 
 0808: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer _skipVoteContainer
 0813: ldc.i4.1 
 0814: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer.Void RefreshPlayerVotes(Boolean)
 0819: ldloc.1 
 0820: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0825: call method:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton.MegaCrit.Sts2.Core.Localization.LocString get_ProceedLoc()
 0830: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton.Void UpdateText(MegaCrit.Sts2.Core.Localization.LocString)
 0835: ldloc.1 
 0836: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0841: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Enable()
 0846: ldloc.1 
 0847: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NCommonBanner _banner
 0852: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NCommonBanner.Void AnimateOut()
 0857: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen get_Instance()
 0862: ldc.i4.1 
 0863: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Void SetTravelEnabled(Boolean)
 0868: ldloc.1 
 0869: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection _relicCollection
 0874: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection.Void AnimOut()
 0879: ldloc.1 
 0880: ldfld field:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton _chestButton
 0885: callvirt method:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton.Void AnimIn()
 0890: leave.s 924
 0892: stloc.s 9
 0894: ldarg.0 
 0895: ldc.i4.s -2
 0897: stfld field:Int32 <>1__state
 0902: ldarg.0 
 0903: ldnull 
 0904: stfld field:System.Threading.CancellationTokenSource <cancelSource>5__2
 0909: ldarg.0 
 0910: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0915: ldloc.s 9
 0917: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0922: leave.s 950
 0924: ldarg.0 
 0925: ldc.i4.s -2
 0927: stfld field:Int32 <>1__state
 0932: ldarg.0 
 0933: ldnull 
 0934: stfld field:System.Threading.CancellationTokenSource <cancelSource>5__2
 0939: ldarg.0 
 0940: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0945: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0950: ret 
