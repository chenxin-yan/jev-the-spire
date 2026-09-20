METHOD Void .ctor(MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer)
 0000: ldarg.0 
 0001: newobj method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward].Void .ctor()
 0006: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Rewards.Reward] <Rewards>k__BackingField
 0011: ldarg.0 
 0012: ldc.i4.1 
 0013: stfld field:Boolean <ThrowInTestIfRewardsNotTaken>k__BackingField
 0018: ldarg.0 
 0019: ldc.i4.m1 
 0020: stfld field:Int32 <Id>k__BackingField
 0025: ldarg.0 
 0026: call method:System.Object.Void .ctor()
 0031: ldarg.0 
 0032: ldarg.1 
 0033: stfld field:MegaCrit.Sts2.Core.Entities.Players.Player <Player>k__BackingField
 0038: ldarg.0 
 0039: ldarg.2 
 0040: dup 
 0041: brtrue.s 54
 0043: pop 
 0044: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0049: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer get_RewardsSetSynchronizer()
 0054: stfld field:MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer _synchronizer
 0059: ret 
