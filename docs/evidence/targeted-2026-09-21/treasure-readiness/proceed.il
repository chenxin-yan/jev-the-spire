METHOD Void OnProceedButtonReleased(MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton)
 0000: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen get_Instance()
 0005: ldc.i4.0 
 0006: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen Open(Boolean)
 0011: pop 
 0012: ret 
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
