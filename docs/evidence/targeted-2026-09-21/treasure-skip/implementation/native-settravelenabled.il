METHOD Void SetTravelEnabled(Boolean)
 0000: ldarg.0 
 0001: ldarg.1 
 0002: brfalse.s 17
 0004: ldarg.0 
 0005: ldfld field:MegaCrit.Sts2.Core.Runs.RunState _runState
 0010: call method:MegaCrit.Sts2.Core.Hooks.Hook.Boolean ShouldProceedToNextMapPoint(MegaCrit.Sts2.Core.Runs.IRunState)
 0015: br.s 18
 0017: ldc.i4.0 
 0018: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Void set_IsTravelEnabled(Boolean)
 0023: ldarg.0 
 0024: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Void RefreshAllPointVisuals()
 0029: ret 
