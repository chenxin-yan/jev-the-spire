METHOD System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] SelectCards(MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs, System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean], MegaCrit.Sts2.Core.Models.AbstractModel, Mode)
 0000: ldloca.s 0
 0002: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] Create()
 0007: stfld field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0012: ldloca.s 0
 0014: ldarg.0 
 0015: stfld field:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand <>4__this
 0020: ldloca.s 0
 0022: ldarg.1 
 0023: stfld field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0028: ldloca.s 0
 0030: ldarg.2 
 0031: stfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0036: ldloca.s 0
 0038: ldarg.3 
 0039: stfld field:MegaCrit.Sts2.Core.Models.AbstractModel source
 0044: ldloca.s 0
 0046: ldarg.s 4
 0048: stfld field:Mode mode
 0053: ldloca.s 0
 0055: ldc.i4.m1 
 0056: stfld field:Int32 <>1__state
 0061: ldloca.s 0
 0063: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0068: ldloca.s 0
 0070: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void Start[<SelectCards>d__83](<SelectCards>d__83 ByRef)
 0075: ldloca.s 0
 0077: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0082: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] get_Task()
 0087: ret 
METHOD Void MoveNext()
 0000: ldarg.0 
 0001: ldfld field:Int32 <>1__state
 0006: stloc.0 
 0007: ldarg.0 
 0008: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand <>4__this
 0013: stloc.1 
 0014: ldloc.0 
 0015: brfalse 399
 0020: ldloc.1 
 0021: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void CancelAllCardPlay()
 0026: ldloc.1 
 0027: ldfld field:Godot.Control _selectModeBackstop
 0032: ldc.i4.1 
 0033: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0038: ldloc.1 
 0039: ldfld field:Godot.Control _selectModeBackstop
 0044: ldc.i4.0 
 0045: conv.i8 
 0046: callvirt method:Godot.Control.Void set_MouseFilter(MouseFilterEnum)
 0051: ldloc.1 
 0052: ldfld field:Godot.Control _selectModeBackstop
 0057: ldloc.1 
 0058: ldfld field:Godot.Control _selectModeBackstop
 0063: callvirt method:Godot.CanvasItem.Godot.Color get_SelfModulate()
 0068: stloc.s 6
 0070: ldloca.s 6
 0072: ldc.r4 0
 0077: stfld field:Single A
 0082: ldloc.s 6
 0084: callvirt method:Godot.CanvasItem.Void set_SelfModulate(Godot.Color)
 0089: ldarg.0 
 0090: ldloc.1 
 0091: call method:Godot.Node.Godot.Tween CreateTween()
 0096: stfld field:Godot.Tween <tween>5__2
 0101: ldarg.0 
 0102: ldfld field:Godot.Tween <tween>5__2
 0107: ldloc.1 
 0108: ldfld field:Godot.Control _selectModeBackstop
 0113: ldstr str:self_modulate:a
 0118: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0123: ldc.r4 1
 0128: call method:Godot.Variant.Godot.Variant op_Implicit(Single)
 0133: ldc.r8 0.20000000298023224
 0142: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 0147: pop 
 0148: ldarg.0 
 0149: ldloc.1 
 0150: ldfld field:Boolean _isDisabled
 0155: stfld field:Boolean <wasDisabled>5__3
 0160: ldloc.1 
 0161: ldfld field:Boolean _isDisabled
 0166: brfalse.s 174
 0168: ldloc.1 
 0169: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void AnimEnable()
 0174: ldloc.1 
 0175: ldarg.0 
 0176: ldfld field:Mode mode
 0181: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void set_CurrentMode(Mode)
 0186: ldloc.1 
 0187: ldarg.0 
 0188: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0193: stfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] _currentSelectionFilter
 0198: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom get_Instance()
 0203: stloc.3 
 0204: ldloc.3 
 0205: call method:System.Array.Godot.Control[] Empty[Control]()
 0210: callvirt method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.Void RestrictControllerNavigation(System.Collections.Generic.IEnumerable`1[Godot.Control])
 0215: ldloc.3 
 0216: callvirt method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Combat.NCombatUi get_Ui()
 0221: stloc.s 4
 0223: ldloc.s 4
 0225: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NCombatUi.Void OnHandSelectModeEntered()
 0230: ldloc.1 
 0231: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void EnableControllerNavigation()
 0236: ldloc.1 
 0237: ldarg.0 
 0238: ldfld field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0243: stfld field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs _prefs
 0248: ldloc.1 
 0249: newobj method:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void .ctor()
 0254: stfld field:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] _selectionCompletionSource
 0259: ldloc.1 
 0260: ldfld field:MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel _selectionHeader
 0265: ldc.i4.1 
 0266: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0271: ldloc.1 
 0272: ldfld field:MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel _selectionHeader
 0277: ldstr str:[center]
 0282: ldarg.0 
 0283: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs prefs
 0288: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.MegaCrit.Sts2.Core.Localization.LocString get_Prompt()
 0293: callvirt method:MegaCrit.Sts2.Core.Localization.LocString.System.String GetFormattedText()
 0298: ldstr str:[/center]
 0303: call method:System.String.System.String Concat(System.String, System.String, System.String)
 0308: callvirt method:MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel.Void set_Text(System.String)
 0313: ldloc.1 
 0314: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton get_PeekButton()
 0319: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Enable()
 0324: ldloc.1 
 0325: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void UpdateSelectModeCardVisibility()
 0330: ldloc.1 
 0331: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void RefreshSelectModeConfirmButton()
 0336: ldloc.1 
 0337: ldfld field:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] _selectionCompletionSource
 0342: callvirt method:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] get_Task()
 0347: callvirt method:System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] GetAwaiter()
 0352: stloc.s 8
 0354: ldloca.s 8
 0356: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean get_IsCompleted()
 0361: brtrue.s 428
 0363: ldarg.0 
 0364: ldc.i4.0 
 0365: dup 
 0366: stloc.0 
 0367: stfld field:Int32 <>1__state
 0372: ldarg.0 
 0373: ldloc.s 8
 0375: stfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0380: ldarg.0 
 0381: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0386: ldloca.s 8
 0388: ldarg.0 
 0389: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void AwaitUnsafeOnCompleted[TaskAwaiter`1,<SelectCards>d__83](System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] ByRef, <SelectCards>d__83 ByRef)
 0394: leave 571
 0399: ldarg.0 
 0400: ldfld field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0405: stloc.s 8
 0407: ldarg.0 
 0408: ldflda field:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>u__1
 0413: initobj type:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]]
 0419: ldarg.0 
 0420: ldc.i4.m1 
 0421: dup 
 0422: stloc.0 
 0423: stfld field:Int32 <>1__state
 0428: ldloca.s 8
 0430: call method:System.Runtime.CompilerServices.TaskAwaiter`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel] GetResult()
 0435: stloc.s 7
 0437: ldloc.s 7
 0439: stloc.s 5
 0441: ldloc.1 
 0442: call method:Godot.Node.Boolean IsInsideTree()
 0447: brtrue.s 454
 0449: ldloc.s 5
 0451: stloc.2 
 0452: leave.s 544
 0454: ldarg.0 
 0455: ldfld field:Godot.Tween <tween>5__2
 0460: callvirt method:Godot.Tween.Void Kill()
 0465: ldloc.1 
 0466: ldarg.0 
 0467: ldfld field:MegaCrit.Sts2.Core.Models.AbstractModel source
 0472: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void AfterCardsSelected(MegaCrit.Sts2.Core.Models.AbstractModel)
 0477: ldarg.0 
 0478: ldfld field:Boolean <wasDisabled>5__3
 0483: brfalse.s 491
 0485: ldloc.1 
 0486: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void AnimDisable()
 0491: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom get_Instance()
 0496: dup 
 0497: brtrue.s 502
 0499: pop 
 0500: br.s 507
 0502: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.Void EnableControllerNavigation()
 0507: ldloc.s 5
 0509: stloc.2 
 0510: leave.s 544
 0512: stloc.s 9
 0514: ldarg.0 
 0515: ldc.i4.s -2
 0517: stfld field:Int32 <>1__state
 0522: ldarg.0 
 0523: ldnull 
 0524: stfld field:Godot.Tween <tween>5__2
 0529: ldarg.0 
 0530: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0535: ldloc.s 9
 0537: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetException(System.Exception)
 0542: leave.s 571
 0544: ldarg.0 
 0545: ldc.i4.s -2
 0547: stfld field:Int32 <>1__state
 0552: ldarg.0 
 0553: ldnull 
 0554: stfld field:Godot.Tween <tween>5__2
 0559: ldarg.0 
 0560: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] <>t__builder
 0565: ldloc.2 
 0566: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetResult(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0571: ret 
METHOD Void AfterCardsSelected(MegaCrit.Sts2.Core.Models.AbstractModel)
 0000: ldarg.0 
 0001: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0006: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Void Clear()
 0011: ldarg.0 
 0012: ldc.i4.1 
 0013: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void set_CurrentMode(Mode)
 0018: ldarg.0 
 0019: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs _prefs
 0024: initobj type:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs
 0030: ldarg.0 
 0031: ldnull 
 0032: stfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] _currentSelectionFilter
 0037: ldarg.0 
 0038: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder] get_Holders()
 0043: callvirt method:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder].System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder] GetEnumerator()
 0048: stloc.1 
 0049: br.s 114
 0051: ldloc.1 
 0052: callvirt method:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder].MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder get_Current()
 0057: stloc.2 
 0058: ldloc.2 
 0059: ldc.i4.0 
 0060: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder.Void set_InSelectMode(Boolean)
 0065: ldloc.2 
 0066: ldc.i4.1 
 0067: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0072: ldloc.2 
 0073: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0078: dup 
 0079: brtrue.s 84
 0081: pop 
 0082: br.s 90
 0084: ldc.i4.0 
 0085: call method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.Void SetPretendCardCanBePlayed(Boolean)
 0090: ldloc.2 
 0091: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0096: dup 
 0097: brtrue.s 102
 0099: pop 
 0100: br.s 108
 0102: ldc.i4.0 
 0103: call method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.Void SetForceUnpoweredPreview(Boolean)
 0108: ldloc.2 
 0109: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder.Void UpdateCard()
 0114: ldloc.1 
 0115: callvirt method:System.Collections.IEnumerator.Boolean MoveNext()
 0120: brtrue.s 51
 0122: leave.s 134
 0124: ldloc.1 
 0125: brfalse.s 133
 0127: ldloc.1 
 0128: callvirt method:System.IDisposable.Void Dispose()
 0133: endfinally 
 0134: ldarg.0 
 0135: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void RefreshLayout()
 0140: ldarg.0 
 0141: ldfld field:Godot.Control _selectModeBackstop
 0146: ldc.i4.0 
 0147: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0152: ldarg.0 
 0153: ldfld field:Godot.Control _selectModeBackstop
 0158: ldc.i4.2 
 0159: conv.i8 
 0160: callvirt method:Godot.Control.Void set_MouseFilter(MouseFilterEnum)
 0165: ldarg.0 
 0166: call method:Godot.Node.Godot.Tween CreateTween()
 0171: stloc.0 
 0172: ldloc.0 
 0173: ldarg.0 
 0174: ldfld field:Godot.Control _selectModeBackstop
 0179: ldstr str:self_modulate:a
 0184: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0189: ldc.r4 0
 0194: call method:Godot.Variant.Godot.Variant op_Implicit(Single)
 0199: ldc.r8 0.20000000298023224
 0208: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 0213: pop 
 0214: ldarg.0 
 0215: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NConfirmButton _selectModeConfirmButton
 0220: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Disable()
 0225: ldarg.0 
 0226: ldfld field:Godot.Control _upgradePreviewContainer
 0231: ldc.i4.0 
 0232: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0237: ldarg.0 
 0238: ldfld field:MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel _selectionHeader
 0243: ldc.i4.0 
 0244: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0249: ldarg.0 
 0250: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton get_PeekButton()
 0255: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Disable()
 0260: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom get_Instance()
 0265: callvirt method:MegaCrit.Sts2.Core.Nodes.Rooms.NCombatRoom.MegaCrit.Sts2.Core.Nodes.Combat.NCombatUi get_Ui()
 0270: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NCombatUi.Void OnHandSelectModeExited()
 0275: ldarg.1 
 0276: brfalse.s 297
 0278: ldarg.1 
 0279: ldarg.0 
 0280: ldftn method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void OnSelectModeSourceFinished(MegaCrit.Sts2.Core.Models.AbstractModel)
 0286: newobj method:System.Action`1[MegaCrit.Sts2.Core.Models.AbstractModel].Void .ctor(System.Object, IntPtr)
 0291: callvirt method:MegaCrit.Sts2.Core.Models.AbstractModel.Void add_ExecutionFinished(System.Action`1[MegaCrit.Sts2.Core.Models.AbstractModel])
 0296: ret 
 0297: ldarg.0 
 0298: ldnull 
 0299: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void OnSelectModeSourceFinished(MegaCrit.Sts2.Core.Models.AbstractModel)
 0304: ret 
METHOD Void CancelHandSelectionIfNecessary()
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Boolean get_IsInCardSelection()
 0006: brfalse.s 34
 0008: ldarg.0 
 0009: ldfld field:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] _selectionCompletionSource
 0014: brfalse.s 34
 0016: ldarg.0 
 0017: ldfld field:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] _selectionCompletionSource
 0022: callvirt method:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetCanceled()
 0027: ldarg.0 
 0028: ldnull 
 0029: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void AfterCardsSelected(MegaCrit.Sts2.Core.Models.AbstractModel)
 0034: ret 
METHOD Void OnHolderPressed(MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder)
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton get_PeekButton()
 0006: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton.Boolean get_IsPeeking()
 0011: brfalse.s 25
 0013: ldarg.0 
 0014: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton get_PeekButton()
 0019: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton.Void Wiggle()
 0024: ret 
 0025: ldarg.1 
 0026: castclass type:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder
 0031: stloc.0 
 0032: ldloc.0 
 0033: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0038: brtrue.s 41
 0040: ret 
 0041: call method:MegaCrit.Sts2.Core.Combat.CombatManager.MegaCrit.Sts2.Core.Combat.CombatManager get_Instance()
 0046: callvirt method:MegaCrit.Sts2.Core.Combat.CombatManager.Boolean get_IsInProgress()
 0051: brtrue.s 54
 0053: ret 
 0054: call method:MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack.MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack get_Instance()
 0059: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Overlays.NOverlayStack.Int32 get_ScreenCount()
 0064: ldc.i4.0 
 0065: ble.s 68
 0067: ret 
 0068: ldarg.0 
 0069: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Mode get_CurrentMode()
 0074: stloc.1 
 0075: ldloc.1 
 0076: switch switch 4
 0097: br.s 132
 0099: ldarg.0 
 0100: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Boolean CanPlayCards()
 0105: brfalse.s 143
 0107: ldarg.0 
 0108: ldloc.0 
 0109: ldc.i4.0 
 0110: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void StartCardPlay(MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder, Boolean)
 0115: ret 
 0116: ldarg.0 
 0117: ldloc.0 
 0118: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void SelectCardInSimpleMode(MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder)
 0123: ret 
 0124: ldarg.0 
 0125: ldloc.0 
 0126: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void SelectCardInUpgradeMode(MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder)
 0131: ret 
 0132: ldstr str:CurrentMode
 0137: newobj method:System.ArgumentOutOfRangeException.Void .ctor(System.String)
 0142: throw 
 0143: ret 
METHOD Void SelectCardInSimpleMode(MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder)
 0000: ldarg.0 
 0001: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0006: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0011: ldarg.0 
 0012: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs _prefs
 0017: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MaxSelect()
 0022: blt.s 46
 0024: ldarg.0 
 0025: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0030: ldarg.0 
 0031: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0036: call method:System.Linq.Enumerable.MegaCrit.Sts2.Core.Models.CardModel Last[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0041: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer.Void DeselectCard(MegaCrit.Sts2.Core.Models.CardModel)
 0046: ldarg.0 
 0047: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0052: ldarg.1 
 0053: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0058: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.MegaCrit.Sts2.Core.Models.CardModel get_Model()
 0063: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Void Add(MegaCrit.Sts2.Core.Models.CardModel)
 0068: ldarg.0 
 0069: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0074: ldarg.1 
 0075: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer.MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder Add(MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder)
 0080: pop 
 0081: ldarg.0 
 0082: ldarg.1 
 0083: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void RemoveCardHolder(MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder)
 0088: ldarg.0 
 0089: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void RefreshSelectModeConfirmButton()
 0094: ret 
METHOD Void SelectCardInUpgradeMode(MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder)
 0000: ldarg.1 
 0001: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0006: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.MegaCrit.Sts2.Core.Models.CardModel get_Model()
 0011: stloc.0 
 0012: ldarg.0 
 0013: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0018: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0023: brfalse.s 67
 0025: ldarg.0 
 0026: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0031: call method:System.Linq.Enumerable.MegaCrit.Sts2.Core.Models.CardModel Last[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0036: ldc.i4.1 
 0037: call method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.MegaCrit.Sts2.Core.Nodes.Cards.NCard Create(MegaCrit.Sts2.Core.Models.CardModel, MegaCrit.Sts2.Core.Entities.UI.ModelVisibility)
 0042: stloc.1 
 0043: ldloc.1 
 0044: ldarg.0 
 0045: ldfld field:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview _upgradePreview
 0050: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview.Godot.Vector2 get_SelectedCardPosition()
 0055: callvirt method:Godot.Control.Void set_GlobalPosition(Godot.Vector2)
 0060: ldarg.0 
 0061: ldloc.1 
 0062: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void DeselectCard(MegaCrit.Sts2.Core.Nodes.Cards.NCard)
 0067: ldarg.0 
 0068: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0073: ldloc.0 
 0074: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Void Add(MegaCrit.Sts2.Core.Models.CardModel)
 0079: ldarg.0 
 0080: ldfld field:Godot.Control _upgradePreviewContainer
 0085: ldc.i4.1 
 0086: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0091: ldarg.0 
 0092: ldfld field:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview _upgradePreview
 0097: ldloc.0 
 0098: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview.Void set_Card(MegaCrit.Sts2.Core.Models.CardModel)
 0103: ldarg.0 
 0104: ldarg.1 
 0105: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void RemoveCardHolder(MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder)
 0110: ldarg.0 
 0111: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void RefreshSelectModeConfirmButton()
 0116: ret 
METHOD Void DeselectCard(MegaCrit.Sts2.Core.Nodes.Cards.NCard)
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Boolean get_IsInCardSelection()
 0006: brtrue.s 19
 0008: ldstr str:Only valid when in Select Mode.
 0013: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0018: throw 
 0019: ldarg.0 
 0020: ldarg.1 
 0021: ldarg.0 
 0022: ldarg.1 
 0023: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.MegaCrit.Sts2.Core.Models.CardModel get_Model()
 0028: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Int32 GetHandInsertIndex(MegaCrit.Sts2.Core.Models.CardModel)
 0033: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder Add(MegaCrit.Sts2.Core.Nodes.Cards.NCard, Int32)
 0038: stloc.0 
 0039: ldloc.0 
 0040: ldc.i4.1 
 0041: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder.Void set_InSelectMode(Boolean)
 0046: ldloc.0 
 0047: ldc.i4.1 
 0048: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0053: ldarg.0 
 0054: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0059: ldarg.1 
 0060: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.MegaCrit.Sts2.Core.Models.CardModel get_Model()
 0065: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Boolean Remove(MegaCrit.Sts2.Core.Models.CardModel)
 0070: pop 
 0071: ldarg.0 
 0072: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void RefreshSelectModeConfirmButton()
 0077: ldloc.0 
 0078: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NodeUtil.Void TryGrabFocus(Godot.Control)
 0083: ret 
METHOD Void RevalidateSelectionAfterStateChange()
 0000: newobj method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand+<>c__DisplayClass94_0.Void .ctor()
 0005: stloc.0 
 0006: ldloc.0 
 0007: ldarg.0 
 0008: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] _currentSelectionFilter
 0013: stfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0018: ldloc.0 
 0019: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0024: brtrue.s 27
 0026: ret 
 0027: ldarg.0 
 0028: ldfld field:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview _upgradePreview
 0033: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview.MegaCrit.Sts2.Core.Models.CardModel get_Card()
 0038: brfalse.s 134
 0040: ldloc.0 
 0041: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0046: ldarg.0 
 0047: ldfld field:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview _upgradePreview
 0052: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview.MegaCrit.Sts2.Core.Models.CardModel get_Card()
 0057: callvirt method:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean].Boolean Invoke(MegaCrit.Sts2.Core.Models.CardModel)
 0062: brtrue.s 134
 0064: ldarg.0 
 0065: ldfld field:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview _upgradePreview
 0070: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview.MegaCrit.Sts2.Core.Models.CardModel get_Card()
 0075: stloc.2 
 0076: ldarg.0 
 0077: ldfld field:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview _upgradePreview
 0082: ldnull 
 0083: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview.Void set_Card(MegaCrit.Sts2.Core.Models.CardModel)
 0088: ldarg.0 
 0089: ldfld field:Godot.Control _upgradePreviewContainer
 0094: ldc.i4.0 
 0095: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0100: ldarg.0 
 0101: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0106: ldloc.2 
 0107: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Boolean Remove(MegaCrit.Sts2.Core.Models.CardModel)
 0112: pop 
 0113: ldarg.0 
 0114: ldloc.2 
 0115: ldc.i4.1 
 0116: call method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.MegaCrit.Sts2.Core.Nodes.Cards.NCard Create(MegaCrit.Sts2.Core.Models.CardModel, MegaCrit.Sts2.Core.Entities.UI.ModelVisibility)
 0121: ldarg.0 
 0122: ldloc.2 
 0123: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Int32 GetHandInsertIndex(MegaCrit.Sts2.Core.Models.CardModel)
 0128: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder Add(MegaCrit.Sts2.Core.Nodes.Cards.NCard, Int32)
 0133: pop 
 0134: ldarg.0 
 0135: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0140: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder] get_Holders()
 0145: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder] ToList[NSelectedHandCardHolder](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder])
 0150: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder].Enumerator GetEnumerator()
 0155: stloc.3 
 0156: br.s 220
 0158: ldloca.s 3
 0160: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder].MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder get_Current()
 0165: stloc.s 4
 0167: ldloc.s 4
 0169: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0174: dup 
 0175: brtrue.s 181
 0177: pop 
 0178: ldnull 
 0179: br.s 186
 0181: call method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.MegaCrit.Sts2.Core.Models.CardModel get_Model()
 0186: stloc.s 5
 0188: ldloc.s 5
 0190: brfalse.s 220
 0192: ldloc.0 
 0193: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] filter
 0198: ldloc.s 5
 0200: callvirt method:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean].Boolean Invoke(MegaCrit.Sts2.Core.Models.CardModel)
 0205: brtrue.s 220
 0207: ldarg.0 
 0208: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0213: ldloc.s 5
 0215: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer.Void DeselectCard(MegaCrit.Sts2.Core.Models.CardModel)
 0220: ldloca.s 3
 0222: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder].Boolean MoveNext()
 0227: brtrue.s 158
 0229: leave.s 245
 0231: ldloca.s 3
 0233: constrained. type:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder]
 0239: callvirt method:System.IDisposable.Void Dispose()
 0244: endfinally 
 0245: ldarg.0 
 0246: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void UpdateSelectModeCardVisibility()
 0251: ldarg.0 
 0252: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder] get_Holders()
 0257: ldloc.0 
 0258: ldftn method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand+<>c__DisplayClass94_0.Boolean <RevalidateSelectionAfterStateChange>b__0(MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder)
 0264: newobj method:System.Func`2[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder,System.Boolean].Void .ctor(System.Object, IntPtr)
 0269: call method:System.Linq.Enumerable.Boolean Any[NHandCardHolder](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder], System.Func`2[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder,System.Boolean])
 0274: stloc.1 
 0275: ldarg.0 
 0276: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0281: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0286: brtrue.s 314
 0288: ldloc.1 
 0289: brtrue.s 314
 0291: ldarg.0 
 0292: ldfld field:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] _selectionCompletionSource
 0297: dup 
 0298: brtrue.s 302
 0300: pop 
 0301: ret 
 0302: call method:System.Array.MegaCrit.Sts2.Core.Models.CardModel[] Empty[CardModel]()
 0307: call method:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Boolean TrySetResult(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0312: pop 
 0313: ret 
 0314: ldarg.0 
 0315: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void RefreshSelectModeConfirmButton()
 0320: ret 
METHOD Void OnSelectModeConfirmButtonPressed(MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton)
 0000: ldarg.0 
 0001: ldfld field:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] _selectionCompletionSource
 0006: ldarg.0 
 0007: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0012: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0017: callvirt method:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetResult(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0022: ret 
METHOD Void CheckIfSelectionComplete()
 0000: ldarg.0 
 0001: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0006: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0011: ldarg.0 
 0012: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs _prefs
 0017: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MaxSelect()
 0022: blt.s 46
 0024: ldarg.0 
 0025: ldfld field:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]] _selectionCompletionSource
 0030: ldarg.0 
 0031: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0036: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] ToList[CardModel](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0041: callvirt method:System.Threading.Tasks.TaskCompletionSource`1[System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel]].Void SetResult(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Models.CardModel])
 0046: ret 
METHOD Void RefreshSelectModeConfirmButton()
 0000: ldarg.0 
 0001: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel] _selectedCards
 0006: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Models.CardModel].Int32 get_Count()
 0011: stloc.0 
 0012: ldloc.0 
 0013: ldarg.0 
 0014: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs _prefs
 0019: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MinSelect()
 0024: blt.s 52
 0026: ldloc.0 
 0027: ldarg.0 
 0028: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs _prefs
 0033: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Int32 get_MaxSelect()
 0038: bgt.s 52
 0040: ldarg.0 
 0041: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NConfirmButton _selectModeConfirmButton
 0046: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Enable()
 0051: ret 
 0052: ldarg.0 
 0053: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NConfirmButton _selectModeConfirmButton
 0058: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Disable()
 0063: ret 
METHOD Void OnSelectModeSourceFinished(MegaCrit.Sts2.Core.Models.AbstractModel)
 0000: ldarg.0 
 0001: ldfld field:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer _selectedHandCardContainer
 0006: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NSelectedHandCardContainer.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder] get_Holders()
 0011: call method:System.Linq.Enumerable.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder] ToList[NSelectedHandCardHolder](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder])
 0016: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder].Enumerator GetEnumerator()
 0021: stloc.0 
 0022: br.s 54
 0024: ldloca.s 0
 0026: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder].MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder get_Current()
 0031: stloc.1 
 0032: ldloc.1 
 0033: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0038: stloc.2 
 0039: ldloc.1 
 0040: call method:MegaCrit.Sts2.Core.Helpers.GodotTreeExtensions.Void QueueFreeSafely(Godot.Node)
 0045: ldarg.0 
 0046: ldloc.2 
 0047: ldc.i4.m1 
 0048: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder Add(MegaCrit.Sts2.Core.Nodes.Cards.NCard, Int32)
 0053: pop 
 0054: ldloca.s 0
 0056: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder].Boolean MoveNext()
 0061: brtrue.s 24
 0063: leave.s 79
 0065: ldloca.s 0
 0067: constrained. type:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NSelectedHandCardHolder]
 0073: callvirt method:System.IDisposable.Void Dispose()
 0078: endfinally 
 0079: ldarg.0 
 0080: ldfld field:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview _upgradePreview
 0085: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview.MegaCrit.Sts2.Core.Models.CardModel get_Card()
 0090: brfalse.s 129
 0092: ldarg.0 
 0093: ldarg.0 
 0094: ldfld field:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview _upgradePreview
 0099: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview.MegaCrit.Sts2.Core.Models.CardModel get_Card()
 0104: ldc.i4.1 
 0105: call method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.MegaCrit.Sts2.Core.Nodes.Cards.NCard Create(MegaCrit.Sts2.Core.Models.CardModel, MegaCrit.Sts2.Core.Entities.UI.ModelVisibility)
 0110: ldc.i4.m1 
 0111: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder Add(MegaCrit.Sts2.Core.Nodes.Cards.NCard, Int32)
 0116: pop 
 0117: ldarg.0 
 0118: ldfld field:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview _upgradePreview
 0123: ldnull 
 0124: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NUpgradePreview.Void set_Card(MegaCrit.Sts2.Core.Models.CardModel)
 0129: ldarg.1 
 0130: brfalse.s 150
 0132: ldarg.1 
 0133: ldarg.0 
 0134: ldftn method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void OnSelectModeSourceFinished(MegaCrit.Sts2.Core.Models.AbstractModel)
 0140: newobj method:System.Action`1[MegaCrit.Sts2.Core.Models.AbstractModel].Void .ctor(System.Object, IntPtr)
 0145: callvirt method:MegaCrit.Sts2.Core.Models.AbstractModel.Void remove_ExecutionFinished(System.Action`1[MegaCrit.Sts2.Core.Models.AbstractModel])
 0150: ret 
METHOD Void UpdateSelectModeCardVisibility()
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Mode get_CurrentMode()
 0006: ldc.i4.2 
 0007: beq.s 29
 0009: ldarg.0 
 0010: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Mode get_CurrentMode()
 0015: ldc.i4.3 
 0016: beq.s 29
 0018: ldstr str:Can only be used when we are selecting a card
 0023: newobj method:System.InvalidOperationException.Void .ctor(System.String)
 0028: throw 
 0029: ldarg.0 
 0030: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder] get_Holders()
 0035: callvirt method:System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder].System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder] GetEnumerator()
 0040: stloc.0 
 0041: br 195
 0046: ldloc.0 
 0047: callvirt method:System.Collections.Generic.IEnumerator`1[MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder].MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder get_Current()
 0052: stloc.1 
 0053: ldloc.1 
 0054: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0059: brfalse 195
 0064: ldarg.0 
 0065: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton get_PeekButton()
 0070: callvirt method:MegaCrit.Sts2.Core.Nodes.Combat.NPeekButton.Boolean get_IsPeeking()
 0075: brfalse.s 110
 0077: ldloc.1 
 0078: ldc.i4.1 
 0079: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0084: ldloc.1 
 0085: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0090: ldc.i4.0 
 0091: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.Void SetPretendCardCanBePlayed(Boolean)
 0096: ldloc.1 
 0097: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0102: ldc.i4.0 
 0103: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.Void SetForceUnpoweredPreview(Boolean)
 0108: br.s 189
 0110: ldloc.1 
 0111: ldarg.0 
 0112: ldfld field:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean] _currentSelectionFilter
 0117: dup 
 0118: brtrue.s 124
 0120: pop 
 0121: ldc.i4.1 
 0122: br.s 140
 0124: ldloc.1 
 0125: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0130: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.MegaCrit.Sts2.Core.Models.CardModel get_Model()
 0135: callvirt method:System.Func`2[MegaCrit.Sts2.Core.Models.CardModel,System.Boolean].Boolean Invoke(MegaCrit.Sts2.Core.Models.CardModel)
 0140: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0145: ldloc.1 
 0146: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0151: ldarg.0 
 0152: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs _prefs
 0157: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Boolean get_PretendCardsCanBePlayed()
 0162: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.Void SetPretendCardCanBePlayed(Boolean)
 0167: ldloc.1 
 0168: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NCardHolder.MegaCrit.Sts2.Core.Nodes.Cards.NCard get_CardNode()
 0173: ldarg.0 
 0174: ldflda field:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs _prefs
 0179: call method:MegaCrit.Sts2.Core.CardSelection.CardSelectorPrefs.Boolean get_UnpoweredPreviews()
 0184: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.NCard.Void SetForceUnpoweredPreview(Boolean)
 0189: ldloc.1 
 0190: callvirt method:MegaCrit.Sts2.Core.Nodes.Cards.Holders.NHandCardHolder.Void UpdateCard()
 0195: ldloc.0 
 0196: callvirt method:System.Collections.IEnumerator.Boolean MoveNext()
 0201: brtrue 46
 0206: leave.s 218
 0208: ldloc.0 
 0209: brfalse.s 217
 0211: ldloc.0 
 0212: callvirt method:System.IDisposable.Void Dispose()
 0217: endfinally 
 0218: ldarg.0 
 0219: call method:MegaCrit.Sts2.Core.Nodes.Combat.NPlayerHand.Void RefreshLayout()
 0224: ret 
METHOD Void set_CurrentMode(Mode)
 0000: ldarg.0 
 0001: ldarg.1 
 0002: stfld field:Mode _currentMode
 0007: ldarg.0 
 0008: ldsfld field:Godot.StringName ModeChanged
 0013: call method:System.Array.Godot.Variant[] Empty[Variant]()
 0018: call method:Godot.GodotObject.Godot.Error EmitSignal(Godot.StringName, Godot.Variant[])
 0023: pop 
 0024: ret 
