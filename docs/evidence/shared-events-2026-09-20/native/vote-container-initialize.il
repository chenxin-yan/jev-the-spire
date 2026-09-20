METHOD Void Initialize(PlayerVotedDelegate, System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Entities.Players.Player])
 0000: ldarg.0 
 0001: ldarg.1 
 0002: stfld field:PlayerVotedDelegate _playerVotedDelegate
 0007: ldarg.0 
 0008: ldfld field:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Players.Player] _allPlayers
 0013: ldarg.2 
 0014: callvirt method:System.Collections.Generic.List`1[MegaCrit.Sts2.Core.Entities.Players.Player].Void AddRange(System.Collections.Generic.IEnumerable`1[MegaCrit.Sts2.Core.Entities.Players.Player])
 0019: ret 
