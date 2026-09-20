METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Nodes.Rewards.NRewardButton <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse.s 96
 0017: ldloc.1 
 0018: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Disable()
 0023: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0028: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer get_RewardsSetSynchronizer()
 0033: ldloc.1 
 0034: call method:MegaCrit.Sts2.Core.Nodes.Rewards.NRewardButton.MegaCrit.Sts2.Core.Rewards.Reward get_Reward()
 0039: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RewardsSetSynchronizer.System.Threading.Tasks.Task`1[System.Boolean] SelectLocalReward(MegaCrit.Sts2.Core.Rewards.Reward)
 0044: callvirt method:System.Threading.Tasks.Task`1[System.Boolean].System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] GetAwaiter()
 0049: stloc.s 4
 0051: ldloca.s 4
 0053: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean].Boolean get_IsCompleted()
 0058: brtrue.s 125
 0060: ldarg.0 
 0061: ldc.i4.0 
 0062: dup 
 0063: stloc.0 
 0064: stfld field:Int32 <>1__state
 0069: ldarg.0 
 0070: ldloc.s 4
 0072: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__1
 0077: ldarg.0 
 0078: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0083: ldloca.s 4
 0085: ldarg.0 
 0086: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<GetReward>d__26](System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] ByRef, <GetReward>d__26 ByRef)
 0091: leave 430
 0096: ldarg.0 
 0097: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__1
 0102: stloc.s 4
 0104: ldarg.0 
 0105: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean] <>u__1
 0110: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean]
 0116: ldarg.0 
 0117: ldc.i4.m1 
 0118: dup 
 0119: stloc.0 
 0120: stfld field:Int32 <>1__state
 0125: ldloca.s 4
 0127: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Boolean].Boolean GetResult()
 0132: stloc.3 
 0133: ldloc.3 
 0134: stloc.2 
 0135: ldloc.2 
 0136: brfalse 341
 0141: call method:MegaCrit.Sts2.Core.TestSupport.TestMode.Boolean get_IsOff()
 0146: brfalse 301
 0151: call method:MegaCrit.Sts2.Core.Nodes.NRun.MegaCrit.Sts2.Core.Nodes.NRun get_Instance()
 0156: callvirt method:MegaCrit.Sts2.Core.Nodes.NRun.MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi get_GlobalUi()
 0161: stloc.s 5
 0163: ldloc.1 
 0164: call method:MegaCrit.Sts2.Core.Nodes.Rewards.NRewardButton.MegaCrit.Sts2.Core.Rewards.Reward get_Reward()
 0169: stloc.s 8
 0171: ldloc.s 8
 0173: isinst type:MegaCrit.Sts2.Core.Rewards.RelicReward
 0178: stloc.s 6
 0180: ldloc.s 6
 0182: brfalse.s 199
 0184: ldloc.s 6
 0186: callvirt method:MegaCrit.Sts2.Core.Rewards.RelicReward.MegaCrit.Sts2.Core.Models.RelicModel get_ClaimedRelic()
 0191: stloc.s 9
 0193: ldloc.s 9
 0195: brfalse.s 301
 0197: br.s 214
 0199: ldloc.s 8
 0201: isinst type:MegaCrit.Sts2.Core.Rewards.PotionReward
 0206: stloc.s 7
 0208: ldloc.s 7
 0210: brtrue.s 261
 0212: br.s 301
 0214: ldloc.s 5
 0216: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi.MegaCrit.Sts2.Core.Nodes.Relics.NRelicInventory get_RelicInventory()
 0221: ldloc.s 6
 0223: callvirt method:MegaCrit.Sts2.Core.Rewards.RelicReward.MegaCrit.Sts2.Core.Models.RelicModel get_ClaimedRelic()
 0228: ldloc.1 
 0229: ldfld field:Godot.Control _iconContainer
 0234: callvirt method:Godot.Control.Godot.Vector2 get_GlobalPosition()
 0239: newobj method:System.Nullable`1[Godot.Vector2].Void .ctor(Godot.Vector2)
 0244: ldloca.s 10
 0246: initobj type:System.Nullable`1[Godot.Vector2]
 0252: ldloc.s 10
 0254: callvirt method:MegaCrit.Sts2.Core.Nodes.Relics.NRelicInventory.Void AnimateRelic(MegaCrit.Sts2.Core.Models.RelicModel, System.Nullable`1[Godot.Vector2], System.Nullable`1[Godot.Vector2])
 0259: br.s 301
 0261: ldloc.s 5
 0263: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi.MegaCrit.Sts2.Core.Nodes.CommonUi.NTopBar get_TopBar()
 0268: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NTopBar.MegaCrit.Sts2.Core.Nodes.Potions.NPotionContainer get_PotionContainer()
 0273: ldloc.s 7
 0275: callvirt method:MegaCrit.Sts2.Core.Rewards.PotionReward.MegaCrit.Sts2.Core.Models.PotionModel get_ClaimedPotion()
 0280: ldloc.1 
 0281: ldfld field:Godot.Control _iconContainer
 0286: callvirt method:Godot.Control.Godot.Vector2 get_GlobalPosition()
 0291: newobj method:System.Nullable`1[Godot.Vector2].Void .ctor(Godot.Vector2)
 0296: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionContainer.Void AnimatePotion(MegaCrit.Sts2.Core.Models.PotionModel, System.Nullable`1[Godot.Vector2])
 0301: ldloc.1 
 0302: ldc.i4.0 
 0303: stfld field:Boolean _isEnabled
 0308: ldloc.1 
 0309: ldsfld field:Godot.StringName RewardClaimed
 0314: ldc.i4.1 
 0315: newarr type:Godot.Variant
 0320: dup 
 0321: ldc.i4.0 
 0322: ldloc.1 
 0323: call method:Godot.Variant.Godot.Variant op_Implicit(Godot.GodotObject)
 0328: stelem type:Godot.Variant
 0333: call method:Godot.GodotObject.Godot.Error EmitSignal(Godot.StringName, Godot.Variant[])
 0338: pop 
 0339: br.s 384
 0341: ldloc.1 
 0342: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Enable()
 0347: ldloc.1 
 0348: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.Void TryGrabFocus(Godot.Control)
 0353: ldloc.1 
 0354: ldsfld field:Godot.StringName RewardSkipped
 0359: ldc.i4.1 
 0360: newarr type:Godot.Variant
 0365: dup 
 0366: ldc.i4.0 
 0367: ldloc.1 
 0368: call method:Godot.Variant.Godot.Variant op_Implicit(Godot.GodotObject)
 0373: stelem type:Godot.Variant
 0378: call method:Godot.GodotObject.Godot.Error EmitSignal(Godot.StringName, Godot.Variant[])
 0383: pop 
 0384: leave.s 411
 0386: stloc.s 11
 0388: ldarg.0 
 0389: ldc.i4.s -2
 0391: stfld field:Int32 <>1__state
 0396: ldarg.0 
 0397: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0402: ldloc.s 11
 0404: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0409: leave.s 430
 0411: ldarg.0 
 0412: ldc.i4.s -2
 0414: stfld field:Int32 <>1__state
 0419: ldarg.0 
 0420: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0425: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0430: ret 
