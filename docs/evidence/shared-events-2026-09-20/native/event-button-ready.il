METHOD Void _Ready()
 0000: ldarg.0 
 0001: callvirt method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void ConnectSignals()
 0006: ldarg.0 
 0007: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Models.EventModel get_Event()
 0012: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Localization.DynamicVars.DynamicVarSet get_DynamicVars()
 0017: ldarg.0 
 0018: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Events.EventOption get_Option()
 0023: callvirt method:MegaCrit.Sts2.Core.Events.EventOption.MegaCrit.Sts2.Core.Localization.LocString get_Description()
 0028: callvirt method:MegaCrit.Sts2.Core.Localization.DynamicVars.DynamicVarSet.Void AddTo(MegaCrit.Sts2.Core.Localization.LocString)
 0033: ldarg.0 
 0034: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Models.EventModel get_Event()
 0039: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Localization.DynamicVars.DynamicVarSet get_DynamicVars()
 0044: ldarg.0 
 0045: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Events.EventOption get_Option()
 0050: callvirt method:MegaCrit.Sts2.Core.Events.EventOption.MegaCrit.Sts2.Core.Localization.LocString get_Title()
 0055: callvirt method:MegaCrit.Sts2.Core.Localization.DynamicVars.DynamicVarSet.Void AddTo(MegaCrit.Sts2.Core.Localization.LocString)
 0060: ldarg.0 
 0061: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Events.EventOption get_Option()
 0066: callvirt method:MegaCrit.Sts2.Core.Events.EventOption.MegaCrit.Sts2.Core.Localization.LocString get_Title()
 0071: callvirt method:MegaCrit.Sts2.Core.Localization.LocString.System.String GetFormattedText()
 0076: stloc.0 
 0077: ldarg.0 
 0078: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Events.EventOption get_Option()
 0083: callvirt method:MegaCrit.Sts2.Core.Events.EventOption.MegaCrit.Sts2.Core.Localization.LocString get_Description()
 0088: callvirt method:MegaCrit.Sts2.Core.Localization.LocString.System.String GetFormattedText()
 0093: stloc.1 
 0094: ldarg.0 
 0095: ldarg.0 
 0096: ldstr str:%Text
 0101: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0106: call method:Godot.Node.MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel GetNode[MegaRichTextLabel](Godot.NodePath)
 0111: stfld field:MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel _label
 0116: ldloc.0 
 0117: call method:System.String.Boolean IsNullOrEmpty(System.String)
 0122: brfalse.s 141
 0124: ldarg.0 
 0125: ldfld field:MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel _label
 0130: ldloc.1 
 0131: callvirt method:MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel.Void set_Text(System.String)
 0136: br 275
 0141: ldarg.0 
 0142: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Events.EventOption get_Option()
 0147: callvirt method:MegaCrit.Sts2.Core.Events.EventOption.Boolean get_IsLocked()
 0152: brtrue.s 161
 0154: ldstr str:gold
 0159: br.s 166
 0161: ldstr str:red
 0166: stloc.2 
 0167: ldarg.0 
 0168: ldfld field:MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel _label
 0173: ldloca.s 3
 0175: ldc.i4.s 13
 0177: ldc.i4.4 
 0178: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void .ctor(Int32, Int32)
 0183: ldloca.s 3
 0185: ldstr str:[
 0190: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0195: ldloca.s 3
 0197: ldloc.2 
 0198: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted(System.String)
 0203: ldloca.s 3
 0205: ldstr str:][b]
 0210: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0215: ldloca.s 3
 0217: ldloc.0 
 0218: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted(System.String)
 0223: ldloca.s 3
 0225: ldstr str:[/b][/
 0230: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0235: ldloca.s 3
 0237: ldloc.2 
 0238: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted(System.String)
 0243: ldloca.s 3
 0245: ldstr str:]

 0250: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendLiteral(System.String)
 0255: ldloca.s 3
 0257: ldloc.1 
 0258: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.Void AppendFormatted(System.String)
 0263: ldloca.s 3
 0265: call method:System.Runtime.CompilerServices.DefaultInterpolatedStringHandler.System.String ToStringAndClear()
 0270: callvirt method:MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel.Void set_Text(System.String)
 0275: ldarg.0 
 0276: ldarg.0 
 0277: ldstr str:Image
 0282: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0287: call method:Godot.Node.Godot.NinePatchRect GetNode[NinePatchRect](Godot.NodePath)
 0292: stfld field:Godot.NinePatchRect _image
 0297: ldarg.0 
 0298: ldfld field:Godot.NinePatchRect _image
 0303: ldarg.0 
 0304: ldfld field:Godot.Color _buttonColor
 0309: callvirt method:Godot.CanvasItem.Void set_Modulate(Godot.Color)
 0314: ldarg.0 
 0315: ldarg.0 
 0316: ldfld field:Godot.NinePatchRect _image
 0321: callvirt method:Godot.CanvasItem.Godot.Material get_Material()
 0326: castclass type:Godot.ShaderMaterial
 0331: stfld field:Godot.ShaderMaterial _hsv
 0336: ldarg.0 
 0337: ldarg.0 
 0338: ldstr str:Outline
 0343: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0348: call method:Godot.Node.Godot.NinePatchRect GetNode[NinePatchRect](Godot.NodePath)
 0353: stfld field:Godot.NinePatchRect _outline
 0358: ldarg.0 
 0359: ldarg.0 
 0360: ldstr str:RedFlash
 0365: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0370: call method:Godot.Node.Godot.NinePatchRect GetNode[NinePatchRect](Godot.NodePath)
 0375: stfld field:Godot.NinePatchRect _killGlow
 0380: ldarg.0 
 0381: ldarg.0 
 0382: ldstr str:BlueFlash
 0387: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0392: call method:Godot.Node.Godot.NinePatchRect GetNode[NinePatchRect](Godot.NodePath)
 0397: stfld field:Godot.NinePatchRect _confirmFlash
 0402: ldarg.0 
 0403: ldarg.0 
 0404: ldstr str:PlayerVoteContainer
 0409: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0414: call method:Godot.Node.MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer GetNode[NMultiplayerVoteContainer](Godot.NodePath)
 0419: stfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer _playerVoteContainer
 0424: ldarg.0 
 0425: ldfld field:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer _playerVoteContainer
 0430: ldarg.0 
 0431: ldftn method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.Boolean ShouldDisplayPlayerVote(MegaCrit.Sts2.Core.Entities.Players.Player)
 0437: newobj method:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+PlayerVotedDelegate.Void .ctor(System.Object, IntPtr)
 0442: ldarg.0 
 0443: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Models.EventModel get_Event()
 0448: callvirt method:MegaCrit.Sts2.Core.Models.EventModel.MegaCrit.Sts2.Core.Entities.Players.Player get_Owner()
 0453: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0458: callvirt method:MegaCrit.Sts2.Core.Runs.IPlayerCollection.System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player] get_Players()
 0463: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer.Void Initialize(PlayerVotedDelegate, System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player])
 0468: ldarg.0 
 0469: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Models.EventModel get_Event()
 0474: isinst type:MegaCrit.Sts2.Core.Models.AncientEventModel
 0479: brfalse.s 581
 0481: ldarg.0 
 0482: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Events.EventOption get_Option()
 0487: callvirt method:MegaCrit.Sts2.Core.Events.EventOption.MegaCrit.Sts2.Core.Models.RelicModel get_Relic()
 0492: brfalse.s 581
 0494: ldarg.0 
 0495: ldstr str:%RelicIcon
 0500: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0505: call method:Godot.Node.Godot.TextureRect GetNode[TextureRect](Godot.NodePath)
 0510: stloc.s 4
 0512: ldloc.s 4
 0514: ldarg.0 
 0515: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Events.EventOption get_Option()
 0520: callvirt method:MegaCrit.Sts2.Core.Events.EventOption.MegaCrit.Sts2.Core.Models.RelicModel get_Relic()
 0525: callvirt method:MegaCrit.Sts2.Core.Models.RelicModel.Godot.Texture2D get_Icon()
 0530: callvirt method:Godot.TextureRect.Void SetTexture(Godot.Texture2D)
 0535: ldloc.s 4
 0537: ldstr str:%Outline
 0542: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0547: callvirt method:Godot.Node.Godot.TextureRect GetNode[TextureRect](Godot.NodePath)
 0552: ldarg.0 
 0553: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Events.EventOption get_Option()
 0558: callvirt method:MegaCrit.Sts2.Core.Events.EventOption.MegaCrit.Sts2.Core.Models.RelicModel get_Relic()
 0563: callvirt method:MegaCrit.Sts2.Core.Models.RelicModel.Godot.Texture2D get_IconOutline()
 0568: callvirt method:Godot.TextureRect.Void SetTexture(Godot.Texture2D)
 0573: ldloc.s 4
 0575: ldc.i4.1 
 0576: callvirt method:Godot.CanvasItem.Void set_Visible(Boolean)
 0581: ldarg.0 
 0582: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.MegaCrit.Sts2.Core.Events.EventOption get_Option()
 0587: callvirt method:MegaCrit.Sts2.Core.Events.EventOption.Boolean get_IsLocked()
 0592: brfalse.s 601
 0594: ldarg.0 
 0595: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.Void SetVisuallyLocked()
 0600: ret 
 0601: ldarg.0 
 0602: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.Boolean WillKillPlayer()
 0607: brfalse.s 615
 0609: ldarg.0 
 0610: call method:MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton.Void ShowPersistentKillGlow()
 0615: ret 
