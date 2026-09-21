METHOD System.Threading.Tasks.Task ExecuteAction()
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.GameActions.PickRelicAction.MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer get_TestSynchronizer()
 0006: dup 
 0007: brtrue.s 20
 0009: pop 
 0010: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0015: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer get_TreasureRoomRelicSynchronizer()
 0020: stloc.0 
 0021: ldloc.0 
 0022: ldarg.0 
 0023: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player _player
 0028: ldarg.0 
 0029: ldfld field:System.Nullable`1[System.Int32] _relicIndex
 0034: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.TreasureRoomRelicSynchronizer.Void OnPicked(MegaCrit.Sts2.Core.Entities.Players.Player, System.Nullable`1[System.Int32])
 0039: call method:System.Threading.Tasks.Task.System.Threading.Tasks.Task get_CompletedTask()
 0044: ret 
METHOD Void .ctor(MegaCrit.Sts2.Core.Entities.Players.Player, System.Nullable`1[System.Int32])
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.GameActions.GameAction.Void .ctor()
 0006: ldarg.0 
 0007: ldarg.1 
 0008: stfld field:MegaCrit.Sts2.Core.Entities.Players.Player _player
 0013: ldarg.0 
 0014: ldarg.2 
 0015: stfld field:System.Nullable`1[System.Int32] _relicIndex
 0020: ret 
