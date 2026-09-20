METHOD Void .ctor()
 0000: ldarg.0 
 0001: newobj method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon].Void .ctor()
 0006: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon] _votes
 0011: ldarg.0 
 0012: newobj method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon].Void .ctor()
 0017: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Nodes.CommonUi.NMultiplayerVoteContainer+VoteIcon] _iconsAnimatingOut
 0022: ldarg.0 
 0023: newobj method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Players.Player].Void .ctor()
 0028: stfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Players.Player] _allPlayers
 0033: ldarg.0 
 0034: call method:Godot.Control.Void .ctor()
 0039: ret 
