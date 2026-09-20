METHOD Void RefreshPlayerVotes(Boolean)
 0000: ldarg.0 
 0001: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Players.Player] _allPlayers
 0006: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Players.Player].Int32 get_Count()
 0011: ldc.i4.1 
 0012: bne.un.s 15
 0014: ret 
 0015: ldc.i4.0 
 0016: stloc.0 
 0017: br.s 79
 0019: ldarg.0 
 0020: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon] _votes
 0025: ldloc.0 
 0026: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon].VoteIcon get_Item(Int32)
 0031: stloc.1 
 0032: ldarg.0 
 0033: ldfld field:PlayerVotedDelegate _playerVotedDelegate
 0038: ldloc.1 
 0039: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0044: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+PlayerVotedDelegate.Boolean Invoke(MegaCrit.Sts2.Core.Entities.Players.Player)
 0049: brtrue.s 75
 0051: ldarg.0 
 0052: ldloc.1 
 0053: ldarg.1 
 0054: call method:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer.Void AnimVoteOut(VoteIcon, Boolean)
 0059: ldarg.0 
 0060: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon] _votes
 0065: ldloc.0 
 0066: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon].Void RemoveAt(Int32)
 0071: ldloc.0 
 0072: ldc.i4.1 
 0073: sub 
 0074: stloc.0 
 0075: ldloc.0 
 0076: ldc.i4.1 
 0077: add 
 0078: stloc.0 
 0079: ldloc.0 
 0080: ldarg.0 
 0081: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon] _votes
 0086: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon].Int32 get_Count()
 0091: blt.s 19
 0093: ldarg.0 
 0094: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Players.Player] _allPlayers
 0099: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Players.Player].Enumerator GetEnumerator()
 0104: stloc.2 
 0105: br 359
 0110: newobj method:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+<>c__DisplayClass12_0.Void .ctor()
 0115: stloc.3 
 0116: ldloc.3 
 0117: ldloca.s 2
 0119: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Entities.Players.Player].MegaCrit.Sts2.Core.Entities.Players.Player get_Current()
 0124: stfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0129: ldarg.0 
 0130: ldfld field:PlayerVotedDelegate _playerVotedDelegate
 0135: ldloc.3 
 0136: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0141: callvirt method:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+PlayerVotedDelegate.Boolean Invoke(MegaCrit.Sts2.Core.Entities.Players.Player)
 0146: brfalse 359
 0151: ldarg.0 
 0152: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon] _votes
 0157: ldloc.3 
 0158: ldftn method:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+<>c__DisplayClass12_0.Boolean <RefreshPlayerVotes>b__0(VoteIcon)
 0164: newobj method:System.Predicate`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon].Void .ctor(System.Object, IntPtr)
 0169: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon].Int32 FindIndex(System.Predicate`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon])
 0174: stloc.s 4
 0176: ldloc.s 4
 0178: ldc.i4.0 
 0179: bge 359
 0184: newobj method:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon.Void .ctor()
 0189: dup 
 0190: ldloc.3 
 0191: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0196: stfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0201: dup 
 0202: ldstr str:ui/multiplayer_vote_icon
 0207: call method:MegaCrit.Sts2.Core.Helpers.SceneHelper.Godot.TextureRect Instantiate[TextureRect](System.String)
 0212: stfld field:Godot.TextureRect node
 0217: stloc.s 5
 0219: ldloc.s 5
 0221: ldfld field:Godot.TextureRect node
 0226: ldloc.3 
 0227: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0232: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Models.CharacterModel get_Character()
 0237: callvirt method:MegaCrit.Sts2.Core.Models.CharacterModel.Godot.Texture2D get_IconTexture()
 0242: callvirt method:Godot.TextureRect.Void set_Texture(Godot.Texture2D)
 0247: ldloc.s 5
 0249: ldfld field:Godot.TextureRect node
 0254: ldstr str:Outline
 0259: call method:Godot.NodePath.Godot.NodePath op_Implicit(System.String)
 0264: callvirt method:Godot.Node.Godot.TextureRect GetNode[TextureRect](Godot.NodePath)
 0269: ldloc.3 
 0270: ldfld field:MegaCrit.Sts2.Core.Entities.Players.Player player
 0275: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Models.CharacterModel get_Character()
 0280: callvirt method:MegaCrit.Sts2.Core.Models.CharacterModel.Godot.Texture2D get_IconOutlineTexture()
 0285: callvirt method:Godot.TextureRect.Void set_Texture(Godot.Texture2D)
 0290: ldarg.0 
 0291: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon] _votes
 0296: ldloc.s 5
 0298: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon].Void Add(VoteIcon)
 0303: ldarg.0 
 0304: ldloc.s 5
 0306: ldfld field:Godot.TextureRect node
 0311: call method:MegaCrit.Sts2.Core.Helpers.GodotTreeExtensions.Void AddChildSafely(Godot.Node, Godot.Node)
 0316: ldloc.s 5
 0318: ldfld field:Godot.TextureRect node
 0323: ldloc.s 5
 0325: ldfld field:Godot.TextureRect node
 0330: callvirt method:Godot.Control.Godot.Vector2 get_Size()
 0335: ldc.r4 0.5
 0340: call method:Godot.Vector2.Godot.Vector2 op_Multiply(Godot.Vector2, Single)
 0345: callvirt method:Godot.Control.Void set_PivotOffset(Godot.Vector2)
 0350: ldarg.0 
 0351: ldloc.s 5
 0353: ldarg.1 
 0354: call method:MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer.Void AnimVoteIn(VoteIcon, Boolean)
 0359: ldloca.s 2
 0361: call method:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Entities.Players.Player].Boolean MoveNext()
 0366: brtrue 110
 0371: leave.s 387
 0373: ldloca.s 2
 0375: constrained. type:System.Collections.Generic.List`1+Enumerator[MegaCrit.Sts2.Core.Entities.Players.Player]
 0381: callvirt method:System.IDisposable.Void Dispose()
 0386: endfinally 
 0387: ret 
