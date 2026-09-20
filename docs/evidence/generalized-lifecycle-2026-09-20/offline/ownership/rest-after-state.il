METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse 167
 0020: ldloc.0 
 0021: ldc.i4.1 
 0022: beq 295
 0027: ldloc.1 
 0028: ldloc.1 
 0029: ldfld field:System.Threading.CancellationTokenSource _cts
 0034: callvirt method:System.Threading.CancellationTokenSource.System.Threading.CancellationToken get_Token()
 0039: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.System.Threading.Tasks.Task HideChoices(System.Threading.CancellationToken)
 0044: stloc.2 
 0045: ldarg.0 
 0046: ldfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption option
 0051: ldloc.1 
 0052: ldfld field:System.Threading.CancellationTokenSource _cts
 0057: callvirt method:System.Threading.CancellationTokenSource.System.Threading.CancellationToken get_Token()
 0062: callvirt method:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption.System.Threading.Tasks.Task DoLocalPostSelectVfx(System.Threading.CancellationToken)
 0067: stloc.3 
 0068: ldloc.1 
 0069: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void ExtinguishFireIfAble()
 0074: ldloca.s 4
 0076: initobj type:<>y__InlineArray2`1[System.Threading.Tasks.Task]
 0082: ldloca.s 4
 0084: ldc.i4.0 
 0085: call method:<PrivateImplementationDetails>.System.Threading.Tasks.Task& InlineArrayElementRef[<>y__InlineArray2`1,Task](<>y__InlineArray2`1[System.Threading.Tasks.Task] ByRef, Int32)
 0090: ldloc.2 
 0091: stind.ref 
 0092: ldloca.s 4
 0094: ldc.i4.1 
 0095: call method:<PrivateImplementationDetails>.System.Threading.Tasks.Task& InlineArrayElementRef[<>y__InlineArray2`1,Task](<>y__InlineArray2`1[System.Threading.Tasks.Task] ByRef, Int32)
 0100: ldloc.3 
 0101: stind.ref 
 0102: ldloca.s 4
 0104: ldc.i4.2 
 0105: call method:<PrivateImplementationDetails>.System.ReadOnlySpan`1[System.Threading.Tasks.Task] InlineArrayAsReadOnlySpan[<>y__InlineArray2`1,Task](<>y__InlineArray2`1[System.Threading.Tasks.Task] ByRef, Int32)
 0110: call method:System.Threading.Tasks.Task.System.Threading.Tasks.Task WhenAll(System.ReadOnlySpan`1[System.Threading.Tasks.Task])
 0115: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0120: stloc.s 5
 0122: ldloca.s 5
 0124: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0129: brtrue.s 196
 0131: ldarg.0 
 0132: ldc.i4.0 
 0133: dup 
 0134: stloc.0 
 0135: stfld field:Int32 <>1__state
 0140: ldarg.0 
 0141: ldloc.s 5
 0143: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0148: ldarg.0 
 0149: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0154: ldloca.s 5
 0156: ldarg.0 
 0157: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<AfterSelectingOptionAsync>d__60](System.Runtime.CompilerServices.TaskAwaiter ByRef, <AfterSelectingOptionAsync>d__60 ByRef)
 0162: leave 394
 0167: ldarg.0 
 0168: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0173: stloc.s 5
 0175: ldarg.0 
 0176: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0181: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0187: ldarg.0 
 0188: ldc.i4.m1 
 0189: dup 
 0190: stloc.0 
 0191: stfld field:Int32 <>1__state
 0196: ldloca.s 5
 0198: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0203: ldloc.1 
 0204: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void UpdateRestSiteOptions()
 0209: ldloc.1 
 0210: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void ShowProceedButton()
 0215: ldloc.1 
 0216: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption] get_Options()
 0221: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption].Int32 get_Count()
 0226: ldc.i4.0 
 0227: ble.s 348
 0229: ldloc.1 
 0230: ldloc.1 
 0231: ldfld field:System.Threading.CancellationTokenSource _cts
 0236: callvirt method:System.Threading.CancellationTokenSource.System.Threading.CancellationToken get_Token()
 0241: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.System.Threading.Tasks.Task ShowChoices(System.Threading.CancellationToken)
 0246: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0251: stloc.s 6
 0253: ldloca.s 6
 0255: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0260: brtrue.s 324
 0262: ldarg.0 
 0263: ldc.i4.1 
 0264: dup 
 0265: stloc.0 
 0266: stfld field:Int32 <>1__state
 0271: ldarg.0 
 0272: ldloc.s 6
 0274: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0279: ldarg.0 
 0280: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0285: ldloca.s 6
 0287: ldarg.0 
 0288: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<AfterSelectingOptionAsync>d__60](System.Runtime.CompilerServices.TaskAwaiter ByRef, <AfterSelectingOptionAsync>d__60 ByRef)
 0293: leave.s 394
 0295: ldarg.0 
 0296: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0301: stloc.s 6
 0303: ldarg.0 
 0304: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0309: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0315: ldarg.0 
 0316: ldc.i4.m1 
 0317: dup 
 0318: stloc.0 
 0319: stfld field:Int32 <>1__state
 0324: ldloca.s 6
 0326: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0331: ldloc.1 
 0332: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Godot.Control get_DefaultFocusedControl()
 0337: dup 
 0338: brtrue.s 343
 0340: pop 
 0341: br.s 348
 0343: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.Void TryGrabFocus(Godot.Control)
 0348: leave.s 375
 0350: stloc.s 7
 0352: ldarg.0 
 0353: ldc.i4.s -2
 0355: stfld field:Int32 <>1__state
 0360: ldarg.0 
 0361: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0366: ldloc.s 7
 0368: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0373: leave.s 394
 0375: ldarg.0 
 0376: ldc.i4.s -2
 0378: stfld field:Int32 <>1__state
 0383: ldarg.0 
 0384: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0389: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0394: ret 
