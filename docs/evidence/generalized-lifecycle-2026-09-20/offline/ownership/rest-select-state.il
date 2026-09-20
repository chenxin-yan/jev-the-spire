METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteButton <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse 156
 0020: ldloc.0 
 0021: ldc.i4.1 
 0022: beq 417
 0027: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom get_Instance()
 0032: callvirt method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption] get_Options()
 0037: ldarg.0 
 0038: ldfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption option
 0043: call method:MegaCrit.Sts2.Core.Extensions.ListExtensions.Int32 IndexOf[RestSiteOption](System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption], MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption)
 0048: stloc.2 
 0049: ldloc.2 
 0050: ldc.i4.0 
 0051: bge.s 112
 0053: ldc.i4.s 80
 0055: ldc.i4.1 
 0056: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0061: stloc.3 
 0062: ldloca.s 3
 0064: ldstr str:Rest site option 
 0069: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0074: ldloca.s 3
 0076: ldarg.0 
 0077: ldfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption option
 0082: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[RestSiteOption](MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption)
 0087: ldloca.s 3
 0089: ldstr str: was selected, but it was not in the list of rest site options!
 0094: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0099: ldloca.s 3
 0101: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0106: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0111: throw 
 0112: ldloc.1 
 0113: ldc.i4.1 
 0114: stfld field:Boolean _executingOption
 0119: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom get_Instance()
 0124: callvirt method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void DisableOptions()
 0129: ldloc.1 
 0130: call method:MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteButton.Void RefreshTextState()
 0135: ldarg.0 
 0136: ldc.i4.0 
 0137: stfld field:Boolean <success>5__2
 0142: ldarg.0 
 0143: ldnull 
 0144: stfld field:System.Object <>7__wrap2
 0149: ldarg.0 
 0150: ldc.i4.0 
 0151: stfld field:Int32 <>7__wrap3
 0156: nop 
 0157: ldloc.0 
 0158: brfalse.s 228
 0160: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0165: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer get_RestSiteSynchronizer()
 0170: ldloc.2 
 0171: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer.System.Threading.Tasks.Task`1[System.Boolean] ChooseLocalOption(Int32)
 0176: callvirt method:System.Threading.Tasks.Task`1[System.Boolean].System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] GetAwaiter()
 0181: stloc.s 5
 0183: ldloca.s 5
 0185: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean].Boolean get_IsCompleted()
 0190: brtrue.s 257
 0192: ldarg.0 
 0193: ldc.i4.0 
 0194: dup 
 0195: stloc.0 
 0196: stfld field:Int32 <>1__state
 0201: ldarg.0 
 0202: ldloc.s 5
 0204: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__1
 0209: ldarg.0 
 0210: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0215: ldloca.s 5
 0217: ldarg.0 
 0218: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<SelectOption>d__26](System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] ByRef, <SelectOption>d__26 ByRef)
 0223: leave 557
 0228: ldarg.0 
 0229: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__1
 0234: stloc.s 5
 0236: ldarg.0 
 0237: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__1
 0242: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean]
 0248: ldarg.0 
 0249: ldc.i4.m1 
 0250: dup 
 0251: stloc.0 
 0252: stfld field:Int32 <>1__state
 0257: ldloca.s 5
 0259: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean].Boolean GetResult()
 0264: stloc.s 4
 0266: ldarg.0 
 0267: ldloc.s 4
 0269: stfld field:Boolean <success>5__2
 0274: ldarg.0 
 0275: ldfld field:Boolean <success>5__2
 0280: brfalse.s 298
 0282: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom get_Instance()
 0287: ldarg.0 
 0288: ldfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption option
 0293: callvirt method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void AfterSelectingOption(MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption)
 0298: leave.s 312
 0300: stloc.s 6
 0302: ldarg.0 
 0303: ldloc.s 6
 0305: stfld field:System.Object <>7__wrap2
 0310: leave.s 312
 0312: ldloc.1 
 0313: ldc.i4.0 
 0314: stfld field:Boolean _executingOption
 0319: ldloc.1 
 0320: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.Boolean IsValid(Godot.Node)
 0325: brfalse.s 333
 0327: ldloc.1 
 0328: call method:MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteButton.Void RefreshTextState()
 0333: ldarg.0 
 0334: ldfld field:Boolean <success>5__2
 0339: brtrue.s 464
 0341: ldloc.1 
 0342: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.Boolean IsValid(Godot.Node)
 0347: brfalse.s 464
 0349: ldloc.1 
 0350: ldloca.s 8
 0352: initobj type:System.Threading.CancellationToken
 0358: ldloc.s 8
 0360: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.System.Threading.Tasks.Task`1[System.Single] AwaitProcessFrame(Godot.Node, System.Threading.CancellationToken)
 0365: callvirt method:System.Threading.Tasks.Task`1[System.Single].System.Runtime.CompilerServices.TaskAwaiter`1[System.Single] GetAwaiter()
 0370: stloc.s 7
 0372: ldloca.s 7
 0374: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Single].Boolean get_IsCompleted()
 0379: brtrue.s 446
 0381: ldarg.0 
 0382: ldc.i4.1 
 0383: dup 
 0384: stloc.0 
 0385: stfld field:Int32 <>1__state
 0390: ldarg.0 
 0391: ldloc.s 7
 0393: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Single] <>u__2
 0398: ldarg.0 
 0399: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0404: ldloca.s 7
 0406: ldarg.0 
 0407: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<SelectOption>d__26](System.Runtime.CompilerServices.TaskAwaiter`1[System.Single] ByRef, <SelectOption>d__26 ByRef)
 0412: leave 557
 0417: ldarg.0 
 0418: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Single] <>u__2
 0423: stloc.s 7
 0425: ldarg.0 
 0426: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Single] <>u__2
 0431: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Single]
 0437: ldarg.0 
 0438: ldc.i4.m1 
 0439: dup 
 0440: stloc.0 
 0441: stfld field:Int32 <>1__state
 0446: ldloca.s 7
 0448: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Single].Single GetResult()
 0453: pop 
 0454: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom get_Instance()
 0459: callvirt method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void EnableOptions()
 0464: ldarg.0 
 0465: ldfld field:System.Object <>7__wrap2
 0470: stloc.s 6
 0472: ldloc.s 6
 0474: brfalse.s 504
 0476: ldloc.s 6
 0478: isinst type:System.Exception
 0483: stloc.s 9
 0485: ldloc.s 9
 0487: brtrue.s 492
 0489: ldloc.s 6
 0491: throw 
 0492: ldloc.s 9
 0494: call method:System.Runtime.ExceptionServices.ExceptionDispatchInfo.System.Runtime.ExceptionServices.ExceptionDispatchInfo Capture(System.Exception)
 0499: callvirt method:System.Runtime.ExceptionServices.ExceptionDispatchInfo.Void Throw()
 0504: ldarg.0 
 0505: ldnull 
 0506: stfld field:System.Object <>7__wrap2
 0511: leave.s 538
 0513: stloc.s 9
 0515: ldarg.0 
 0516: ldc.i4.s -2
 0518: stfld field:Int32 <>1__state
 0523: ldarg.0 
 0524: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0529: ldloc.s 9
 0531: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0536: leave.s 557
 0538: ldarg.0 
 0539: ldc.i4.s -2
 0541: stfld field:Int32 <>1__state
 0546: ldarg.0 
 0547: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0552: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0557: ret 
