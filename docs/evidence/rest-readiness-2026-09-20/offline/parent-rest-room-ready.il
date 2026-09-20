METHOD Void _Ready()
 0000: ldarg.0 
 0001: ldarg.0 
 0002: ldstr str:%Header
 0007: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0012: call method:Godot.Node.MegaCrit.Sts2.addons.mega_text.MegaLabel GetNode[MegaLabel](Godot.NodePath)
 0017: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void set_Header(MegaCrit.Sts2.addons.mega_text.MegaLabel)
 0022: ldarg.0 
 0023: ldarg.0 
 0024: ldstr str:%Description
 0029: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0034: call method:Godot.Node.MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel GetNode[MegaRichTextLabel](Godot.NodePath)
 0039: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void set_Description(MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel)
 0044: ldarg.0 
 0045: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel get_Description()
 0050: call method:Godot.Colors.Godot.Color get_Transparent()
 0055: callvirt method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0060: ldarg.0 
 0061: ldarg.0 
 0062: ldstr str:%ChoicesContainer
 0067: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0072: call method:Godot.Node.Godot.Control GetNode[Control](Godot.NodePath)
 0077: stfld field:Godot.Control _choicesContainer
 0082: ldarg.0 
 0083: ldarg.0 
 0084: ldstr str:%ChoicesScreen
 0089: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0094: call method:Godot.Node.Godot.Control GetNode[Control](Godot.NodePath)
 0099: stfld field:Godot.Control _choicesScreen
 0104: ldarg.0 
 0105: ldarg.0 
 0106: ldstr str:%ProceedButton
 0111: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0116: call method:Godot.Node.MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton GetNode[NProceedButton](Godot.NodePath)
 0121: stfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0126: ldarg.0 
 0127: ldarg.0 
 0128: ldstr str:BgContainer
 0133: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0138: call method:Godot.Node.Godot.Control GetNode[Control](Godot.NodePath)
 0143: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void set_BgContainer(Godot.Control)
 0148: ldarg.0 
 0149: ldfld field:System.Collections.Generic.List`1[Godot.Control] _characterContainers
 0154: ldarg.0 
 0155: ldstr str:BgContainer/Character_1
 0160: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0165: call method:Godot.Node.Godot.Control GetNode[Control](Godot.NodePath)
 0170: callvirt method:System.Collections.Generic.List`1[Godot.Control].Void Add(Godot.Control)
 0175: ldarg.0 
 0176: ldfld field:System.Collections.Generic.List`1[Godot.Control] _characterContainers
 0181: ldarg.0 
 0182: ldstr str:BgContainer/Character_2
 0187: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0192: call method:Godot.Node.Godot.Control GetNode[Control](Godot.NodePath)
 0197: callvirt method:System.Collections.Generic.List`1[Godot.Control].Void Add(Godot.Control)
 0202: ldarg.0 
 0203: ldfld field:System.Collections.Generic.List`1[Godot.Control] _characterContainers
 0208: ldarg.0 
 0209: ldstr str:BgContainer/Character_3
 0214: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0219: call method:Godot.Node.Godot.Control GetNode[Control](Godot.NodePath)
 0224: callvirt method:System.Collections.Generic.List`1[Godot.Control].Void Add(Godot.Control)
 0229: ldarg.0 
 0230: ldfld field:System.Collections.Generic.List`1[Godot.Control] _characterContainers
 0235: ldarg.0 
 0236: ldstr str:BgContainer/Character_4
 0241: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0246: call method:Godot.Node.Godot.Control GetNode[Control](Godot.NodePath)
 0251: callvirt method:System.Collections.Generic.List`1[Godot.Control].Void Add(Godot.Control)
 0256: ldarg.0 
 0257: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0262: callvirt method:MegaCrit.Sts2.Core.Runs.IRunState.MegaCrit.Sts2.Core.Models.ActModel get_Act()
 0267: callvirt method:MegaCrit.Sts2.Core.Models.ActModel.Godot.Control CreateRestSiteBackground()
 0272: stloc.0 
 0273: ldarg.0 
 0274: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Godot.Control get_BgContainer()
 0279: ldloc.0 
 0280: call method:MegaCrit.Sts2.Core.Helpers.GodotTreeExtensions.Void AddChildSafely(Godot.Node, Godot.Node)
 0285: ldarg.0 
 0286: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Godot.Control get_BgContainer()
 0291: ldloc.0 
 0292: ldc.i4.0 
 0293: call method:MegaCrit.Sts2.Core.Helpers.GodotTreeExtensions.Void MoveChildSafely(Godot.Node, Godot.Node, Int32)
 0298: ldarg.0 
 0299: ldloc.0 
 0300: ldstr str:%RestSiteLighting
 0305: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0310: callvirt method:Godot.Node.Godot.Control GetNode[Control](Godot.NodePath)
 0315: stfld field:Godot.Control _restSiteLighting
 0320: ldarg.0 
 0321: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.MegaCrit.Sts2.addons.mega_text.MegaLabel get_Header()
 0326: ldstr str:rest_site_ui
 0331: ldstr str:PROMPT
 0336: newobj method:MegaCrit.Sts2.Core.Localization.LocString.Void .ctor(System.String, System.String)
 0341: call method:MegaCrit.Sts2.Core.Localization.LocString.System.String GetFormattedText()
 0346: callvirt method:MegaCrit.Sts2.addons.mega_text.MegaLabel.Void SetTextAutoSize(System.String)
 0351: ldarg.0 
 0352: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0357: ldsfld field:Godot.StringName Released
 0362: ldarg.0 
 0363: ldftn method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void OnProceedButtonReleased(MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton)
 0369: newobj method:System.Action`1[MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton].Void .ctor(System.Object, IntPtr)
 0374: call method:Godot.Callable.Godot.Callable From[NButton](System.Action`1[MegaCrit.Sts2.Core.Nodes.GodotExtensions.NButton])
 0379: ldc.i4.0 
 0380: callvirt method:Godot.GodotObject.Godot.Error Connect(Godot.StringName, Godot.Callable, UInt32)
 0385: pop 
 0386: ldarg.0 
 0387: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0392: call method:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton.MegaCrit.Sts2.Core.Localization.LocString get_ProceedLoc()
 0397: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton.Void UpdateText(MegaCrit.Sts2.Core.Localization.LocString)
 0402: ldsfld field:Boolean _isDebugUiVisible
 0407: brfalse.s 425
 0409: ldarg.0 
 0410: ldfld field:Godot.Control _choicesScreen
 0415: call method:Godot.Colors.Godot.Color get_Transparent()
 0420: callvirt method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0425: call method:MegaCrit.Sts2.Core.Nodes.NGame.MegaCrit.Sts2.Core.Nodes.NGame get_Instance()
 0430: ldarg.0 
 0431: callvirt method:MegaCrit.Sts2.Core.Nodes.NGame.Void SetScreenShakeTarget(Godot.Control)
 0436: ldarg.0 
 0437: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NProceedButton _proceedButton
 0442: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void Disable()
 0447: ldc.i4.0 
 0448: stloc.1 
 0449: br.s 544
 0451: ldarg.0 
 0452: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0457: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0462: ldloc.1 
 0463: callvirt method:System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player].MegaCrit.Sts2.Core.Entities.Players.Player get_Item(Int32)
 0468: ldloc.1 
 0469: call method:MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteCharacter.MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteCharacter Create(MegaCrit.Sts2.Core.Entities.Players.Player, Int32)
 0474: stloc.2 
 0475: ldarg.0 
 0476: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteCharacter] characterAnims
 0481: ldloc.2 
 0482: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteCharacter].Void Add(MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteCharacter)
 0487: ldarg.0 
 0488: ldfld field:System.Collections.Generic.List`1[Godot.Control] _characterContainers
 0493: ldloc.1 
 0494: callvirt method:System.Collections.Generic.List`1[Godot.Control].Godot.Control get_Item(Int32)
 0499: ldloc.2 
 0500: call method:MegaCrit.Sts2.Core.Helpers.GodotTreeExtensions.Void AddChildSafely(Godot.Node, Godot.Node)
 0505: ldloc.2 
 0506: call method:Godot.Vector2.Godot.Vector2 get_Zero()
 0511: callvirt method:Godot.Node2D.Void set_Position(Godot.Vector2)
 0516: ldloc.1 
 0517: ldc.i4.2 
 0518: rem 
 0519: ldc.i4.1 
 0520: bne.un.s 528
 0522: ldloc.2 
 0523: callvirt method:MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteCharacter.Void FlipX()
 0528: ldarg.0 
 0529: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteCharacter] get_Characters()
 0534: ldloc.2 
 0535: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteCharacter].Void Add(MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteCharacter)
 0540: ldloc.1 
 0541: ldc.i4.1 
 0542: add 
 0543: stloc.1 
 0544: ldloc.1 
 0545: ldarg.0 
 0546: ldfld field:MegaCrit.Sts2.Core.Runs.IRunState _runState
 0551: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0556: callvirt method:System.Collections.Generic.IReadOnlyCollection`1[MegaCrit.Sts2.Core.Entities.Players.Player].Int32 get_Count()
 0561: blt.s 451
 0563: ldarg.0 
 0564: ldarg.0 
 0565: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel get_Description()
 0570: callvirt method:Godot.Control.Godot.Vector2 get_Position()
 0575: ldfld field:Single Y
 0580: stfld field:Single _originalDescriptionYPos
 0585: ldarg.0 
 0586: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void UpdateRestSiteOptions()
 0591: ldarg.0 
 0592: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.System.Threading.Tasks.Task ShowFtueIfNeeded()
 0597: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0602: pop 
 0603: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0608: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer get_RestSiteSynchronizer()
 0613: ldarg.0 
 0614: ldftn method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void OnPlayerChangedHoveredRestSiteOption(UInt64)
 0620: newobj method:System.Action`1[System.UInt64].Void .ctor(System.Object, IntPtr)
 0625: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer.Void add_PlayerHoverChanged(System.Action`1[System.UInt64])
 0630: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0635: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer get_RestSiteSynchronizer()
 0640: ldarg.0 
 0641: ldftn method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void OnBeforePlayerSelectedRestSiteOption(MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption, UInt64)
 0647: newobj method:System.Action`2[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption,System.UInt64].Void .ctor(System.Object, IntPtr)
 0652: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer.Void add_BeforePlayerOptionChosen(System.Action`2[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption,System.UInt64])
 0657: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0662: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer get_RestSiteSynchronizer()
 0667: ldarg.0 
 0668: ldftn method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.Void OnAfterPlayerSelectedRestSiteOption(MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption, Boolean, UInt64)
 0674: newobj method:System.Action`3[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption,System.Boolean,System.UInt64].Void .ctor(System.Object, IntPtr)
 0679: callvirt method:MegaCrit.Sts2.Core.Multiplayer.Game.RestSiteSynchronizer.Void add_AfterPlayerOptionChosen(System.Action`3[MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption,System.Boolean,System.UInt64])
 0684: ret 
