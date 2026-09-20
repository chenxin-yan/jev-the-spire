METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Entities.RestSite.SmithRestSiteOption <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse.s 125
 0017: ldloc.0 
 0018: ldc.i4.1 
 0019: beq 321
 0024: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.MegaCrit.Sts2.Core.Localization.LocString get_UpgradeSelectionPrompt()
 0029: ldloc.1 
 0030: call method:MegaCrit.Sts2.Core.Entities.RestSite.SmithRestSiteOption.Int32 get_SmithCount()
 0035: newobj method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Void .ctor(MegaCrit.Sts2.Core.Localization.LocString, Int32)
 0040: stloc.s 4
 0042: ldloca.s 4
 0044: ldc.i4.1 
 0045: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Void set_Cancelable(Boolean)
 0050: ldloca.s 4
 0052: ldc.i4.1 
 0053: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Void set_RequireManualConfirmation(Boolean)
 0058: ldloc.s 4
 0060: stloc.3 
 0061: ldloc.1 
 0062: call method:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0067: ldloc.3 
 0068: call method:MegaCrit.Sts2.Core.Commands.CardSelectCmd.System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] FromDeckForUpgrade(MegaCrit.Sts2.Core.Entities.Players.Player, MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs)
 0073: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0078: stloc.s 6
 0080: ldloca.s 6
 0082: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0087: brtrue.s 154
 0089: ldarg.0 
 0090: ldc.i4.0 
 0091: dup 
 0092: stloc.0 
 0093: stfld field:Int32 <>1__state
 0098: ldarg.0 
 0099: ldloc.s 6
 0101: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0106: ldarg.0 
 0107: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean] <>t__builder
 0112: ldloca.s 6
 0114: ldarg.0 
 0115: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<OnSelect>d__14](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <OnSelect>d__14 ByRef)
 0120: leave 406
 0125: ldarg.0 
 0126: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0131: stloc.s 6
 0133: ldarg.0 
 0134: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0139: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0145: ldarg.0 
 0146: ldc.i4.m1 
 0147: dup 
 0148: stloc.0 
 0149: stfld field:Int32 <>1__state
 0154: ldloca.s 6
 0156: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0161: stloc.s 5
 0163: ldloc.1 
 0164: ldloc.s 5
 0166: stfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] _selection
 0171: ldloc.1 
 0172: ldfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] _selection
 0177: call method:System.Linq.Enumerable.Boolean Any[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0182: brtrue.s 191
 0184: ldc.i4.0 
 0185: stloc.2 
 0186: leave 386
 0191: ldloc.1 
 0192: ldfld field:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] _selection
 0197: callvirt method:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel].System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Models.CardModel] GetEnumerator()
 0202: stloc.s 7
 0204: br.s 223
 0206: ldloc.s 7
 0208: callvirt method:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Models.CardModel].MegaCrit.Sts2.Core.Models.CardModel get_Current()
 0213: stloc.s 8
 0215: ldloc.s 8
 0217: ldc.i4.0 
 0218: call method:MegaCrit.Sts2.Core.Commands.CardCmd.Void Upgrade(MegaCrit.Sts2.Core.Models.CardModel, MegaCrit.Sts2.Core.Nodes.CommonUi.CardPreviewStyle)
 0223: ldloc.s 7
 0225: callvirt method:System.Collections.IEnumerator.Boolean MoveNext()
 0230: brtrue.s 206
 0232: leave.s 250
 0234: ldloc.0 
 0235: ldc.i4.0 
 0236: bge.s 249
 0238: ldloc.s 7
 0240: brfalse.s 249
 0242: ldloc.s 7
 0244: callvirt method:System.IDisposable.Void Dispose()
 0249: endfinally 
 0250: ldloc.1 
 0251: call method:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0256: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0261: ldloc.1 
 0262: call method:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0267: call method:MegaCrit.Sts2.Core.Hooks.Hook.System.Threading.Tasks.Task AfterRestSiteSmith(MegaCrit.Sts2.Core.Runs.IRunState, MegaCrit.Sts2.Core.Entities.Players.Player)
 0272: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0277: stloc.s 9
 0279: ldloca.s 9
 0281: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0286: brtrue.s 350
 0288: ldarg.0 
 0289: ldc.i4.1 
 0290: dup 
 0291: stloc.0 
 0292: stfld field:Int32 <>1__state
 0297: ldarg.0 
 0298: ldloc.s 9
 0300: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0305: ldarg.0 
 0306: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean] <>t__builder
 0311: ldloca.s 9
 0313: ldarg.0 
 0314: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean].Void AwaitUnsafeOnCompleted[TaskAwaiter,<OnSelect>d__14](System.Runtime.CompilerServices.TaskAwaiter ByRef, <OnSelect>d__14 ByRef)
 0319: leave.s 406
 0321: ldarg.0 
 0322: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0327: stloc.s 9
 0329: ldarg.0 
 0330: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__2
 0335: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0341: ldarg.0 
 0342: ldc.i4.m1 
 0343: dup 
 0344: stloc.0 
 0345: stfld field:Int32 <>1__state
 0350: ldloca.s 9
 0352: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0357: ldc.i4.1 
 0358: stloc.2 
 0359: leave.s 386
 0361: stloc.s 10
 0363: ldarg.0 
 0364: ldc.i4.s -2
 0366: stfld field:Int32 <>1__state
 0371: ldarg.0 
 0372: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean] <>t__builder
 0377: ldloc.s 10
 0379: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean].Void SetException(System.Exception)
 0384: leave.s 406
 0386: ldarg.0 
 0387: ldc.i4.s -2
 0389: stfld field:Int32 <>1__state
 0394: ldarg.0 
 0395: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean] <>t__builder
 0400: ldloc.2 
 0401: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean].Void SetResult(Boolean)
 0406: ret 
