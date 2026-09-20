METHOD Void OnProceedButtonPressed(MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton)
 0000: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0005: ldfld field:System.Action debugAfterCombatRewardsOverride
 0010: brfalse.s 41
 0012: ldarg.0 
 0013: ldfld field:Boolean _isTerminal
 0018: brfalse.s 41
 0020: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0025: ldfld field:System.Action debugAfterCombatRewardsOverride
 0030: dup 
 0031: brtrue.s 35
 0033: pop 
 0034: ret 
 0035: callvirt method:System.Action.Void Invoke()
 0040: ret 
 0041: ldarg.0 
 0042: ldfld field:Boolean _isTerminal
 0047: brfalse 256
 0052: ldarg.0 
 0053: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0058: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.MegaCrit.Sts2.Core.Rooms.AbstractRoom get_CurrentRoom()
 0063: callvirt method:MegaCrit.Sts2.Core.Rooms.AbstractRoom.MegaCrit.Sts2.Core.Rooms.RoomType get_RoomType()
 0068: ldc.i4.3 
 0069: beq.s 92
 0071: ldarg.0 
 0072: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0077: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.MegaCrit.Sts2.Core.Rooms.AbstractRoom get_CurrentRoom()
 0082: callvirt method:MegaCrit.Sts2.Core.Rooms.AbstractRoom.Boolean get_IsVictoryRoom()
 0087: brfalse 256
 0092: ldarg.0 
 0093: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0098: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.MegaCrit.Sts2.Core.Map.ActMap get_Map()
 0103: callvirt method:MegaCrit.Sts2.Core.Map.ActMap.MegaCrit.Sts2.Core.Map.MapPoint get_SecondBossMapPoint()
 0108: brfalse.s 171
 0110: ldarg.0 
 0111: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0116: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.System.Nullable`1[MegaCrit.Sts2.Core.Map.MapCoord] get_CurrentMapCoord()
 0121: stloc.1 
 0122: ldarg.0 
 0123: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0128: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.MegaCrit.Sts2.Core.Map.ActMap get_Map()
 0133: callvirt method:MegaCrit.Sts2.Core.Map.ActMap.MegaCrit.Sts2.Core.Map.MapPoint get_BossMapPoint()
 0138: ldfld field:MegaCrit.Sts2.Core.Map.MapCoord coord
 0143: stloc.2 
 0144: ldloca.s 1
 0146: call method:System.Nullable`1[MegaCrit.Sts2.Core.Map.MapCoord].Boolean get_HasValue()
 0151: brtrue.s 156
 0153: ldc.i4.0 
 0154: br.s 172
 0156: ldloca.s 1
 0158: call method:System.Nullable`1[MegaCrit.Sts2.Core.Map.MapCoord].MegaCrit.Sts2.Core.Map.MapCoord GetValueOrDefault()
 0163: ldloc.2 
 0164: call method:MegaCrit.Sts2.Core.Map.MapCoord.Boolean op_Equality(MegaCrit.Sts2.Core.Map.MapCoord, MegaCrit.Sts2.Core.Map.MapCoord)
 0169: br.s 172
 0171: ldc.i4.0 
 0172: stloc.0 
 0173: ldloc.0 
 0174: brfalse.s 193
 0176: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0181: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.System.Threading.Tasks.Task ProceedFromTerminalRewardsScreen()
 0186: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0191: pop 
 0192: ret 
 0193: ldarg.0 
 0194: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0199: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Disable()
 0204: ldarg.0 
 0205: ldc.i4.1 
 0206: stfld field:Boolean _disableProceedForever
 0211: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0216: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.ActChangeSynchronizer get_ActChangeSynchronizer()
 0221: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.ActChangeSynchronizer.Boolean IsWaitingForOtherPlayers()
 0226: brfalse.s 240
 0228: ldarg.0 
 0229: ldfld field:Godot.Control _waitingForOtherPlayersOverlay
 0234: ldc.i4.1 
 0235: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0240: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0245: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.ActChangeSynchronizer get_ActChangeSynchronizer()
 0250: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.ActChangeSynchronizer.Void SetLocalPlayerReady()
 0255: ret 
 0256: ldarg.0 
 0257: ldfld field:Boolean _isTerminal
 0262: brfalse.s 377
 0264: ldarg.0 
 0265: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0270: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton.Boolean get_IsSkip()
 0275: brfalse.s 331
 0277: call method:MegaCrit.Sts2.Core.TestSupport.TestMode.Boolean get_IsOn()
 0282: brtrue.s 301
 0284: call method:MegaCrit.Sts2.Core.Saves.SaveManager.MegaCrit.Sts2.Core.Saves.SaveManager get_Instance()
 0289: ldstr str:combat_reward_ftue
 0294: callvirt method:MegaCrit.Sts2.Core.Saves.SaveManager.Boolean SeenFtue(System.String)
 0299: brfalse.s 318
 0301: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0306: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.System.Threading.Tasks.Task ProceedFromTerminalRewardsScreen()
 0311: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0316: pop 
 0317: ret 
 0318: ldarg.0 
 0319: call method:MegaCrit.Sts2.Core.Nodes.Screens.NRewardsScreen.System.Threading.Tasks.Task RewardFtueCheck()
 0324: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0329: pop 
 0330: ret 
 0331: ldarg.0 
 0332: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0337: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.Int32 get_ActFloor()
 0342: ldc.i4.4 
 0343: ble.s 360
 0345: call method:MegaCrit.Sts2.Core.Saves.SaveManager.MegaCrit.Sts2.Core.Saves.SaveManager get_Instance()
 0350: ldstr str:combat_reward_ftue
 0355: callvirt method:MegaCrit.Sts2.Core.Saves.SaveManager.Void MarkFtueAsComplete(System.String)
 0360: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0365: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.System.Threading.Tasks.Task ProceedFromTerminalRewardsScreen()
 0370: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0375: pop 
 0376: ret 
 0377: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0382: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer get_RewardsSetSynchronizer()
 0387: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer.Void SkipLocalRewardsSet()
 0392: call method:MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack.MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack get_Instance()
 0397: ldarg.0 
 0398: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack.Void Remove(MegaCrit.Sts2.Core.Nodes.Screens.Overlays.IOverlayScreen)
 0403: ret 
