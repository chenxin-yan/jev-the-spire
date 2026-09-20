METHOD Void _Ready()
 0000: ldarg.0 
 0001: ldarg.0 
 0002: ldstr str:%SelectModeBackstop
 0007: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0012: call method:Godot.Node.Godot.Control GetNode[Control](Godot.NodePath)
 0017: stfld field:Godot.Control _selectModeBackstop
 0022: ldarg.0 
 0023: ldarg.0 
 0024: ldstr str:%CardHolderContainer
 0029: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0034: call method:Godot.Node.Godot.Control GetNode[Control](Godot.NodePath)
 0039: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void set_CardHolderContainer(Godot.Control)
 0044: ldarg.0 
 0045: ldarg.0 
 0046: ldstr str:%UpgradePreviewContainer
 0051: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0056: call method:Godot.Node.Godot.Control GetNode[Control](Godot.NodePath)
 0061: stfld field:Godot.Control _upgradePreviewContainer
 0066: ldarg.0 
 0067: ldarg.0 
 0068: ldstr str:%SelectModeConfirmButton
 0073: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0078: call method:Godot.Node.MegaCrit.Sts2.Core.Nodes.CommonUi.NConfirmButton GetNode[NConfirmButton](Godot.NodePath)
 0083: stfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NConfirmButton _selectModeConfirmButton
 0088: ldarg.0 
 0089: ldarg.0 
 0090: ldstr str:%UpgradePreview
 0095: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0100: call method:Godot.Node.MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview GetNode[NUpgradePreview](Godot.NodePath)
 0105: stfld field:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview _upgradePreview
 0110: ldarg.0 
 0111: ldarg.0 
 0112: ldstr str:%SelectionHeader
 0117: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0122: call method:Godot.Node.MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel GetNode[MegaRichTextLabel](Godot.NodePath)
 0127: stfld field:MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel _selectionHeader
 0132: ldarg.0 
 0133: ldfld field:MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel _selectionHeader
 0138: ldc.i4.0 
 0139: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0144: ldarg.0 
 0145: ldarg.0 
 0146: ldstr str:%SelectedHandCardContainer
 0151: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0156: call method:Godot.Node.MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer GetNode[NSelectedHandCardContainer](Godot.NodePath)
 0161: stfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0166: ldarg.0 
 0167: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0172: ldarg.0 
 0173: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer.Void set_Hand(MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand)
 0178: ldarg.0 
 0179: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NConfirmButton _selectModeConfirmButton
 0184: ldsfld field:Godot.StringName Released
 0189: ldarg.0 
 0190: ldftn method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void OnSelectModeConfirmButtonPressed(MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton)
 0196: newobj method:System.Action`1[MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton].Void .ctor(System.Object, IntPtr)
 0201: call method:Godot.Callable.Godot.Callable From[NButton](System.Action`1[MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton])
 0206: ldc.i4.0 
 0207: callvirt method:Godot.GodotObject.Godot.Error Connect(Godot.StringName, Godot.Callable, UInt32)
 0212: pop 
 0213: ldarg.0 
 0214: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NConfirmButton _selectModeConfirmButton
 0219: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Disable()
 0224: ldarg.0 
 0225: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0230: ldsfld field:Godot.StringName ChildExitingTree
 0235: ldarg.0 
 0236: ldftn method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void OnCardDeselected(Godot.Node)
 0242: newobj method:System.Action`1[Godot.Node].Void .ctor(System.Object, IntPtr)
 0247: call method:Godot.Callable.Godot.Callable From[Node](System.Action`1[Godot.Node])
 0252: ldc.i4.0 
 0253: callvirt method:Godot.GodotObject.Godot.Error Connect(Godot.StringName, Godot.Callable, UInt32)
 0258: pop 
 0259: ldarg.0 
 0260: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0265: ldsfld field:Godot.StringName ChildEnteredTree
 0270: ldarg.0 
 0271: ldftn method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void OnCardSelected(Godot.Node)
 0277: newobj method:System.Action`1[Godot.Node].Void .ctor(System.Object, IntPtr)
 0282: call method:Godot.Callable.Godot.Callable From[Node](System.Action`1[Godot.Node])
 0287: ldc.i4.0 
 0288: callvirt method:Godot.GodotObject.Godot.Error Connect(Godot.StringName, Godot.Callable, UInt32)
 0293: pop 
 0294: ldarg.0 
 0295: ldarg.0 
 0296: ldstr str:%PeekButton
 0301: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0306: call method:Godot.Node.MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton GetNode[NPeekButton](Godot.NodePath)
 0311: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void set_PeekButton(MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton)
 0316: ldarg.0 
 0317: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton get_PeekButton()
 0322: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Disable()
 0327: ldarg.0 
 0328: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton get_PeekButton()
 0333: ldc.i4.5 
 0334: newarr type:Godot.Control
 0339: dup 
 0340: ldc.i4.0 
 0341: ldarg.0 
 0342: ldfld field:Godot.Control _selectModeBackstop
 0347: stelem.ref 
 0348: dup 
 0349: ldc.i4.1 
 0350: ldarg.0 
 0351: ldfld field:Godot.Control _upgradePreviewContainer
 0356: stelem.ref 
 0357: dup 
 0358: ldc.i4.2 
 0359: ldarg.0 
 0360: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NConfirmButton _selectModeConfirmButton
 0365: stelem.ref 
 0366: dup 
 0367: ldc.i4.3 
 0368: ldarg.0 
 0369: ldfld field:MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel _selectionHeader
 0374: stelem.ref 
 0375: dup 
 0376: ldc.i4.4 
 0377: ldarg.0 
 0378: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0383: stelem.ref 
 0384: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton.Void AddTargets(Godot.Control[])
 0389: ldarg.0 
 0390: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton get_PeekButton()
 0395: ldsfld field:Godot.StringName Toggled
 0400: ldarg.0 
 0401: ldftn method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void OnPeekButtonToggled(MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton)
 0407: newobj method:System.Action`1[MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton].Void .ctor(System.Object, IntPtr)
 0412: call method:Godot.Callable.Godot.Callable From[NPeekButton](System.Action`1[MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton])
 0417: ldc.i4.0 
 0418: callvirt method:Godot.GodotObject.Godot.Error Connect(Godot.StringName, Godot.Callable, UInt32)
 0423: pop 
 0424: ldarg.0 
 0425: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Godot.Control get_CardHolderContainer()
 0430: ldsfld field:Godot.StringName FocusEntered
 0435: ldarg.0 
 0436: ldftn method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void <_Ready>b__59_0()
 0442: newobj method:System.Action.Void .ctor(System.Object, IntPtr)
 0447: call method:Godot.Callable.Godot.Callable From(System.Action)
 0452: ldc.i4.0 
 0453: callvirt method:Godot.GodotObject.Godot.Error Connect(Godot.StringName, Godot.Callable, UInt32)
 0458: pop 
 0459: ldarg.0 
 0460: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Godot.Control get_CardHolderContainer()
 0465: ldarg.0 
 0466: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Godot.Control get_CardHolderContainer()
 0471: callvirt method:Godot.Node.Godot.NodePath GetPath()
 0476: callvirt method:Godot.Control.Void set_FocusNeighborBottom(Godot.NodePath)
 0481: ldarg.0 
 0482: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Godot.Control get_CardHolderContainer()
 0487: ldarg.0 
 0488: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Godot.Control get_CardHolderContainer()
 0493: callvirt method:Godot.Node.Godot.NodePath GetPath()
 0498: callvirt method:Godot.Control.Void set_FocusNeighborLeft(Godot.NodePath)
 0503: ldarg.0 
 0504: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Godot.Control get_CardHolderContainer()
 0509: ldarg.0 
 0510: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Godot.Control get_CardHolderContainer()
 0515: callvirt method:Godot.Node.Godot.NodePath GetPath()
 0520: callvirt method:Godot.Control.Void set_FocusNeighborRight(Godot.NodePath)
 0525: ret 
METHOD Void OnCardSelected(Godot.Node)
 0000: ldarg.0 
 0001: ldarg.0 
 0002: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0007: ldc.i4.0 
 0008: callvirt method:Godot.Node.Int32 GetChildCount(Boolean)
 0013: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void UpdateSelectedCardContainer(Int32)
 0018: ret 
METHOD Void OnCardDeselected(Godot.Node)
 0000: ldarg.0 
 0001: ldarg.0 
 0002: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0007: ldc.i4.0 
 0008: callvirt method:Godot.Node.Int32 GetChildCount(Boolean)
 0013: ldc.i4.1 
 0014: sub 
 0015: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void UpdateSelectedCardContainer(Int32)
 0020: ret 
METHOD Void UpdateSelectedCardContainer(Int32)
 0000: ldc.r4 1
 0005: stloc.0 
 0006: ldarg.0 
 0007: call method:Godot.Control.Godot.Vector2 get_Size()
 0012: ldfld field:Single Y
 0017: ldc.r4 0.5
 0022: mul 
 0023: stloc.1 
 0024: ldarg.1 
 0025: ldc.i4.6 
 0026: ble.s 44
 0028: ldc.r4 0.55
 0033: stloc.0 
 0034: ldloc.1 
 0035: ldc.r4 150
 0040: sub 
 0041: stloc.1 
 0042: br.s 62
 0044: ldarg.1 
 0045: ldc.i4.3 
 0046: ble.s 62
 0048: ldc.r4 0.8
 0053: stloc.0 
 0054: ldloc.1 
 0055: ldc.r4 75
 0060: sub 
 0061: stloc.1 
 0062: ldarg.0 
 0063: ldfld field:Godot.Tween _selectedCardScaleTween
 0068: dup 
 0069: brtrue.s 74
 0071: pop 
 0072: br.s 79
 0074: call method:Godot.Tween.Void Kill()
 0079: ldarg.0 
 0080: ldarg.0 
 0081: call method:Godot.Node.Godot.Tween CreateTween()
 0086: ldc.i4.1 
 0087: callvirt method:Godot.Tween.Godot.Tween SetParallel(Boolean)
 0092: stfld field:Godot.Tween _selectedCardScaleTween
 0097: ldarg.0 
 0098: ldfld field:Godot.Tween _selectedCardScaleTween
 0103: ldarg.0 
 0104: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0109: ldstr str:position:y
 0114: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0119: ldloc.1 
 0120: call method:Godot.Variant.Godot.Variant op_Implicit(Single)
 0125: ldc.r8 0.5
 0134: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 0139: ldc.i4.4 
 0140: conv.i8 
 0141: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetTrans(TransitionType)
 0146: ldc.i4.2 
 0147: conv.i8 
 0148: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetEase(EaseType)
 0153: pop 
 0154: ldarg.0 
 0155: ldfld field:Godot.Tween _selectedCardScaleTween
 0160: ldarg.0 
 0161: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0166: ldstr str:scale
 0171: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0176: call method:Godot.Vector2.Godot.Vector2 get_One()
 0181: ldloc.0 
 0182: call method:Godot.Vector2.Godot.Vector2 op_Multiply(Godot.Vector2, Single)
 0187: call method:Godot.Variant.Godot.Variant op_Implicit(Godot.Vector2)
 0192: ldc.r8 0.5
 0201: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 0206: ldc.i4.4 
 0207: conv.i8 
 0208: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetTrans(TransitionType)
 0213: ldc.i4.2 
 0214: conv.i8 
 0215: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetEase(EaseType)
 0220: pop 
 0221: ret 
