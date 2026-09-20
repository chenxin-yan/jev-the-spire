METHOD Void .ctor()
 0000: ldarg.0 
 0001: ldc.r4 0.9
 0006: call method:Godot.Vector2.Godot.Vector2 get_One()
 0011: call method:Godot.Vector2.Godot.Vector2 op_Multiply(Single, Godot.Vector2)
 0016: stfld field:Godot.Vector2 _potionScale
 0021: ldarg.0 
 0022: newobj method:System.Threading.CancellationTokenSource.Void .ctor()
 0027: stfld field:System.Threading.CancellationTokenSource _cts
 0032: ldarg.0 
 0033: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void .ctor()
 0038: ret 
METHOD Void _Ready()
 0000: ldarg.0 
 0001: ldarg.0 
 0002: ldstr str:%EmptyIcon
 0007: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0012: call method:Godot.Node.Godot.TextureRect GetNode[TextureRect](Godot.NodePath)
 0017: stfld field:Godot.TextureRect _emptyIcon
 0022: ldarg.0 
 0023: ldarg.0 
 0024: ldstr str:%SelectionReticle
 0029: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0034: call method:Godot.Node.MegaCrit.Sts2.Core.Nodes.Combat.NSelectionReticle GetNode[NSelectionReticle](Godot.NodePath)
 0039: stfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectionReticle _selectionReticle
 0044: ldarg.0 
 0045: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void ConnectSignals()
 0050: ret 
METHOD Void OnRelease()
 0000: ldarg.0 
 0001: ldfld field:Boolean _isUsable
 0006: brfalse.s 14
 0008: ldarg.0 
 0009: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.Void OpenPotionPopup()
 0014: ldarg.0 
 0015: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0020: brfalse.s 41
 0022: ldarg.0 
 0023: ldfld field:Boolean _isUsable
 0028: brfalse.s 41
 0030: ldarg.0 
 0031: call method:Godot.Node.Godot.Viewport GetViewport()
 0036: callvirt method:Godot.Viewport.Void SetInputAsHandled()
 0041: ret 
METHOD Void OpenPotionPopup()
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.Boolean get_HasPotion()
 0006: brfalse.s 74
 0008: ldarg.0 
 0009: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0014: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotion.MegaCrit.Sts2.Core.Models.PotionModel get_Model()
 0019: callvirt method:MegaCrit.Sts2.Core.Models.PotionModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0024: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0029: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.Boolean get_IsGameOver()
 0034: brtrue.s 74
 0036: ldarg.0 
 0037: ldfld field:Boolean _disabledUntilPotionRemoved
 0042: brtrue.s 74
 0044: ldarg.0 
 0045: call method:MegaCrit.Sts2.Core.Nodes.HoverTips.NHoverTipSet.Void Remove(Godot.Control)
 0050: ldarg.0 
 0051: ldarg.0 
 0052: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionPopup.MegaCrit.Sts2.Core.Nodes.Potions.NPotionPopup Create(MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder)
 0057: stfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotionPopup _popup
 0062: ldarg.0 
 0063: ldarg.0 
 0064: ldfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotionPopup _popup
 0069: call method:MegaCrit.Sts2.Core.Helpers.GodotTreeExtensions.Void AddChildSafely(Godot.Node, Godot.Node)
 0074: ret 
METHOD Void AddPotion(MegaCrit.Sts2.Core.Nodes.Potions.NPotion)
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0006: brfalse.s 19
 0008: ldstr str:Slot already contains a potion
 0013: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0018: throw 
 0019: ldarg.0 
 0020: ldarg.1 
 0021: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.Void set_Potion(MegaCrit.Sts2.Core.Nodes.Potions.NPotion)
 0026: ldarg.0 
 0027: ldfld field:Godot.Tween _emptyPotionTween
 0032: dup 
 0033: brtrue.s 38
 0035: pop 
 0036: br.s 43
 0038: call method:Godot.Tween.Void Kill()
 0043: ldarg.0 
 0044: ldfld field:Godot.TextureRect _emptyIcon
 0049: call method:Godot.Colors.Godot.Color get_Transparent()
 0054: callvirt method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0059: ldarg.0 
 0060: ldarg.0 
 0061: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0066: call method:MegaCrit.Sts2.Core.Helpers.GodotTreeExtensions.Void AddChildSafely(Godot.Node, Godot.Node)
 0071: ldarg.0 
 0072: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0077: ldarg.0 
 0078: ldfld field:Godot.Vector2 _potionScale
 0083: callvirt method:Godot.Control.Void set_Scale(Godot.Vector2)
 0088: ldarg.0 
 0089: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0094: ldarg.0 
 0095: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0100: callvirt method:Godot.Control.Godot.Vector2 get_Size()
 0105: ldc.r4 0.5
 0110: call method:Godot.Vector2.Godot.Vector2 op_Multiply(Godot.Vector2, Single)
 0115: callvirt method:Godot.Control.Void set_PivotOffset(Godot.Vector2)
 0120: ret 
METHOD Void DisableUntilPotionRemoved()
 0000: ldarg.0 
 0001: ldfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotionPopup _popup
 0006: brfalse.s 32
 0008: ldarg.0 
 0009: ldfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotionPopup _popup
 0014: call method:Godot.GodotObject.Boolean IsInstanceValid(Godot.GodotObject)
 0019: brfalse.s 32
 0021: ldarg.0 
 0022: ldfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotionPopup _popup
 0027: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionPopup.Void Remove()
 0032: ldarg.0 
 0033: ldc.i4.1 
 0034: stfld field:Boolean _disabledUntilPotionRemoved
 0039: ldarg.0 
 0040: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.System.Threading.Tasks.Task GrayPotionHolderUntilPlayedAfterDelay()
 0045: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0050: pop 
 0051: ldarg.0 
 0052: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.Void TryGrabFocus(Godot.Control)
 0057: ret 
METHOD Void CancelPotionUseOrDiscard()
 0000: ldarg.0 
 0001: ldfld field:System.Threading.CancellationTokenSource _cancelGrayOutPotionSource
 0006: dup 
 0007: brtrue.s 12
 0009: pop 
 0010: br.s 17
 0012: call method:System.Threading.CancellationTokenSource.Void Cancel()
 0017: ldarg.0 
 0018: ldc.i4.0 
 0019: stfld field:Boolean _disabledUntilPotionRemoved
 0024: ldarg.0 
 0025: call method:Godot.Colors.Godot.Color get_White()
 0030: call method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0035: ret 
METHOD Void RemoveUsedPotion()
 0000: newobj method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder+<>c__DisplayClass39_0.Void .ctor()
 0005: stloc.0 
 0006: ldloc.0 
 0007: ldarg.0 
 0008: stfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder <>4__this
 0013: ldarg.0 
 0014: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0019: brtrue.s 32
 0021: ldstr str:This slot doesn't contain a potion
 0026: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0031: throw 
 0032: ldarg.0 
 0033: ldfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotionPopup _popup
 0038: brfalse.s 64
 0040: ldarg.0 
 0041: ldfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotionPopup _popup
 0046: call method:Godot.GodotObject.Boolean IsInstanceValid(Godot.GodotObject)
 0051: brfalse.s 64
 0053: ldarg.0 
 0054: ldfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotionPopup _popup
 0059: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionPopup.Void Remove()
 0064: ldarg.0 
 0065: call method:MegaCrit.Sts2.Core.Nodes.HoverTips.NHoverTipSet.Void Remove(Godot.Control)
 0070: ldarg.0 
 0071: ldc.i4.0 
 0072: stfld field:Boolean _disabledUntilPotionRemoved
 0077: ldarg.0 
 0078: ldfld field:System.Threading.CancellationTokenSource _cancelGrayOutPotionSource
 0083: dup 
 0084: brtrue.s 89
 0086: pop 
 0087: br.s 94
 0089: call method:System.Threading.CancellationTokenSource.Void Cancel()
 0094: ldarg.0 
 0095: call method:Godot.Colors.Godot.Color get_White()
 0100: call method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0105: ldloc.0 
 0106: ldarg.0 
 0107: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0112: stfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotion potionToRemove
 0117: ldarg.0 
 0118: ldnull 
 0119: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.Void set_Potion(MegaCrit.Sts2.Core.Nodes.Potions.NPotion)
 0124: ldarg.0 
 0125: call method:Godot.Node.Godot.Tween CreateTween()
 0130: stloc.1 
 0131: ldloc.1 
 0132: ldloc.0 
 0133: ldfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotion potionToRemove
 0138: ldstr str:scale
 0143: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0148: call method:Godot.Vector2.Godot.Vector2 get_Zero()
 0153: call method:Godot.Variant.Godot.Variant op_Implicit(Godot.Vector2)
 0158: ldc.r8 0.20000000298023224
 0167: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 0172: ldc.i4.0 
 0173: conv.i8 
 0174: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetEase(EaseType)
 0179: ldc.i4.s 10
 0181: conv.i8 
 0182: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetTrans(TransitionType)
 0187: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener FromCurrent()
 0192: pop 
 0193: ldloc.1 
 0194: ldloc.0 
 0195: ldftn method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder+<>c__DisplayClass39_0.Void <RemoveUsedPotion>b__0()
 0201: newobj method:System.Action.Void .ctor(System.Object, IntPtr)
 0206: call method:Godot.Callable.Godot.Callable From(System.Action)
 0211: callvirt method:Godot.Tween.Godot.CallbackTweener TweenCallback(Godot.Callable)
 0216: pop 
 0217: ldarg.0 
 0218: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Boolean get_IsFocused()
 0223: brfalse.s 306
 0225: ldarg.0 
 0226: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.HoverTips.HoverTip get_EmptyHoverTip()
 0231: box type:MegaCrit.Sts2.Core.HoverTips.HoverTip
 0236: ldc.i4.0 
 0237: call method:MegaCrit.Sts2.Core.Nodes.HoverTips.NHoverTipSet.MegaCrit.Sts2.Core.Nodes.HoverTips.NHoverTipSet CreateAndShow(Godot.Control, MegaCrit.Sts2.Core.HoverTips.IHoverTip, MegaCrit.Sts2.Core.HoverTips.HoverTipAlignment)
 0242: stloc.2 
 0243: ldloc.2 
 0244: brfalse.s 295
 0246: ldloc.2 
 0247: ldarg.0 
 0248: call method:Godot.Control.Godot.Vector2 get_GlobalPosition()
 0253: call method:Godot.Vector2.Godot.Vector2 get_Down()
 0258: ldarg.0 
 0259: call method:Godot.Control.Godot.Vector2 get_Size()
 0264: ldfld field:Single Y
 0269: call method:Godot.Vector2.Godot.Vector2 op_Multiply(Godot.Vector2, Single)
 0274: ldc.r4 1.5
 0279: call method:Godot.Vector2.Godot.Vector2 op_Multiply(Godot.Vector2, Single)
 0284: call method:Godot.Vector2.Godot.Vector2 op_Addition(Godot.Vector2, Godot.Vector2)
 0289: ldc.i4.0 
 0290: call method:Godot.Control.Void SetGlobalPosition(Godot.Vector2, Boolean)
 0295: ldloc.2 
 0296: brfalse.s 306
 0298: ldloc.2 
 0299: ldarg.0 
 0300: ldc.i4.3 
 0301: call method:MegaCrit.Sts2.Core.Nodes.HoverTips.NHoverTipSet.Void SetAlignment(Godot.Control, MegaCrit.Sts2.Core.HoverTips.HoverTipAlignment)
 0306: ldarg.0 
 0307: ldfld field:Godot.Tween _emptyPotionTween
 0312: dup 
 0313: brtrue.s 318
 0315: pop 
 0316: br.s 323
 0318: call method:Godot.Tween.Void Kill()
 0323: ldarg.0 
 0324: ldarg.0 
 0325: call method:Godot.Node.Godot.Tween CreateTween()
 0330: stfld field:Godot.Tween _emptyPotionTween
 0335: ldarg.0 
 0336: ldfld field:Godot.Tween _emptyPotionTween
 0341: ldarg.0 
 0342: ldfld field:Godot.TextureRect _emptyIcon
 0347: ldstr str:modulate
 0352: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0357: call method:Godot.Colors.Godot.Color get_White()
 0362: call method:Godot.Variant.Godot.Variant op_Implicit(Godot.Color)
 0367: ldc.r8 0.20000000298023224
 0376: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 0381: ldc.r8 0.20000000298023224
 0390: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetDelay(Double)
 0395: pop 
 0396: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse.s 93
 0017: ldloc.1 
 0018: newobj method:System.Threading.CancellationTokenSource.Void .ctor()
 0023: stfld field:System.Threading.CancellationTokenSource _cancelGrayOutPotionSource
 0028: ldc.i4.s 100
 0030: ldloc.1 
 0031: ldfld field:System.Threading.CancellationTokenSource _cancelGrayOutPotionSource
 0036: callvirt method:System.Threading.CancellationTokenSource.System.Threading.CancellationToken get_Token()
 0041: call method:System.Threading.Tasks.Task.System.Threading.Tasks.Task Delay(Int32, System.Threading.CancellationToken)
 0046: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0051: stloc.2 
 0052: ldloca.s 2
 0054: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0059: brtrue.s 121
 0061: ldarg.0 
 0062: ldc.i4.0 
 0063: dup 
 0064: stloc.0 
 0065: stfld field:Int32 <>1__state
 0070: ldarg.0 
 0071: ldloc.2 
 0072: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0077: ldarg.0 
 0078: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0083: ldloca.s 2
 0085: ldarg.0 
 0086: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<GrayPotionHolderUntilPlayedAfterDelay>d__37](System.Runtime.CompilerServices.TaskAwaiter ByRef, <GrayPotionHolderUntilPlayedAfterDelay>d__37 ByRef)
 0091: leave.s 196
 0093: ldarg.0 
 0094: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0099: stloc.2 
 0100: ldarg.0 
 0101: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0106: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0112: ldarg.0 
 0113: ldc.i4.m1 
 0114: dup 
 0115: stloc.0 
 0116: stfld field:Int32 <>1__state
 0121: ldloca.s 2
 0123: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0128: ldloc.1 
 0129: ldfld field:System.Threading.CancellationTokenSource _cancelGrayOutPotionSource
 0134: callvirt method:System.Threading.CancellationTokenSource.Boolean get_IsCancellationRequested()
 0139: brtrue.s 152
 0141: ldloc.1 
 0142: ldsfld field:Godot.Color gray
 0147: call method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0152: leave.s 177
 0154: stloc.3 
 0155: ldarg.0 
 0156: ldc.i4.s -2
 0158: stfld field:Int32 <>1__state
 0163: ldarg.0 
 0164: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0169: ldloc.3 
 0170: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0175: leave.s 196
 0177: ldarg.0 
 0178: ldc.i4.s -2
 0180: stfld field:Int32 <>1__state
 0185: ldarg.0 
 0186: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0191: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0196: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse 204
 0020: ldloc.1 
 0021: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0026: brtrue.s 44
 0028: ldstr str:Tried to use potion in holder, but potion node is null!
 0033: ldc.i4.2 
 0034: call method:MegaCrit.Sts2.Core.Logging.Log.Void Warn(System.String, Int32)
 0039: leave 353
 0044: ldloc.1 
 0045: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0050: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotion.MegaCrit.Sts2.Core.Models.PotionModel get_Model()
 0055: callvirt method:MegaCrit.Sts2.Core.Models.PotionModel.MegaCrit.Sts2.Core.Entities.Cards.TargetType get_TargetType()
 0060: stloc.3 
 0061: ldloc.3 
 0062: ldc.i4.2 
 0063: beq.s 69
 0065: ldloc.3 
 0066: ldc.i4.8 
 0067: bne.un.s 74
 0069: ldc.i4.1 
 0070: stloc.s 4
 0072: br.s 77
 0074: ldc.i4.0 
 0075: stloc.s 4
 0077: ldloc.s 4
 0079: stloc.2 
 0080: ldloc.2 
 0081: brtrue.s 104
 0083: ldloc.1 
 0084: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0089: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotion.MegaCrit.Sts2.Core.Models.PotionModel get_Model()
 0094: callvirt method:MegaCrit.Sts2.Core.Models.PotionModel.Boolean CanThrowAtAlly()
 0099: brfalse 257
 0104: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0109: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.PeerInput.HoveredModelTracker get_HoveredModelTracker()
 0114: ldloc.1 
 0115: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0120: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotion.MegaCrit.Sts2.Core.Models.PotionModel get_Model()
 0125: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.PeerInput.HoveredModelTracker.Void OnLocalPotionSelected(MegaCrit.Sts2.Core.Models.PotionModel)
 0130: ldloc.1 
 0131: ldloc.1 
 0132: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0137: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotion.MegaCrit.Sts2.Core.Models.PotionModel get_Model()
 0142: callvirt method:MegaCrit.Sts2.Core.Models.PotionModel.MegaCrit.Sts2.Core.Entities.Cards.TargetType get_TargetType()
 0147: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.System.Threading.Tasks.Task TargetNode(MegaCrit.Sts2.Core.Entities.Cards.TargetType)
 0152: callvirt method:System.Threading.Tasks.Task.System.Runtime.CompilerServices.TaskAwaiter GetAwaiter()
 0157: stloc.s 5
 0159: ldloca.s 5
 0161: call method:System.Runtime.CompilerServices.TaskAwaiter.Boolean get_IsCompleted()
 0166: brtrue.s 233
 0168: ldarg.0 
 0169: ldc.i4.0 
 0170: dup 
 0171: stloc.0 
 0172: stfld field:Int32 <>1__state
 0177: ldarg.0 
 0178: ldloc.s 5
 0180: stfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0185: ldarg.0 
 0186: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0191: ldloca.s 5
 0193: ldarg.0 
 0194: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter,<UsePotion>d__41](System.Runtime.CompilerServices.TaskAwaiter ByRef, <UsePotion>d__41 ByRef)
 0199: leave 372
 0204: ldarg.0 
 0205: ldfld field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0210: stloc.s 5
 0212: ldarg.0 
 0213: ldflda field:System.Runtime.CompilerServices.TaskAwaiter <>u__1
 0218: initobj type:System.Runtime.CompilerServices.TaskAwaiter
 0224: ldarg.0 
 0225: ldc.i4.m1 
 0226: dup 
 0227: stloc.0 
 0228: stfld field:Int32 <>1__state
 0233: ldloca.s 5
 0235: call method:System.Runtime.CompilerServices.TaskAwaiter.Void GetResult()
 0240: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0245: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.PeerInput.HoveredModelTracker get_HoveredModelTracker()
 0250: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.PeerInput.HoveredModelTracker.Void OnLocalPotionDeselected()
 0255: br.s 326
 0257: ldloc.1 
 0258: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0263: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotion.MegaCrit.Sts2.Core.Models.PotionModel get_Model()
 0268: callvirt method:MegaCrit.Sts2.Core.Models.PotionModel.MegaCrit.Sts2.Core.Entities.Cards.TargetType get_TargetType()
 0273: ldc.i4.1 
 0274: beq.s 279
 0276: ldnull 
 0277: br.s 300
 0279: ldloc.1 
 0280: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0285: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotion.MegaCrit.Sts2.Core.Models.PotionModel get_Model()
 0290: callvirt method:MegaCrit.Sts2.Core.Models.PotionModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0295: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Entities.Creatures.Creature get_Creature()
 0300: stloc.s 6
 0302: ldloc.1 
 0303: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0308: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotion.MegaCrit.Sts2.Core.Models.PotionModel get_Model()
 0313: ldloc.s 6
 0315: callvirt method:MegaCrit.Sts2.Core.Models.PotionModel.Void EnqueueManualUse(MegaCrit.Sts2.Core.Entities.Creatures.Creature)
 0320: ldloc.1 
 0321: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.Void TryGrabFocus(Godot.Control)
 0326: leave.s 353
 0328: stloc.s 7
 0330: ldarg.0 
 0331: ldc.i4.s -2
 0333: stfld field:Int32 <>1__state
 0338: ldarg.0 
 0339: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0344: ldloc.s 7
 0346: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 0351: leave.s 372
 0353: ldarg.0 
 0354: ldc.i4.s -2
 0356: stfld field:Int32 <>1__state
 0361: ldarg.0 
 0362: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0367: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 0372: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse 673
 0020: ldloc.1 
 0021: call method:Godot.Control.Godot.Vector2 get_GlobalPosition()
 0026: call method:Godot.Vector2.Godot.Vector2 get_Right()
 0031: ldloc.1 
 0032: call method:Godot.Control.Godot.Vector2 get_Size()
 0037: ldfld field:Single X
 0042: call method:Godot.Vector2.Godot.Vector2 op_Multiply(Godot.Vector2, Single)
 0047: ldc.r4 0.5
 0052: call method:Godot.Vector2.Godot.Vector2 op_Multiply(Godot.Vector2, Single)
 0057: call method:Godot.Vector2.Godot.Vector2 op_Addition(Godot.Vector2, Godot.Vector2)
 0062: call method:Godot.Vector2.Godot.Vector2 get_Down()
 0067: ldc.r4 50
 0072: call method:Godot.Vector2.Godot.Vector2 op_Multiply(Godot.Vector2, Single)
 0077: call method:Godot.Vector2.Godot.Vector2 op_Addition(Godot.Vector2, Godot.Vector2)
 0082: stloc.2 
 0083: call method:MegaCrit.Sts2.Core.Nodes.Combat.NTargetManager.MegaCrit.Sts2.Core.Nodes.Combat.NTargetManager get_Instance()
 0088: stloc.3 
 0089: call method:MegaCrit.Sts2.Core.Nodes.CommonUi.NControllerManager.MegaCrit.Sts2.Core.Nodes.CommonUi.NControllerManager get_Instance()
 0094: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NControllerManager.Boolean get_IsUsingDirectionalNavigation()
 0099: stloc.s 4
 0101: ldloc.3 
 0102: ldarg.0 
 0103: ldfld field:MegaCrit.Sts2.Core.Entities.Cards.TargetType targetType
 0108: ldloc.2 
 0109: ldloc.s 4
 0111: brtrue.s 116
 0113: ldc.i4.2 
 0114: br.s 117
 0116: ldc.i4.3 
 0117: ldloc.1 
 0118: ldftn method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.Boolean ShouldCancelTargeting()
 0124: newobj method:System.Func`1[System.Boolean].Void .ctor(System.Object, IntPtr)
 0129: ldnull 
 0130: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NTargetManager.Void StartTargeting(MegaCrit.Sts2.Core.Entities.Cards.TargetType, Godot.Vector2, MegaCrit.Sts2.Core.Nodes.Combat.TargetMode, System.Func`1[System.Boolean], System.Func`2[Godot.Node,System.Boolean])
 0135: ldloc.1 
 0136: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0141: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotion.MegaCrit.Sts2.Core.Models.PotionModel get_Model()
 0146: callvirt method:MegaCrit.Sts2.Core.Models.PotionModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0151: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Entities.Creatures.Creature get_Creature()
 0156: stloc.s 5
 0158: ldloc.s 4
 0160: brfalse 384
 0165: call method:MegaCrit.Sts2.Core.Combat.CombatManager.MegaCrit.Sts2.Core.Combat.CombatManager get_Instance()
 0170: callvirt method:MegaCrit.Sts2.Core.Combat.CombatManager.Boolean get_IsInProgress()
 0175: brfalse 384
 0180: ldloc.s 5
 0182: callvirt method:MegaCrit.Sts2.Core.Entities.Creatures.Creature.MegaCrit.Sts2.Core.Combat.ICombatState get_CombatState()
 0187: stloc.s 6
 0189: ldarg.0 
 0190: ldfld field:MegaCrit.Sts2.Core.Entities.Cards.TargetType targetType
 0195: stloc.s 10
 0197: ldloc.s 10
 0199: ldc.i4.2 
 0200: beq.s 209
 0202: ldloc.s 10
 0204: ldc.i4.5 
 0205: beq.s 222
 0207: br.s 235
 0209: ldloc.s 6
 0211: ldloc.s 5
 0213: callvirt method:MegaCrit.Sts2.Core.Combat.ICombatState.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Creatures.Creature] GetOpponentsOf(MegaCrit.Sts2.Core.Entities.Creatures.Creature)
 0218: stloc.s 9
 0220: br.s 258
 0222: ldloc.s 6
 0224: ldloc.s 5
 0226: callvirt method:MegaCrit.Sts2.Core.Combat.ICombatState.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Creatures.Creature] GetTeammatesOf(MegaCrit.Sts2.Core.Entities.Creatures.Creature)
 0231: stloc.s 9
 0233: br.s 258
 0235: ldstr str:targetType
 0240: ldarg.0 
 0241: ldfld field:MegaCrit.Sts2.Core.Entities.Cards.TargetType targetType
 0246: box type:MegaCrit.Sts2.Core.Entities.Cards.TargetType
 0251: ldnull 
 0252: newobj method:System.ArgumentOutOfRangeException.Void .ctor(System.String, System.Object, System.String)
 0257: throw 
 0258: ldloc.s 9
 0260: stloc.s 7
 0262: ldloc.s 7
 0264: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Entities.Creatures.Creature,System.Boolean] <>9__42_0
 0269: dup 
 0270: brtrue.s 295
 0272: pop 
 0273: ldsfld field:<>c <>9
 0278: ldftn method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder+<>c.Boolean <TargetNode>b__42_0(MegaCrit.Sts2.Core.Entities.Creatures.Creature)
 0284: newobj method:System.Func`2[MegaCrit.Sts2.Core.Entities.Creatures.Creature,System.Boolean].Void .ctor(System.Object, IntPtr)
 0289: dup 
 0290: stsfld field:System.Func`2[MegaCrit.Sts2.Core.Entities.Creatures.Creature,System.Boolean] <>9__42_0
 0295: call method:System.Linq.Enumerable.System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Creatures.Creature] Where[Creature](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Creatures.Creature], System.Func`2[MegaCrit.Sts2.Core.Entities.Creatures.Creature,System.Boolean])
 0300: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Creatures.Creature] ToList[Creature](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Creatures.Creature])
 0305: stloc.s 8
 0307: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom get_Instance()
 0312: ldloc.s 8
 0314: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Entities.Creatures.Creature,Godot.Control] <>9__42_1
 0319: dup 
 0320: brtrue.s 345
 0322: pop 
 0323: ldsfld field:<>c <>9
 0328: ldftn method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder+<>c.Godot.Control <TargetNode>b__42_1(MegaCrit.Sts2.Core.Entities.Creatures.Creature)
 0334: newobj method:System.Func`2[MegaCrit.Sts2.Core.Entities.Creatures.Creature,Godot.Control].Void .ctor(System.Object, IntPtr)
 0339: dup 
 0340: stsfld field:System.Func`2[MegaCrit.Sts2.Core.Entities.Creatures.Creature,Godot.Control] <>9__42_1
 0345: call method:System.Linq.Enumerable.System.Collections.Generic.IEnumerable`1[Godot.Control] Select[Creature,Control](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Creatures.Creature], System.Func`2[MegaCrit.Sts2.Core.Entities.Creatures.Creature,Godot.Control])
 0350: callvirt method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.Void RestrictControllerNavigation(System.Collections.Generic.IEnumerable`1[Godot.Control])
 0355: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom get_Instance()
 0360: ldloc.s 8
 0362: call method:System.Linq.Enumerable.MegaCrit.Sts2.Core.Entities.Creatures.Creature First[Creature](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Creatures.Creature])
 0367: callvirt method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Combat.NCreature GetCreatureNode(MegaCrit.Sts2.Core.Entities.Creatures.Creature)
 0372: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NCreature.Godot.Control get_Hitbox()
 0377: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.Void TryGrabFocus(Godot.Control)
 0382: br.s 444
 0384: ldloc.s 4
 0386: brfalse.s 444
 0388: ldarg.0 
 0389: ldfld field:MegaCrit.Sts2.Core.Entities.Cards.TargetType targetType
 0394: ldc.i4.5 
 0395: bne.un.s 444
 0397: call method:MegaCrit.Sts2.Core.Nodes.NRun.MegaCrit.Sts2.Core.Nodes.NRun get_Instance()
 0402: callvirt method:MegaCrit.Sts2.Core.Nodes.NRun.MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi get_GlobalUi()
 0407: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi.MegaCrit.Sts2.Core.Nodes.Multiplayer.NMultiplayerPlayerStateContainer get_MultiplayerPlayerContainer()
 0412: stloc.s 11
 0414: ldloc.s 11
 0416: callvirt method:MegaCrit.Sts2.Core.Nodes.Multiplayer.NMultiplayerPlayerStateContainer.MegaCrit.Sts2.Core.Nodes.Multiplayer.NMultiplayerPlayerState get_FirstPlayerState()
 0421: dup 
 0422: brtrue.s 427
 0424: pop 
 0425: br.s 437
 0427: call method:MegaCrit.Sts2.Core.Nodes.Multiplayer.NMultiplayerPlayerState.MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton get_Hitbox()
 0432: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.Void TryGrabFocus(Godot.Control)
 0437: ldloc.s 11
 0439: callvirt method:MegaCrit.Sts2.Core.Nodes.Multiplayer.NMultiplayerPlayerStateContainer.Void LockNavigation()
 0444: ldarg.0 
 0445: ldnull 
 0446: stfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton <merchantButton>5__2
 0451: ldarg.0 
 0452: ldflda field:System.Nullable`1[Godot.Control+FocusBehaviorRecursiveEnum] <savedFocusBehavior>5__3
 0457: initobj type:System.Nullable`1[Godot.Control+FocusBehaviorRecursiveEnum]
 0463: ldarg.0 
 0464: ldnull 
 0465: stfld field:Godot.Control <merchantScreenContext>5__4
 0470: ldarg.0 
 0471: ldc.i4.0 
 0472: stfld field:Boolean <merchantButtonWasDisabled>5__5
 0477: ldloc.s 4
 0479: brfalse 637
 0484: ldloc.1 
 0485: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0490: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotion.MegaCrit.Sts2.Core.Models.PotionModel get_Model()
 0495: isinst type:MegaCrit.Sts2.Core.Models.Potions.FoulPotion
 0500: brfalse 637
 0505: ldloc.s 5
 0507: callvirt method:MegaCrit.Sts2.Core.Entities.Creatures.Creature.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0512: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0517: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.MegaCrit.Sts2.Core.Rooms.AbstractRoom get_CurrentRoom()
 0522: call method:MegaCrit.Sts2.Core.Models.Potions.FoulPotion.System.ValueTuple`2[MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton,Godot.Control] GetFoulPotionMerchantTarget(MegaCrit.Sts2.Core.Rooms.AbstractRoom)
 0527: stloc.s 12
 0529: ldarg.0 
 0530: ldloc.s 12
 0532: ldfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton Item1
 0537: stfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton <merchantButton>5__2
 0542: ldarg.0 
 0543: ldloc.s 12
 0545: ldfld field:Godot.Control Item2
 0550: stfld field:Godot.Control <merchantScreenContext>5__4
 0555: ldarg.0 
 0556: ldfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton <merchantButton>5__2
 0561: brfalse.s 637
 0563: ldarg.0 
 0564: ldfld field:Godot.Control <merchantScreenContext>5__4
 0569: brfalse.s 606
 0571: ldarg.0 
 0572: ldarg.0 
 0573: ldfld field:Godot.Control <merchantScreenContext>5__4
 0578: callvirt method:Godot.Control.FocusBehaviorRecursiveEnum get_FocusBehaviorRecursive()
 0583: newobj method:System.Nullable`1[Godot.Control+FocusBehaviorRecursiveEnum].Void .ctor(FocusBehaviorRecursiveEnum)
 0588: stfld field:System.Nullable`1[Godot.Control+FocusBehaviorRecursiveEnum] <savedFocusBehavior>5__3
 0593: ldarg.0 
 0594: ldfld field:Godot.Control <merchantScreenContext>5__4
 0599: ldc.i4.2 
 0600: conv.i8 
 0601: callvirt method:Godot.Control.Void set_FocusBehaviorRecursive(FocusBehaviorRecursiveEnum)
 0606: ldarg.0 
 0607: ldfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton <merchantButton>5__2
 0612: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Boolean get_IsEnabled()
 0617: brtrue.s 637
 0619: ldarg.0 
 0620: ldc.i4.1 
 0621: stfld field:Boolean <merchantButtonWasDisabled>5__5
 0626: ldarg.0 
 0627: ldfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton <merchantButton>5__2
 0632: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Enable()
 0637: ldarg.0 
 0638: ldfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton <merchantButton>5__2
 0643: dup 
 0644: brtrue.s 649
 0646: pop 
 0647: br.s 656
 0649: ldc.i4.2 
 0650: conv.i8 
 0651: call method:Godot.Control.Void SetFocusMode(FocusModeEnum)
 0656: ldarg.0 
 0657: ldfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton <merchantButton>5__2
 0662: dup 
 0663: brtrue.s 668
 0665: pop 
 0666: br.s 673
 0668: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.Void TryGrabFocus(Godot.Control)
 0673: nop 
 0674: ldloc.0 
 0675: brfalse.s 735
 0677: ldloc.3 
 0678: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NTargetManager.System.Threading.Tasks.Task`1[Godot.Node] SelectionFinished()
 0683: callvirt method:System.Threading.Tasks.Task`1[Godot.Node].System.Runtime.CompilerServices.TaskAwaiter`1[Godot.Node] GetAwaiter()
 0688: stloc.s 15
 0690: ldloca.s 15
 0692: call method:System.Runtime.CompilerServices.TaskAwaiter`1[Godot.Node].Boolean get_IsCompleted()
 0697: brtrue.s 764
 0699: ldarg.0 
 0700: ldc.i4.0 
 0701: dup 
 0702: stloc.0 
 0703: stfld field:Int32 <>1__state
 0708: ldarg.0 
 0709: ldloc.s 15
 0711: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[Godot.Node] <>u__1
 0716: ldarg.0 
 0717: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0722: ldloca.s 15
 0724: ldarg.0 
 0725: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<TargetNode>d__42](System.Runtime.CompilerServices.TaskAwaiter`1[Godot.Node] ByRef, <TargetNode>d__42 ByRef)
 0730: leave 1090
 0735: ldarg.0 
 0736: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[Godot.Node] <>u__1
 0741: stloc.s 15
 0743: ldarg.0 
 0744: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[Godot.Node] <>u__1
 0749: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[Godot.Node]
 0755: ldarg.0 
 0756: ldc.i4.m1 
 0757: dup 
 0758: stloc.0 
 0759: stfld field:Int32 <>1__state
 0764: ldloca.s 15
 0766: call method:System.Runtime.CompilerServices.TaskAwaiter`1[Godot.Node].Godot.Node GetResult()
 0771: stloc.s 14
 0773: ldloc.s 14
 0775: stloc.s 13
 0777: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom get_Instance()
 0782: dup 
 0783: brtrue.s 788
 0785: pop 
 0786: br.s 793
 0788: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.Void EnableControllerNavigation()
 0793: call method:MegaCrit.Sts2.Core.Nodes.NRun.MegaCrit.Sts2.Core.Nodes.NRun get_Instance()
 0798: callvirt method:MegaCrit.Sts2.Core.Nodes.NRun.MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi get_GlobalUi()
 0803: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi.MegaCrit.Sts2.Core.Nodes.Multiplayer.NMultiplayerPlayerStateContainer get_MultiplayerPlayerContainer()
 0808: callvirt method:MegaCrit.Sts2.Core.Nodes.Multiplayer.NMultiplayerPlayerStateContainer.Void UnlockNavigation()
 0813: ldloc.s 13
 0815: brfalse.s 922
 0817: ldloc.s 13
 0819: isinst type:MegaCrit.Sts2.Core.Nodes.Combat.NCreature
 0824: stloc.s 17
 0826: ldloc.s 17
 0828: brtrue.s 854
 0830: ldloc.s 13
 0832: isinst type:MegaCrit.Sts2.Core.Nodes.Multiplayer.NMultiplayerPlayerState
 0837: stloc.s 18
 0839: ldloc.s 18
 0841: brtrue.s 865
 0843: ldloc.s 13
 0845: isinst type:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton
 0850: brtrue.s 881
 0852: br.s 886
 0854: ldloc.s 17
 0856: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NCreature.MegaCrit.Sts2.Core.Entities.Creatures.Creature get_Entity()
 0861: stloc.s 19
 0863: br.s 900
 0865: ldloc.s 18
 0867: callvirt method:MegaCrit.Sts2.Core.Nodes.Multiplayer.NMultiplayerPlayerState.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0872: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Entities.Creatures.Creature get_Creature()
 0877: stloc.s 19
 0879: br.s 900
 0881: ldnull 
 0882: stloc.s 19
 0884: br.s 900
 0886: ldstr str:targetNode
 0891: ldloc.s 13
 0893: ldnull 
 0894: newobj method:System.ArgumentOutOfRangeException.Void .ctor(System.String, System.Object, System.String)
 0899: throw 
 0900: ldloc.s 19
 0902: stloc.s 16
 0904: ldloc.1 
 0905: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0910: callvirt method:MegaCrit.Sts2.Core.Nodes.Potions.NPotion.MegaCrit.Sts2.Core.Models.PotionModel get_Model()
 0915: ldloc.s 16
 0917: callvirt method:MegaCrit.Sts2.Core.Models.PotionModel.Void EnqueueManualUse(MegaCrit.Sts2.Core.Entities.Creatures.Creature)
 0922: leave.s 1010
 0924: ldloc.0 
 0925: ldc.i4.0 
 0926: bge.s 1009
 0928: ldarg.0 
 0929: ldfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton <merchantButton>5__2
 0934: dup 
 0935: brtrue.s 940
 0937: pop 
 0938: br.s 947
 0940: ldc.i4.0 
 0941: conv.i8 
 0942: call method:Godot.Control.Void SetFocusMode(FocusModeEnum)
 0947: ldarg.0 
 0948: ldfld field:Boolean <merchantButtonWasDisabled>5__5
 0953: brfalse.s 966
 0955: ldarg.0 
 0956: ldfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton <merchantButton>5__2
 0961: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Disable()
 0966: ldarg.0 
 0967: ldfld field:Godot.Control <merchantScreenContext>5__4
 0972: brfalse.s 1009
 0974: ldarg.0 
 0975: ldflda field:System.Nullable`1[Godot.Control+FocusBehaviorRecursiveEnum] <savedFocusBehavior>5__3
 0980: call method:System.Nullable`1[Godot.Control+FocusBehaviorRecursiveEnum].Boolean get_HasValue()
 0985: brfalse.s 1009
 0987: ldarg.0 
 0988: ldfld field:Godot.Control <merchantScreenContext>5__4
 0993: ldarg.0 
 0994: ldflda field:System.Nullable`1[Godot.Control+FocusBehaviorRecursiveEnum] <savedFocusBehavior>5__3
 0999: call method:System.Nullable`1[Godot.Control+FocusBehaviorRecursiveEnum].FocusBehaviorRecursiveEnum get_Value()
 1004: callvirt method:Godot.Control.Void set_FocusBehaviorRecursive(FocusBehaviorRecursiveEnum)
 1009: endfinally 
 1010: ldloc.1 
 1011: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.Void TryGrabFocus(Godot.Control)
 1016: leave.s 1057
 1018: stloc.s 20
 1020: ldarg.0 
 1021: ldc.i4.s -2
 1023: stfld field:Int32 <>1__state
 1028: ldarg.0 
 1029: ldnull 
 1030: stfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton <merchantButton>5__2
 1035: ldarg.0 
 1036: ldnull 
 1037: stfld field:Godot.Control <merchantScreenContext>5__4
 1042: ldarg.0 
 1043: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 1048: ldloc.s 20
 1050: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetException(System.Exception)
 1055: leave.s 1090
 1057: ldarg.0 
 1058: ldc.i4.s -2
 1060: stfld field:Int32 <>1__state
 1065: ldarg.0 
 1066: ldnull 
 1067: stfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton <merchantButton>5__2
 1072: ldarg.0 
 1073: ldnull 
 1074: stfld field:Godot.Control <merchantScreenContext>5__4
 1079: ldarg.0 
 1080: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 1085: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void SetResult()
 1090: ret 
METHOD Boolean ShouldCancelTargeting()
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder.MegaCrit.Sts2.Core.Nodes.Potions.NPotion get_Potion()
 0006: brfalse.s 48
 0008: call method:MegaCrit.Sts2.Core.Combat.CombatManager.MegaCrit.Sts2.Core.Combat.CombatManager get_Instance()
 0013: callvirt method:MegaCrit.Sts2.Core.Combat.CombatManager.Boolean get_IsInProgress()
 0018: brfalse.s 46
 0020: call method:MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack.MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack get_Instance()
 0025: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack.Int32 get_ScreenCount()
 0030: ldc.i4.0 
 0031: bgt.s 44
 0033: call method:MegaCrit.Sts2.Core.Nodes.Screens.Capstones.NCapstoneContainer.MegaCrit.Sts2.Core.Nodes.Screens.Capstones.NCapstoneContainer get_Instance()
 0038: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Capstones.NCapstoneContainer.Boolean get_InUse()
 0043: ret 
 0044: ldc.i4.1 
 0045: ret 
 0046: ldc.i4.0 
 0047: ret 
 0048: ldc.i4.1 
 0049: ret 
