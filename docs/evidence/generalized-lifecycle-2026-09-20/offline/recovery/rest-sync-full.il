METHOD System.Threading.Tasks.Task`1[System.Boolean] ChooseLocalOption(Int32)
 0000: ldarg.0 
 0001: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0006: ldloca.s 1
 0008: ldc.i4.s 42
 0010: ldc.i4.1 
 0011: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0016: ldloca.s 1
 0018: ldstr str:Local player chose rest site option index 
 0023: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0028: ldloca.s 1
 0030: ldarg.1 
 0031: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Int32](Int32)
 0036: ldloca.s 1
 0038: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0043: ldc.i4.1 
 0044: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0049: ldloca.s 0
 0051: initobj type:MegaCrit.Sts2.Core.Multiplayer.Messages.Game.Sync.OptionIndexChosenMessage
 0057: ldloca.s 0
 0059: ldc.i4.1 
 0060: stfld field:MegaCrit.Sts2.Core.Multiplayer.Messages.Game.Sync.OptionIndexType type
 0065: ldloca.s 0
 0067: ldarg.1 
 0068: stfld field:UInt32 optionIndex
 0073: ldloca.s 0
 0075: ldarg.0 
 0076: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.RunLocationTargetedMessageBuffer _messageBuffer
 0081: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RunLocationTargetedMessageBuffer.MegaCrit.Sts2.Core.Runs.RunLocation get_CurrentLocation()
 0086: stfld field:MegaCrit.Sts2.Core.Runs.RunLocation location
 0091: ldarg.0 
 0092: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService _netService
 0097: ldloc.0 
 0098: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.INetGameService.Void SendMessage[OptionIndexChosenMessage](MegaCrit.Sts2.Core.Multiplayer.Messages.Game.Sync.OptionIndexChosenMessage)
 0103: ldarg.0 
 0104: ldarg.0 
 0105: call method:MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer.MegaCrit.Sts2.Core.Entities.Players.Player get_LocalPlayer()
 0110: ldarg.1 
 0111: call method:MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer.System.Threading.Tasks.Task`1[System.Boolean] ChooseOption(MegaCrit.Sts2.Core.Entities.Players.Player, Int32)
 0116: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse 443
 0020: ldloc.1 
 0021: ldfld field:MegaCrit.Sts2.Core.Runs.IPlayerCollection _playerCollection
 0026: ldarg.0 
 0027: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0032: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.Int32 GetPlayerSlotIndex(MegaCrit.Sts2.Core.Entities.Players.Player)
 0037: stloc.3 
 0038: ldarg.0 
 0039: ldloc.1 
 0040: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer+PlayerRestSite] _restSites
 0045: ldloc.3 
 0046: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer+PlayerRestSite].PlayerRestSite get_Item(Int32)
 0051: stfld field:PlayerRestSite <restSite>5__2
 0056: ldarg.0 
 0057: ldfld field:PlayerRestSite <restSite>5__2
 0062: ldfld field:System.Threading.Tasks.TaskCompletionSource completionTaskSource
 0067: callvirt method:System.Threading.Tasks.TaskCompletionSource.System.Threading.Tasks.Task get_Task()
 0072: callvirt method:System.Threading.Tasks.Task.Boolean get_IsCompleted()
 0077: brfalse.s 169
 0079: ldc.i4.s 98
 0081: ldc.i4.2 
 0082: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0087: stloc.s 5
 0089: ldloca.s 5
 0091: ldstr str:Player 
 0096: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0101: ldloca.s 5
 0103: ldarg.0 
 0104: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0109: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0114: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0119: ldloca.s 5
 0121: ldstr str: attempted to choose rest site option index 
 0126: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0131: ldloca.s 5
 0133: ldarg.0 
 0134: ldfld field:Int32 optionIndex
 0139: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Int32](Int32)
 0144: ldloca.s 5
 0146: ldstr str:, but the rest site has already been completed!
 0151: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0156: ldloca.s 5
 0158: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0163: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0168: throw 
 0169: ldarg.0 
 0170: ldfld field:Int32 optionIndex
 0175: ldarg.0 
 0176: ldfld field:PlayerRestSite <restSite>5__2
 0181: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption] options
 0186: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption].Int32 get_Count()
 0191: blt.s 318
 0193: ldc.i4.s 92
 0195: ldc.i4.3 
 0196: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0201: stloc.s 5
 0203: ldloca.s 5
 0205: ldstr str:Player 
 0210: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0215: ldloca.s 5
 0217: ldarg.0 
 0218: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0223: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0228: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0233: ldloca.s 5
 0235: ldstr str: attempted to choose rest site option index 
 0240: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0245: ldloca.s 5
 0247: ldarg.0 
 0248: ldfld field:Int32 optionIndex
 0253: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Int32](Int32)
 0258: ldloca.s 5
 0260: ldstr str:, but there were only 
 0265: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0270: ldloca.s 5
 0272: ldarg.0 
 0273: ldfld field:PlayerRestSite <restSite>5__2
 0278: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption] options
 0283: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption].Int32 get_Count()
 0288: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Int32](Int32)
 0293: ldloca.s 5
 0295: ldstr str: options available!
 0300: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0305: ldloca.s 5
 0307: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0312: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0317: throw 
 0318: ldarg.0 
 0319: ldarg.0 
 0320: ldfld field:PlayerRestSite <restSite>5__2
 0325: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption] options
 0330: ldarg.0 
 0331: ldfld field:Int32 optionIndex
 0336: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption].MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption get_Item(Int32)
 0341: stfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption <option>5__3
 0346: ldloc.1 
 0347: ldfld field:System.Action`2[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption,System.UInt64] BeforePlayerOptionChosen
 0352: dup 
 0353: brtrue.s 358
 0355: pop 
 0356: br.s 380
 0358: ldarg.0 
 0359: ldfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption <option>5__3
 0364: ldarg.0 
 0365: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0370: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0375: callvirt method:System.Action`2[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption,System.UInt64].Void Invoke(MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption, UInt64)
 0380: ldarg.0 
 0381: ldfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption <option>5__3
 0386: callvirt method:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption.System.Threading.Tasks.Task`1[System.Boolean] OnSelect()
 0391: callvirt method:System.Threading.Tasks.Task`1[System.Boolean].System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] GetAwaiter()
 0396: stloc.s 7
 0398: ldloca.s 7
 0400: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean].Boolean get_IsCompleted()
 0405: brtrue.s 472
 0407: ldarg.0 
 0408: ldc.i4.0 
 0409: dup 
 0410: stloc.0 
 0411: stfld field:Int32 <>1__state
 0416: ldarg.0 
 0417: ldloc.s 7
 0419: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__1
 0424: ldarg.0 
 0425: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean] <>t__builder
 0430: ldloca.s 7
 0432: ldarg.0 
 0433: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<ChooseOption>d__31](System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] ByRef, <ChooseOption>d__31 ByRef)
 0438: leave 1142
 0443: ldarg.0 
 0444: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__1
 0449: stloc.s 7
 0451: ldarg.0 
 0452: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__1
 0457: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean]
 0463: ldarg.0 
 0464: ldc.i4.m1 
 0465: dup 
 0466: stloc.0 
 0467: stfld field:Int32 <>1__state
 0472: ldloca.s 7
 0474: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean].Boolean GetResult()
 0479: stloc.s 6
 0481: ldloc.s 6
 0483: stloc.s 4
 0485: ldloc.1 
 0486: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0491: ldc.i4.s 66
 0493: ldc.i4.4 
 0494: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0499: stloc.s 5
 0501: ldloca.s 5
 0503: ldstr str:Rest site option index 
 0508: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0513: ldloca.s 5
 0515: ldarg.0 
 0516: ldfld field:Int32 optionIndex
 0521: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Int32](Int32)
 0526: ldloca.s 5
 0528: ldstr str: chosen for player 
 0533: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0538: ldloca.s 5
 0540: ldarg.0 
 0541: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0546: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0551: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0556: ldloca.s 5
 0558: ldstr str: with success 
 0563: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0568: ldloca.s 5
 0570: ldloc.s 4
 0572: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[Boolean](Boolean)
 0577: ldloca.s 5
 0579: ldstr str:. Option: 
 0584: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0589: ldloca.s 5
 0591: ldarg.0 
 0592: ldfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption <option>5__3
 0597: callvirt method:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption.System.String get_OptionId()
 0602: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted(System.String)
 0607: ldloca.s 5
 0609: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0614: ldc.i4.1 
 0615: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0620: ldarg.0 
 0621: ldfld field:PlayerRestSite <restSite>5__2
 0626: ldarg.0 
 0627: ldfld field:Int32 optionIndex
 0632: newobj method:System.Nullable`1[System.UInt32].Void .ctor(UInt32)
 0637: stfld field:System.Nullable`1[System.UInt32] lastChosenOptionIndex
 0642: ldloc.1 
 0643: ldfld field:System.Action`3[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption,System.Boolean,System.UInt64] AfterPlayerOptionChosen
 0648: dup 
 0649: brtrue.s 654
 0651: pop 
 0652: br.s 678
 0654: ldarg.0 
 0655: ldfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption <option>5__3
 0660: ldloc.s 4
 0662: ldarg.0 
 0663: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0668: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0673: callvirt method:System.Action`3[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption,System.Boolean,System.UInt64].Void Invoke(MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption, Boolean, UInt64)
 0678: ldloc.s 4
 0680: brtrue.s 689
 0682: ldc.i4.0 
 0683: stloc.2 
 0684: leave 1108
 0689: ldarg.0 
 0690: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0695: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0700: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.MegaCrit.Sts2.Core.Runs.History.MapPointHistoryEntry get_CurrentMapPointHistoryEntry()
 0705: dup 
 0706: brtrue.s 711
 0708: pop 
 0709: br.s 748
 0711: ldarg.0 
 0712: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0717: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0722: call method:MegaCrit.Sts2.Core.Runs.History.MapPointHistoryEntry.MegaCrit.Sts2.Core.Runs.PlayerMapPointHistoryEntry GetEntry(UInt64)
 0727: callvirt method:MegaCrit.Sts2.Core.Runs.PlayerMapPointHistoryEntry.System.Collections.Generic.List`1[System.String] get_RestSiteChoices()
 0732: ldarg.0 
 0733: ldfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption <option>5__3
 0738: callvirt method:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption.System.String get_OptionId()
 0743: callvirt method:System.Collections.Generic.List`1[System.String].Void Add(System.String)
 0748: ldarg.0 
 0749: ldfld field:PlayerRestSite <restSite>5__2
 0754: ldfld field:System.Threading.Tasks.TaskCompletionSource completionTaskSource
 0759: callvirt method:System.Threading.Tasks.TaskCompletionSource.System.Threading.Tasks.Task get_Task()
 0764: callvirt method:System.Threading.Tasks.Task.Boolean get_IsCompleted()
 0769: brfalse.s 778
 0771: ldc.i4.1 
 0772: stloc.2 
 0773: leave 1108
 0778: ldarg.0 
 0779: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0784: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0789: ldarg.0 
 0790: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0795: call method:MegaCrit.Sts2.Core.Hooks.Hook.Boolean ShouldDisableRemainingRestSiteOptions(MegaCrit.Sts2.Core.Runs.IRunState, MegaCrit.Sts2.Core.Entities.Players.Player)
 0800: brfalse.s 879
 0802: ldloc.1 
 0803: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0808: ldc.i4.s 52
 0810: ldc.i4.1 
 0811: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0816: stloc.s 5
 0818: ldloca.s 5
 0820: ldstr str:Clearing all remaining rest site options for player 
 0825: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0830: ldloca.s 5
 0832: ldarg.0 
 0833: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0838: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0843: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0848: ldloca.s 5
 0850: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0855: ldc.i4.1 
 0856: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0861: ldarg.0 
 0862: ldfld field:PlayerRestSite <restSite>5__2
 0867: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption] options
 0872: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption].Void Clear()
 0877: br.s 960
 0879: ldloc.1 
 0880: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0885: ldc.i4.s 55
 0887: ldc.i4.1 
 0888: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0893: stloc.s 5
 0895: ldloca.s 5
 0897: ldstr str:Leaving remaining rest site options enabled for player 
 0902: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0907: ldloca.s 5
 0909: ldarg.0 
 0910: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0915: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 0920: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 0925: ldloca.s 5
 0927: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0932: ldc.i4.1 
 0933: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0938: ldarg.0 
 0939: ldfld field:PlayerRestSite <restSite>5__2
 0944: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption] options
 0949: ldarg.0 
 0950: ldfld field:Int32 optionIndex
 0955: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption].Void RemoveAt(Int32)
 0960: ldarg.0 
 0961: ldfld field:PlayerRestSite <restSite>5__2
 0966: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption] options
 0971: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption].Int32 get_Count()
 0976: brtrue.s 1065
 0978: ldloc.1 
 0979: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0984: ldc.i4.s 66
 0986: ldc.i4.1 
 0987: newobj method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0992: stloc.s 5
 0994: ldloca.s 5
 0996: ldstr str:Completing rest site for player 
 1001: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 1006: ldloca.s 5
 1008: ldarg.0 
 1009: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 1014: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.UInt64 get_NetId()
 1019: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[UInt64](UInt64)
 1024: ldloca.s 5
 1026: ldstr str: because there are no options left
 1031: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 1036: ldloca.s 5
 1038: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 1043: ldc.i4.1 
 1044: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 1049: ldarg.0 
 1050: ldfld field:PlayerRestSite <restSite>5__2
 1055: ldfld field:System.Threading.Tasks.TaskCompletionSource completionTaskSource
 1060: callvirt method:System.Threading.Tasks.TaskCompletionSource.Void SetResult()
 1065: ldc.i4.1 
 1066: stloc.2 
 1067: leave.s 1108
 1069: stloc.s 8
 1071: ldarg.0 
 1072: ldc.i4.s -2
 1074: stfld field:Int32 <>1__state
 1079: ldarg.0 
 1080: ldnull 
 1081: stfld field:PlayerRestSite <restSite>5__2
 1086: ldarg.0 
 1087: ldnull 
 1088: stfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption <option>5__3
 1093: ldarg.0 
 1094: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean] <>t__builder
 1099: ldloc.s 8
 1101: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean].Void SetException(System.Exception)
 1106: leave.s 1142
 1108: ldarg.0 
 1109: ldc.i4.s -2
 1111: stfld field:Int32 <>1__state
 1116: ldarg.0 
 1117: ldnull 
 1118: stfld field:PlayerRestSite <restSite>5__2
 1123: ldarg.0 
 1124: ldnull 
 1125: stfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption <option>5__3
 1130: ldarg.0 
 1131: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean] <>t__builder
 1136: ldloc.2 
 1137: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Boolean].Void SetResult(Boolean)
 1142: ret 
