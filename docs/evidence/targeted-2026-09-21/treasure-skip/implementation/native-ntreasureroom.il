METHOD Void OnProceedButtonPressed(MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton)
 0000: ldarg.0 
 0001: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0006: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton.Boolean get_IsSkip()
 0011: brfalse.s 75
 0013: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0018: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer get_TreasureRoomRelicSynchronizer()
 0023: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.Void SkipRelicLocally()
 0028: ldarg.0 
 0029: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0034: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0039: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Entities.Players.Player].Int32 get_Count()
 0044: ldc.i4.1 
 0045: bne.un.s 91
 0047: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen get_Instance()
 0052: ldc.i4.1 
 0053: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Void SetTravelEnabled(Boolean)
 0058: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0063: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.System.Threading.Tasks.Task ProceedFromTerminalRewardsScreen()
 0068: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0073: pop 
 0074: ret 
 0075: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0080: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.System.Threading.Tasks.Task ProceedFromTerminalRewardsScreen()
 0085: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0090: pop 
 0091: ret 
METHOD Void OnProceedButtonReleased(MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton)
 0000: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen get_Instance()
 0005: ldc.i4.0 
 0006: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen Open(Boolean)
 0011: pop 
 0012: ret 
METHOD Void _ExitTree()
 0000: ldarg.0 
 0001: ldfld field:System.Threading.CancellationTokenSource _cts
 0006: callvirt method:System.Threading.CancellationTokenSource.Void Cancel()
 0011: call method:MegaCrit.Sts2.Core.Nodes.Screens.ScreenContext.ActiveScreenContext.MegaCrit.Sts2.Core.Nodes.Screens.ScreenContext.ActiveScreenContext get_Instance()
 0016: ldarg.0 
 0017: ldftn method:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom.Void OnActiveScreenChanged()
 0023: newobj method:System.Action.Void .ctor(System.Object, IntPtr)
 0028: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.ScreenContext.ActiveScreenContext.Void remove_Updated(System.Action)
 0033: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0038: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer get_TreasureRoomRelicSynchronizer()
 0043: ldarg.0 
 0044: ldftn method:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom.Void RefreshVotes()
 0050: newobj method:System.Action.Void .ctor(System.Object, IntPtr)
 0055: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.Void remove_VotesChanged(System.Action)
 0060: call method:MegaCrit.Sts2.Core.Nodes.NGame.MegaCrit.Sts2.Core.Nodes.NGame get_Instance()
 0065: callvirt method:MegaCrit.Sts2.Core.Nodes.NGame.Void ClearScreenShakeTarget()
 0070: ret 
METHOD Void _Ready()
 0000: ldarg.0 
 0001: ldarg.0 
 0002: ldstr str:%Banner
 0007: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0012: call method:Godot.Node.MegaCrit.Sts2.Core.Nodes.CommonUi.NCommonBanner GetNode[NCommonBanner](Godot.NodePath)
 0017: stfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NCommonBanner _banner
 0022: ldarg.0 
 0023: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0028: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0033: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Entities.Players.Player].Int32 get_Count()
 0038: ldc.i4.1 
 0039: bne.un.s 79
 0041: ldarg.0 
 0042: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NCommonBanner _banner
 0047: ldfld field:MegaCrit.Sts2.addons.mega_text.MegaLabel label
 0052: ldstr str:gameplay_ui
 0057: ldstr str:TREASURE_BANNER
 0062: newobj method:MegaCrit.Sts2.Core.Localization.LocString.Void .ctor(System.String, System.String)
 0067: call method:MegaCrit.Sts2.Core.Localization.LocString.System.String GetRawText()
 0072: callvirt method:MegaCrit.Sts2.addons.mega_text.MegaLabel.Void SetTextAutoSize(System.String)
 0077: br.s 115
 0079: ldarg.0 
 0080: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NCommonBanner _banner
 0085: ldfld field:MegaCrit.Sts2.addons.mega_text.MegaLabel label
 0090: ldstr str:gameplay_ui
 0095: ldstr str:CHOOSE_SHARED_RELIC_HEADER
 0100: newobj method:MegaCrit.Sts2.Core.Localization.LocString.Void .ctor(System.String, System.String)
 0105: call method:MegaCrit.Sts2.Core.Localization.LocString.System.String GetRawText()
 0110: callvirt method:MegaCrit.Sts2.addons.mega_text.MegaLabel.Void SetTextAutoSize(System.String)
 0115: ldarg.0 
 0116: ldarg.0 
 0117: ldstr str:%ProceedButton
 0122: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0127: call method:Godot.Node.MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton GetNode[NProceedButton](Godot.NodePath)
 0132: stfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0137: ldarg.0 
 0138: ldarg.0 
 0139: ldstr str:%GoldExplosion
 0144: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0149: call method:Godot.Node.Godot.GpuParticles2D GetNode[GpuParticles2D](Godot.NodePath)
 0154: stfld field:Godot.GpuParticles2D _goldParticles
 0159: ldarg.0 
 0160: ldarg.0 
 0161: ldstr str:%RelicCollection
 0166: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0171: call method:Godot.Node.MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection GetNode[NTreasureRoomRelicCollection](Godot.NodePath)
 0176: stfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection _relicCollection
 0181: ldarg.0 
 0182: ldarg.0 
 0183: ldstr str:%SkipMultiplayerVoteContainer
 0188: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0193: call method:Godot.Node.MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer GetNode[NMultiplayerVoteContainer](Godot.NodePath)
 0198: stfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer _skipVoteContainer
 0203: ldarg.0 
 0204: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection _relicCollection
 0209: ldarg.0 
 0210: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0215: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection.Void Initialize(MegaCrit.Sts2.Core.Runs.IRunState)
 0220: ldarg.0 
 0221: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection _relicCollection
 0226: ldc.i4.0 
 0227: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0232: ldarg.0 
 0233: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0238: ldsfld field:Godot.StringName Released
 0243: ldarg.0 
 0244: ldftn method:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom.Void OnProceedButtonPressed(MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton)
 0250: newobj method:System.Action`1[MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton].Void .ctor(System.Object, IntPtr)
 0255: call method:Godot.Callable.Godot.Callable From[NButton](System.Action`1[MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton])
 0260: ldc.i4.0 
 0261: callvirt method:Godot.GodotObject.Godot.Error Connect(Godot.StringName, Godot.Callable, UInt32)
 0266: pop 
 0267: ldarg.0 
 0268: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0273: call method:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton.MegaCrit.Sts2.Core.Localization.LocString get_ProceedLoc()
 0278: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton.Void UpdateText(MegaCrit.Sts2.Core.Localization.LocString)
 0283: ldarg.0 
 0284: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer _skipVoteContainer
 0289: ldarg.0 
 0290: ldftn method:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom.Boolean IsPlayerVotingForSkip(MegaCrit.Sts2.Core.Entities.Players.Player)
 0296: newobj method:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+PlayerVotedDelegate.Void .ctor(System.Object, IntPtr)
 0301: ldarg.0 
 0302: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0307: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0312: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer.Void Initialize(PlayerVotedDelegate, System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player])
 0317: ldarg.0 
 0318: ldarg.0 
 0319: ldstr str:%Chest
 0324: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0329: call method:Godot.Node.MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton GetNode[NTreasureButton](Godot.NodePath)
 0334: stfld field:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton _chestButton
 0339: ldarg.0 
 0340: ldfld field:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton _chestButton
 0345: ldsfld field:Godot.StringName MouseEntered
 0350: ldarg.0 
 0351: ldftn method:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom.Void OnMouseEntered()
 0357: newobj method:System.Action.Void .ctor(System.Object, IntPtr)
 0362: call method:Godot.Callable.Godot.Callable From(System.Action)
 0367: ldc.i4.0 
 0368: callvirt method:Godot.GodotObject.Godot.Error Connect(Godot.StringName, Godot.Callable, UInt32)
 0373: pop 
 0374: ldarg.0 
 0375: ldfld field:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton _chestButton
 0380: ldsfld field:Godot.StringName MouseExited
 0385: ldarg.0 
 0386: ldftn method:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom.Void OnMouseExited()
 0392: newobj method:System.Action.Void .ctor(System.Object, IntPtr)
 0397: call method:Godot.Callable.Godot.Callable From(System.Action)
 0402: ldc.i4.0 
 0403: callvirt method:Godot.GodotObject.Godot.Error Connect(Godot.StringName, Godot.Callable, UInt32)
 0408: pop 
 0409: ldarg.0 
 0410: ldfld field:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton _chestButton
 0415: ldsfld field:Godot.StringName Released
 0420: ldarg.0 
 0421: ldftn method:MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom.Void OnChestButtonReleased(MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton)
 0427: newobj method:System.Action`1[MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton].Void .ctor(System.Object, IntPtr)
 0432: call method:Godot.Callable.Godot.Callable From[NButton](System.Action`1[MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton])
 0437: ldc.i4.0 
 0438: callvirt method:Godot.GodotObject.Godot.Error Connect(Godot.StringName, Godot.Callable, UInt32)
 0443: pop 
 0444: ldarg.0 
 0445: ldfld field:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton _chestButton
 0450: ldarg.0 
 0451: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0456: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.MegaCrit.Sts2.Core.Models.ActModel get_Act()
 0461: callvirt method:MegaCrit.Sts2.Core.Nodes.TreasureRooms.NTreasureButton.Void Setup(MegaCrit.Sts2.Core.Models.ActModel)
 0466: call method:MegaCrit.Sts2.Core.Nodes.NGame.MegaCrit.Sts2.Core.Nodes.NGame get_Instance()
 0471: ldarg.0 
 0472: callvirt method:MegaCrit.Sts2.Core.Nodes.NGame.Void SetScreenShakeTarget(Godot.Control)
 0477: ret 
