METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Runs.RunManager <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse.s 131
 0017: ldloc.1 
 0018: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunState get_State()
 0023: brtrue.s 30
 0025: leave 250
 0030: ldloc.1 
 0031: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunState get_State()
 0036: callvirt method:MegaCrit.Sts2.Core.Runs.RunState.Int32 get_CurrentRoomCount()
 0041: ldc.i4.1 
 0042: ble 205
 0047: ldloc.1 
 0048: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunState get_State()
 0053: callvirt method:MegaCrit.Sts2.Core.Runs.RunState.MegaCrit.Sts2.Core.Rooms.AbstractRoom get_CurrentRoom()
 0058: isinst type:MegaCrit.Sts2.Core.Rooms.CombatRoom
 0063: stloc.2 
 0064: ldloc.2 
 0065: brfalse.s 168
 0067: ldloc.2 
 0068: callvirt method:MegaCrit.Sts2.Core.Rooms.CombatRoom.Boolean get_ShouldResumeParentEventAfterCombat()
 0073: brfalse.s 168
 0075: ldloc.1 
 0076: call method:MegaCrit.Sts2.Core.Runs.RunManager.System.Threading.Tasks.Task ResumePreviousRoom()
 0081: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0086: stloc.3 
 0087: ldloca.s 3
 0089: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0094: brtrue.s 159
 0096: ldarg.0 
 0097: ldc.i4.0 
 0098: dup 
 0099: stloc.0 
 0100: stfld field:Int32 <>1__state
 0105: ldarg.0 
 0106: ldloc.3 
 0107: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0112: ldarg.0 
 0113: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0118: ldloca.s 3
 0120: ldarg.0 
 0121: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<ProceedFromTerminalRewardsScreen>d__211](System.Runtime.CompilerServices.TaskAwaiter ByRef, <ProceedFromTerminalRewardsScreen>d__211 ByRef)
 0126: leave 269
 0131: ldarg.0 
 0132: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0137: stloc.3 
 0138: ldarg.0 
 0139: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0144: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0150: ldarg.0 
 0151: ldc.i4.m1 
 0152: dup 
 0153: stloc.0 
 0154: stfld field:Int32 <>1__state
 0159: ldloca.s 3
 0161: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0166: br.s 223
 0168: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen get_Instance()
 0173: dup 
 0174: brtrue.s 179
 0176: pop 
 0177: br.s 185
 0179: ldc.i4.1 
 0180: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Void SetTravelEnabled(Boolean)
 0185: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen get_Instance()
 0190: dup 
 0191: brtrue.s 196
 0193: pop 
 0194: br.s 223
 0196: ldc.i4.0 
 0197: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen Open(Boolean)
 0202: pop 
 0203: br.s 223
 0205: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen get_Instance()
 0210: dup 
 0211: brtrue.s 216
 0213: pop 
 0214: br.s 223
 0216: ldc.i4.0 
 0217: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen Open(Boolean)
 0222: pop 
 0223: leave.s 250
 0225: stloc.s 4
 0227: ldarg.0 
 0228: ldc.i4.s -2
 0230: stfld field:Int32 <>1__state
 0235: ldarg.0 
 0236: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0241: ldloc.s 4
 0243: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0248: leave.s 269
 0250: ldarg.0 
 0251: ldc.i4.s -2
 0253: stfld field:Int32 <>1__state
 0258: ldarg.0 
 0259: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0264: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0269: ret 
