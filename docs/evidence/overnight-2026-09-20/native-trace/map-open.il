METHOD MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen Open(Boolean)
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Boolean get_IsOpen()
 0006: brfalse.s 10
 0008: ldarg.0 
 0009: ret 
 0010: ldarg.0 
 0011: ldc.i4.1 
 0012: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Void set_IsOpen(Boolean)
 0017: ldarg.0 
 0018: ldc.i4.1 
 0019: call method:Godot.CanvasItem.Void set_Visible(Boolean)
 0024: ldarg.0 
 0025: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NBackButton _backButton
 0030: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NBackButton.Void MoveToHidePosition()
 0035: call method:MegaCrit.Sts2.Core.Nodes.CommonUi.NHotkeyManager.MegaCrit.Sts2.Core.Nodes.CommonUi.NHotkeyManager get_Instance()
 0040: ldsfld field:Godot.StringName confirm
 0045: call method:Godot.StringName.System.String op_Implicit(Godot.StringName)
 0050: ldarg.0 
 0051: ldftn method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Void OnLegendHotkeyPressed()
 0057: newobj method:System.Action.Void .ctor(System.Object, IntPtr)
 0062: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NHotkeyManager.Void PushHotkeyPressedBinding(System.String, System.Action)
 0067: call method:MegaCrit.Sts2.Core.Nodes.CommonUi.NHotkeyManager.MegaCrit.Sts2.Core.Nodes.CommonUi.NHotkeyManager get_Instance()
 0072: ldsfld field:Godot.StringName viewExhaustPileAndTabRight
 0077: call method:Godot.StringName.System.String op_Implicit(Godot.StringName)
 0082: ldarg.0 
 0083: ldftn method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Void OnDrawingToolsHotkeyPressed()
 0089: newobj method:System.Action.Void .ctor(System.Object, IntPtr)
 0094: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NHotkeyManager.Void PushHotkeyPressedBinding(System.String, System.Action)
 0099: ldarg.0 
 0100: ldfld field:MegaCrit.Sts2.Core.Runs.RunState _runState
 0105: callvirt method:MegaCrit.Sts2.Core.Runs.RunState.Int32 get_ActFloor()
 0110: ldc.i4.0 
 0111: ble.s 124
 0113: ldarg.0 
 0114: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NBackButton _backButton
 0119: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Enable()
 0124: ldarg.0 
 0125: ldc.i4.0 
 0126: conv.i8 
 0127: call method:Godot.Node.Void set_ProcessMode(ProcessModeEnum)
 0132: call method:MegaCrit.Sts2.Core.Nodes.NRun.MegaCrit.Sts2.Core.Nodes.NRun get_Instance()
 0137: callvirt method:MegaCrit.Sts2.Core.Nodes.NRun.MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi get_GlobalUi()
 0142: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi.MegaCrit.Sts2.Core.Nodes.CommonUi.NTopBar get_TopBar()
 0147: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NTopBar.MegaCrit.Sts2.Core.Nodes.TopBar.NTopBarMapButton get_Map()
 0152: callvirt method:MegaCrit.Sts2.Core.Nodes.TopBar.NTopBarMapButton.Void StartOscillation()
 0157: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0162: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.Boolean get_IsSingleplayerOrFakeMultiplayer()
 0167: brfalse.s 179
 0169: call method:MegaCrit.Sts2.Core.Combat.CombatManager.MegaCrit.Sts2.Core.Combat.CombatManager get_Instance()
 0174: callvirt method:MegaCrit.Sts2.Core.Combat.CombatManager.Void Pause()
 0179: ldarg.0 
 0180: ldfld field:MegaCrit.Sts2.Core.Runs.RunState _runState
 0185: callvirt method:MegaCrit.Sts2.Core.Runs.RunState.Int32 get_CurrentActIndex()
 0190: brtrue.s 210
 0192: ldarg.0 
 0193: ldfld field:MegaCrit.Sts2.Core.Runs.RunState _runState
 0198: callvirt method:MegaCrit.Sts2.Core.Runs.RunState.MegaCrit.Sts2.Core.Runs.ExtraRunFields get_ExtraFields()
 0203: callvirt method:MegaCrit.Sts2.Core.Runs.ExtraRunFields.Boolean get_StartedWithNeow()
 0208: brtrue.s 226
 0210: ldarg.0 
 0211: ldfld field:MegaCrit.Sts2.Core.Runs.RunState _runState
 0216: callvirt method:MegaCrit.Sts2.Core.Runs.RunState.Int32 get_ActFloor()
 0221: ldc.i4.0 
 0222: ceq 
 0224: br.s 240
 0226: ldarg.0 
 0227: ldfld field:MegaCrit.Sts2.Core.Runs.RunState _runState
 0232: callvirt method:MegaCrit.Sts2.Core.Runs.RunState.Int32 get_ActFloor()
 0237: ldc.i4.1 
 0238: ceq 
 0240: stloc.0 
 0241: ldloc.0 
 0242: brfalse 438
 0247: ldarg.0 
 0248: ldfld field:Boolean _hasPlayedAnimation
 0253: brtrue 438
 0258: ldarg.1 
 0259: brtrue.s 302
 0261: call method:MegaCrit.Sts2.Core.Saves.SaveManager.MegaCrit.Sts2.Core.Saves.SaveManager get_Instance()
 0266: callvirt method:MegaCrit.Sts2.Core.Saves.SaveManager.MegaCrit.Sts2.Core.Saves.PrefsSave get_PrefsSave()
 0271: callvirt method:MegaCrit.Sts2.Core.Saves.PrefsSave.MegaCrit.Sts2.Core.Settings.FastModeType get_FastMode()
 0276: ldc.i4.2 
 0277: blt.s 299
 0279: call method:MegaCrit.Sts2.Core.Saves.SaveManager.MegaCrit.Sts2.Core.Saves.SaveManager get_Instance()
 0284: ldstr str:map_select_ftue
 0289: callvirt method:MegaCrit.Sts2.Core.Saves.SaveManager.Boolean SeenFtue(System.String)
 0294: ldc.i4.0 
 0295: ceq 
 0297: br.s 303
 0299: ldc.i4.1 
 0300: br.s 303
 0302: ldc.i4.0 
 0303: stloc.2 
 0304: ldloc.2 
 0305: brfalse.s 318
 0307: ldarg.0 
 0308: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Void PlayStartOfActAnimation()
 0313: br 654
 0318: ldarg.0 
 0319: ldc.i4.1 
 0320: stfld field:Boolean _hasPlayedAnimation
 0325: ldarg.0 
 0326: ldfld field:Godot.Control _mapContainer
 0331: ldarg.0 
 0332: ldfld field:Godot.Control _mapContainer
 0337: callvirt method:Godot.Control.Godot.Vector2 get_Position()
 0342: stloc.s 4
 0344: ldloca.s 4
 0346: ldc.r4 -600
 0351: stfld field:Single Y
 0356: ldloc.s 4
 0358: callvirt method:Godot.Control.Void set_Position(Godot.Vector2)
 0363: ldarg.0 
 0364: ldc.r4 0
 0369: ldc.r4 -600
 0374: newobj method:Godot.Vector2.Void .ctor(Single, Single)
 0379: stfld field:Godot.Vector2 _targetDragPos
 0384: ldarg.0 
 0385: ldfld field:MegaCrit.Sts2.Core.Runs.RunState _runState
 0390: callvirt method:MegaCrit.Sts2.Core.Runs.RunState.MegaCrit.Sts2.Core.Models.ActModel get_Act()
 0395: ldarg.0 
 0396: ldfld field:MegaCrit.Sts2.Core.Runs.RunState _runState
 0401: callvirt method:MegaCrit.Sts2.Core.Runs.RunState.Int32 get_CurrentActIndex()
 0406: call method:MegaCrit.Sts2.Core.Nodes.NActBanner.MegaCrit.Sts2.Core.Nodes.NActBanner Create(MegaCrit.Sts2.Core.Models.ActModel, Int32)
 0411: stloc.3 
 0412: call method:MegaCrit.Sts2.Core.Nodes.NRun.MegaCrit.Sts2.Core.Nodes.NRun get_Instance()
 0417: callvirt method:MegaCrit.Sts2.Core.Nodes.NRun.MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi get_GlobalUi()
 0422: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NGlobalUi.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen get_MapScreen()
 0427: ldloc.3 
 0428: call method:MegaCrit.Sts2.Core.Helpers.GodotTreeExtensions.Void AddChildSafely(Godot.Node, Godot.Node)
 0433: br 654
 0438: ldarg.0 
 0439: ldfld field:MegaCrit.Sts2.Core.Runs.RunState _runState
 0444: callvirt method:MegaCrit.Sts2.Core.Runs.RunState.System.Nullable`1[MegaCrit.Sts2.Core.Map.MapCoord] get_CurrentMapCoord()
 0449: stloc.s 6
 0451: ldloca.s 6
 0453: dup 
 0454: call method:System.Nullable`1[MegaCrit.Sts2.Core.Map.MapCoord].Boolean get_HasValue()
 0459: brtrue.s 465
 0461: pop 
 0462: ldc.i4.0 
 0463: br.s 475
 0465: call method:System.Nullable`1[MegaCrit.Sts2.Core.Map.MapCoord].MegaCrit.Sts2.Core.Map.MapCoord GetValueOrDefault()
 0470: ldfld field:Int32 row
 0475: stloc.s 5
 0477: ldarg.0 
 0478: ldc.r4 0
 0483: ldc.r4 -600
 0488: ldloc.s 5
 0490: conv.r4 
 0491: ldarg.0 
 0492: ldfld field:Single _distY
 0497: mul 
 0498: add 
 0499: newobj method:Godot.Vector2.Void .ctor(Single, Single)
 0504: stfld field:Godot.Vector2 _targetDragPos
 0509: ldarg.0 
 0510: ldfld field:Godot.Control _mapContainer
 0515: ldc.r4 0
 0520: ldc.r4 -600
 0525: ldloc.s 5
 0527: conv.r4 
 0528: ldarg.0 
 0529: ldfld field:Single _distY
 0534: mul 
 0535: add 
 0536: newobj method:Godot.Vector2.Void .ctor(Single, Single)
 0541: callvirt method:Godot.Control.Void set_Position(Godot.Vector2)
 0546: ldarg.0 
 0547: ldfld field:Godot.Control _points
 0552: ldarg.0 
 0553: ldfld field:Godot.Control _points
 0558: callvirt method:Godot.CanvasItem.Godot.Color get_Modulate()
 0563: stloc.s 7
 0565: ldloca.s 7
 0567: ldc.r4 0
 0572: stfld field:Single A
 0577: ldloc.s 7
 0579: callvirt method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0584: ldarg.0 
 0585: ldfld field:Godot.Control _backstop
 0590: ldarg.0 
 0591: ldfld field:Godot.Control _backstop
 0596: callvirt method:Godot.CanvasItem.Godot.Color get_Modulate()
 0601: stloc.s 7
 0603: ldloca.s 7
 0605: ldc.r4 0
 0610: stfld field:Single A
 0615: ldloc.s 7
 0617: callvirt method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0622: ldarg.0 
 0623: ldfld field:Godot.Control _mapLegend
 0628: ldsfld field:Godot.Color transparentBlack
 0633: callvirt method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0638: ldarg.0 
 0639: ldfld field:Godot.Control _drawingTools
 0644: ldsfld field:Godot.Color transparentBlack
 0649: callvirt method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0654: ldarg.0 
 0655: ldfld field:Godot.Control _mapLegend
 0660: ldarg.0 
 0661: ldfld field:Godot.Control _mapLegend
 0666: callvirt method:Godot.CanvasItem.Godot.Color get_Modulate()
 0671: stloc.s 7
 0673: ldloca.s 7
 0675: ldc.r4 0
 0680: stfld field:Single A
 0685: ldloc.s 7
 0687: callvirt method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0692: ldarg.0 
 0693: ldfld field:Godot.Control _drawingTools
 0698: ldarg.0 
 0699: ldfld field:Godot.Control _drawingTools
 0704: callvirt method:Godot.CanvasItem.Godot.Color get_Modulate()
 0709: stloc.s 7
 0711: ldloca.s 7
 0713: ldc.r4 0
 0718: stfld field:Single A
 0723: ldloc.s 7
 0725: callvirt method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0730: ldarg.0 
 0731: ldfld field:Godot.Tween _tween
 0736: dup 
 0737: brtrue.s 742
 0739: pop 
 0740: br.s 747
 0742: call method:Godot.Tween.Void Kill()
 0747: ldarg.0 
 0748: ldarg.0 
 0749: call method:Godot.Node.Godot.Tween CreateTween()
 0754: ldc.i4.1 
 0755: callvirt method:Godot.Tween.Godot.Tween SetParallel(Boolean)
 0760: stfld field:Godot.Tween _tween
 0765: ldarg.0 
 0766: ldfld field:Godot.Tween _tween
 0771: ldarg.0 
 0772: ldfld field:Godot.Control _backstop
 0777: ldstr str:modulate:a
 0782: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0787: ldc.r4 0.85
 0792: call method:Godot.Variant.Godot.Variant op_Implicit(Single)
 0797: ldc.r8 0.25
 0806: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 0811: pop 
 0812: ldarg.0 
 0813: ldfld field:Godot.Tween _tween
 0818: ldarg.0 
 0819: ldfld field:Godot.Control _mapContainer
 0824: ldstr str:modulate
 0829: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0834: call method:Godot.Colors.Godot.Color get_White()
 0839: call method:Godot.Variant.Godot.Variant op_Implicit(Godot.Color)
 0844: ldc.r8 0.25
 0853: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 0858: ldsfld field:Godot.Color transparentBlack
 0863: call method:Godot.Variant.Godot.Variant op_Implicit(Godot.Color)
 0868: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener From(Godot.Variant)
 0873: pop 
 0874: ldarg.0 
 0875: ldfld field:Godot.Tween _tween
 0880: ldarg.0 
 0881: ldfld field:Godot.Control _mapLegend
 0886: ldstr str:modulate
 0891: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0896: call method:Godot.Colors.Godot.Color get_White()
 0901: call method:Godot.Variant.Godot.Variant op_Implicit(Godot.Color)
 0906: ldc.r8 0.25
 0915: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 0920: ldc.r8 0.1
 0929: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetDelay(Double)
 0934: pop 
 0935: ldarg.0 
 0936: ldfld field:Godot.Tween _tween
 0941: ldarg.0 
 0942: ldfld field:Godot.Control _mapLegend
 0947: ldstr str:position:x
 0952: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0957: ldarg.0 
 0958: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Single get_MapLegendX()
 0963: call method:Godot.Variant.Godot.Variant op_Implicit(Single)
 0968: ldc.r8 0.25
 0977: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 0982: ldarg.0 
 0983: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Single get_MapLegendX()
 0988: ldc.r4 120
 0993: add 
 0994: call method:Godot.Variant.Godot.Variant op_Implicit(Single)
 0999: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener From(Godot.Variant)
 1004: ldc.i4.1 
 1005: conv.i8 
 1006: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetEase(EaseType)
 1011: ldc.i4.s 10
 1013: conv.i8 
 1014: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetTrans(TransitionType)
 1019: ldc.r8 0.1
 1028: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetDelay(Double)
 1033: pop 
 1034: ldarg.0 
 1035: ldfld field:Godot.Tween _tween
 1040: ldarg.0 
 1041: ldfld field:Godot.Control _drawingTools
 1046: ldstr str:modulate
 1051: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 1056: call method:Godot.Colors.Godot.Color get_White()
 1061: call method:Godot.Variant.Godot.Variant op_Implicit(Godot.Color)
 1066: ldc.r8 0.25
 1075: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 1080: ldc.r8 0.2
 1089: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetDelay(Double)
 1094: pop 
 1095: ldarg.0 
 1096: ldfld field:Godot.Tween _tween
 1101: ldarg.0 
 1102: ldfld field:Godot.Control _points
 1107: ldstr str:modulate:a
 1112: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 1117: ldc.r4 1
 1122: call method:Godot.Variant.Godot.Variant op_Implicit(Single)
 1127: ldc.r8 0.25
 1136: callvirt method:Godot.Tween.Godot.PropertyTweener TweenProperty(Godot.GodotObject, Godot.NodePath, Godot.Variant, Double)
 1141: ldc.r8 0.1
 1150: callvirt method:Godot.PropertyTweener.Godot.PropertyTweener SetDelay(Double)
 1155: pop 
 1156: ldarg.0 
 1157: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Void RecalculateTravelability()
 1162: ldarg.0 
 1163: ldfld field:MegaCrit.Sts2.Core.Runs.RunState _runState
 1168: callvirt method:MegaCrit.Sts2.Core.Runs.RunState.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Map.MapCoord] get_VisitedMapCoords()
 1173: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Map.MapCoord].Int32 get_Count()
 1178: brfalse 1357
 1183: ldarg.0 
 1184: ldfld field:MegaCrit.Sts2.Core.Runs.RunState _runState
 1189: callvirt method:MegaCrit.Sts2.Core.Runs.RunState.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Map.MapCoord] get_VisitedMapCoords()
 1194: dup 
 1195: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Map.MapCoord].Int32 get_Count()
 1200: ldc.i4.1 
 1201: sub 
 1202: callvirt method:System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Map.MapCoord].MegaCrit.Sts2.Core.Map.MapCoord get_Item(Int32)
 1207: stloc.s 8
 1209: ldarg.0 
 1210: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.Map.NBossMapPoint _bossPointNode
 1215: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint.MegaCrit.Sts2.Core.Map.MapPoint get_Point()
 1220: ldflda field:MegaCrit.Sts2.Core.Map.MapCoord coord
 1225: ldfld field:Int32 row
 1230: ldloc.s 8
 1232: ldfld field:Int32 row
 1237: beq.s 1357
 1239: ldarg.0 
 1240: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint _startingPointNode
 1245: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint.MegaCrit.Sts2.Core.Map.MapPoint get_Point()
 1250: ldflda field:MegaCrit.Sts2.Core.Map.MapCoord coord
 1255: ldfld field:Int32 row
 1260: ldloc.s 8
 1262: ldfld field:Int32 row
 1267: beq.s 1357
 1269: ldarg.0 
 1270: ldfld field:System.Collections.Generic.Dictionary`2[MegaCrit.Sts2.Core.Map.MapCoord,MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint] _mapPointDictionary
 1275: ldloc.s 8
 1277: ldloca.s 9
 1279: callvirt method:System.Collections.Generic.Dictionary`2[MegaCrit.Sts2.Core.Map.MapCoord,MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint].Boolean TryGetValue(MegaCrit.Sts2.Core.Map.MapCoord, MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint ByRef)
 1284: brfalse.s 1301
 1286: ldarg.0 
 1287: ldfld field:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapMarker _marker
 1292: ldloc.s 9
 1294: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapMarker.Void SetMapPoint(MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint)
 1299: br.s 1357
 1301: ldloca.s 10
 1303: ldc.i4.s 55
 1305: ldc.i4.1 
 1306: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 1311: ldloca.s 10
 1313: ldstr str:Last visited coord 
 1318: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 1323: ldloca.s 10
 1325: ldloc.s 8
 1327: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted[MapCoord](MegaCrit.Sts2.Core.Map.MapCoord)
 1332: ldloca.s 10
 1334: ldstr str: not found in map, marker not placed
 1339: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 1344: ldloca.s 10
 1346: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 1351: ldc.i4.2 
 1352: call method:MegaCrit.Sts2.Core.Logging.Log.Void Error(System.String, Int32)
 1357: ldstr str:event:/sfx/ui/map/map_open
 1362: ldc.r4 1
 1367: call method:MegaCrit.Sts2.Core.Commands.SfxCmd.Void Play(System.String, Single)
 1372: call method:MegaCrit.Sts2.Core.Nodes.Screens.ScreenContext.ActiveScreenContext.MegaCrit.Sts2.Core.Nodes.Screens.ScreenContext.ActiveScreenContext get_Instance()
 1377: callvirt method:MegaCrit.Sts2.Core.Nodes.Screens.ScreenContext.ActiveScreenContext.Void Update()
 1382: ldarg.0 
 1383: call method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen.Void EmitSignalOpened()
 1388: ldarg.0 
 1389: ldfld field:System.Collections.Generic.Dictionary`2[MegaCrit.Sts2.Core.Map.MapCoord,MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint] _mapPointDictionary
 1394: callvirt method:System.Collections.Generic.Dictionary`2[MegaCrit.Sts2.Core.Map.MapCoord,MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint].ValueCollection get_Values()
 1399: ldsfld field:System.Func`2[MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint,System.Boolean] <>9__123_0
 1404: dup 
 1405: brtrue.s 1430
 1407: pop 
 1408: ldsfld field:<>c <>9
 1413: ldftn method:MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen+<>c.Boolean <Open>b__123_0(MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint)
 1419: newobj method:System.Func`2[MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint,System.Boolean].Void .ctor(System.Object, IntPtr)
 1424: dup 
 1425: stsfld field:System.Func`2[MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint,System.Boolean] <>9__123_0
 1430: call method:System.Linq.Enumerable.MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint FirstOrDefault[NMapPoint](System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint], System.Func`2[MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapPoint,System.Boolean])
 1435: stloc.1 
 1436: ldloc.1 
 1437: brtrue.s 1447
 1439: ldarg.0 
 1440: ldc.i4.2 
 1441: conv.i8 
 1442: call method:Godot.Control.Void set_FocusMode(FocusModeEnum)
 1447: ldarg.0 
 1448: ret 
