METHOD Boolean NonCombatOfferIdentity(MegaCrit.Sts2.Core.Rewards.RewardsSet, System.Object, System.Object, System.Object)
 0000: ldarg.0 
 0001: callvirt method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Rooms.AbstractRoom get_Room()
 0006: ldarg.1 
 0007: bne.un.s 33
 0009: ldarg.0 
 0010: callvirt method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0015: ldarg.2 
 0016: bne.un.s 33
 0018: ldarg.0 
 0019: callvirt method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0024: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0029: ldarg.3 
 0030: ceq 
 0032: ret 
 0033: ldc.i4.0 
 0034: ret 
METHOD Void RewardOfferPrefix(MegaCrit.Sts2.Core.Rewards.RewardsSet, RewardCapture ByRef)
 0000: ldsfld field:STS2_MCP.SelectionOwnership TreasureScopes
 0005: callvirt method:STS2_MCP.SelectionOwnership.System.Object get_CurrentOwner()
 0010: isinst type:STS2_MCP.McpMod+TreasureScope
 0015: stloc.0 
 0016: ldloc.0 
 0017: brfalse 189
 0022: ldloc.0 
 0023: callvirt method:STS2_MCP.McpMod+TreasureScope.STS2_MCP.TreasureOperation get_Operation()
 0028: ldsfld field:STS2_MCP.TreasureOperation _treasureOperation
 0033: bne.un 189
 0038: ldloc.0 
 0039: callvirt method:STS2_MCP.McpMod+TreasureScope.STS2_MCP.TreasureOperation get_Operation()
 0044: stloc.s 4
 0046: ldloc.s 4
 0048: call method:STS2_MCP.McpMod.Void RequireTreasureIdentity(STS2_MCP.TreasureOperation)
 0053: ldloc.0 
 0054: callvirt method:STS2_MCP.McpMod+TreasureScope.System.Object get_Set()
 0059: brtrue.s 98
 0061: ldloc.0 
 0062: callvirt method:STS2_MCP.McpMod+TreasureScope.System.Object get_Screen()
 0067: brtrue.s 98
 0069: ldarg.0 
 0070: ldloc.s 4
 0072: ldfld field:System.Object Room
 0077: ldloc.s 4
 0079: ldfld field:System.Object Player
 0084: ldloc.s 4
 0086: ldfld field:System.Object Run
 0091: call method:STS2_MCP.McpMod.Boolean NonCombatOfferIdentity(MegaCrit.Sts2.Core.Rewards.RewardsSet, System.Object, System.Object, System.Object)
 0096: brtrue.s 109
 0098: ldstr str:treasure_offer_identity_unverified
 0103: newobj method:System.NotSupportedException.Void .ctor(System.String)
 0108: throw 
 0109: ldloc.s 4
 0111: ldarg.0 
 0112: callvirt method:STS2_MCP.TreasureOperation.Void BeginOffer(System.Object)
 0117: leave.s 134
 0119: pop 
 0120: ldloc.s 4
 0122: ldstr str:treasure_offer_identity_unverified
 0127: callvirt method:STS2_MCP.TreasureOperation.Void Fail(System.String)
 0132: leave.s 134
 0134: ldarg.1 
 0135: ldnull 
 0136: ldc.i4.1 
 0137: ldarg.0 
 0138: ldnull 
 0139: ldsfld field:STS2_MCP.SelectionOwnership TreasureScopes
 0144: ldloc.s 4
 0146: ldc.i4.0 
 0147: ldc.i4.0 
 0148: ldc.i4.0 
 0149: ldarg.0 
 0150: ldnull 
 0151: newobj method:STS2_MCP.McpMod+TreasureScope.Void .ctor(STS2_MCP.TreasureOperation, Boolean, Boolean, Boolean, System.Object, System.Object)
 0156: callvirt method:STS2_MCP.SelectionOwnership.System.IDisposable Enter(System.Object)
 0161: ldsfld field:STS2_MCP.SelectionOwnership SelectionOwners
 0166: ldloc.s 4
 0168: ldfld field:System.Object Owner
 0173: callvirt method:STS2_MCP.SelectionOwnership.System.IDisposable Enter(System.Object)
 0178: ldnull 
 0179: ldnull 
 0180: ldloc.s 4
 0182: newobj method:STS2_MCP.McpMod+RewardCapture.Void .ctor(STS2_MCP.CombatExitOperation, Int32, System.Object, System.Object, System.IDisposable, System.IDisposable, STS2_MCP.EventOperation, System.IDisposable, STS2_MCP.TreasureOperation)
 0187: stind.ref 
 0188: ret 
 0189: ldsfld field:STS2_MCP.SelectionOwnership EventScopes
 0194: callvirt method:STS2_MCP.SelectionOwnership.System.Object get_CurrentOwner()
 0199: isinst type:STS2_MCP.McpMod+EventScope
 0204: stloc.1 
 0205: ldloc.1 
 0206: brfalse 406
 0211: ldloc.1 
 0212: callvirt method:STS2_MCP.McpMod+EventScope.STS2_MCP.EventOperation get_Operation()
 0217: ldsfld field:STS2_MCP.EventOperation _eventOperation
 0222: bne.un 406
 0227: ldloc.1 
 0228: callvirt method:STS2_MCP.McpMod+EventScope.STS2_MCP.EventOperation get_Operation()
 0233: stloc.s 5
 0235: ldloc.s 5
 0237: ldfld field:STS2_MCP.EventEntry Entry
 0242: call method:STS2_MCP.McpMod.Void RequireEventIdentity(STS2_MCP.EventEntry)
 0247: ldloc.1 
 0248: callvirt method:STS2_MCP.McpMod+EventScope.System.Object get_Screen()
 0253: brtrue.s 307
 0255: ldloc.1 
 0256: callvirt method:STS2_MCP.McpMod+EventScope.System.Object get_Set()
 0261: brtrue.s 307
 0263: ldarg.0 
 0264: ldloc.s 5
 0266: ldfld field:STS2_MCP.EventEntry Entry
 0271: ldfld field:System.Object Room
 0276: ldloc.s 5
 0278: ldfld field:STS2_MCP.EventEntry Entry
 0283: ldfld field:System.Object Player
 0288: ldloc.s 5
 0290: ldfld field:STS2_MCP.EventEntry Entry
 0295: ldfld field:System.Object Run
 0300: call method:STS2_MCP.McpMod.Boolean NonCombatOfferIdentity(MegaCrit.Sts2.Core.Rewards.RewardsSet, System.Object, System.Object, System.Object)
 0305: brtrue.s 318
 0307: ldstr str:event_offer_identity_unverified
 0312: newobj method:System.NotSupportedException.Void .ctor(System.String)
 0317: throw 
 0318: ldloc.s 5
 0320: ldarg.0 
 0321: callvirt method:STS2_MCP.EventOperation.Void BeginOffer(System.Object)
 0326: leave.s 343
 0328: pop 
 0329: ldloc.s 5
 0331: ldstr str:event_offer_identity_unverified
 0336: callvirt method:STS2_MCP.EventOperation.Void Fail(System.String)
 0341: leave.s 343
 0343: ldarg.1 
 0344: ldnull 
 0345: ldc.i4.1 
 0346: ldarg.0 
 0347: ldnull 
 0348: ldsfld field:STS2_MCP.SelectionOwnership RewardScopes
 0353: ldnull 
 0354: callvirt method:STS2_MCP.SelectionOwnership.System.IDisposable Enter(System.Object)
 0359: ldsfld field:STS2_MCP.SelectionOwnership SelectionOwners
 0364: ldloc.s 5
 0366: ldfld field:System.Object Owner
 0371: callvirt method:STS2_MCP.SelectionOwnership.System.IDisposable Enter(System.Object)
 0376: ldloc.s 5
 0378: ldsfld field:STS2_MCP.SelectionOwnership EventScopes
 0383: ldloc.s 5
 0385: ldarg.0 
 0386: ldnull 
 0387: ldnull 
 0388: newobj method:STS2_MCP.McpMod+EventScope.Void .ctor(STS2_MCP.EventOperation, System.Object, System.Object, System.Object)
 0393: callvirt method:STS2_MCP.SelectionOwnership.System.IDisposable Enter(System.Object)
 0398: ldnull 
 0399: newobj method:STS2_MCP.McpMod+RewardCapture.Void .ctor(STS2_MCP.CombatExitOperation, Int32, System.Object, System.Object, System.IDisposable, System.IDisposable, STS2_MCP.EventOperation, System.IDisposable, STS2_MCP.TreasureOperation)
 0404: stind.ref 
 0405: ret 
 0406: ldsfld field:STS2_MCP.SelectionOwnership RewardScopes
 0411: callvirt method:STS2_MCP.SelectionOwnership.System.Object get_CurrentOwner()
 0416: isinst type:STS2_MCP.McpMod+RewardScope
 0421: stloc.2 
 0422: ldloc.2 
 0423: brtrue.s 428
 0425: ldnull 
 0426: br.s 434
 0428: ldloc.2 
 0429: call method:STS2_MCP.McpMod+RewardScope.STS2_MCP.CombatExitOperation get_Operation()
 0434: stloc.3 
 0435: ldloc.3 
 0436: brfalse 604
 0441: ldloc.3 
 0442: ldsfld field:STS2_MCP.CombatExitOperation _combatExit
 0447: bne.un 604
 0452: ldloc.3 
 0453: ldfld field:Boolean Closed
 0458: brtrue 604
 0463: ldloc.2 
 0464: callvirt method:STS2_MCP.McpMod+RewardScope.System.Object get_Screen()
 0469: brfalse.s 486
 0471: ldloc.3 
 0472: ldstr str:nested_rewards_set_unverified
 0477: callvirt method:STS2_MCP.CombatExitOperation.Void Fail(System.String)
 0482: ldnull 
 0483: stloc.3 
 0484: br.s 606
 0486: call method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunManager get_Instance()
 0491: callvirt method:MegaCrit.Sts2.Core.Runs.RunManager.MegaCrit.Sts2.Core.Runs.RunState DebugOnlyGetState()
 0496: dup 
 0497: brtrue.s 503
 0499: pop 
 0500: ldnull 
 0501: br.s 508
 0503: call method:MegaCrit.Sts2.Core.Runs.RunState.MegaCrit.Sts2.Core.Rooms.AbstractRoom get_CurrentRoom()
 0508: ldloc.3 
 0509: ldfld field:System.Object Room
 0514: bne.un.s 563
 0516: ldarg.0 
 0517: callvirt method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Rooms.AbstractRoom get_Room()
 0522: ldloc.3 
 0523: ldfld field:System.Object Room
 0528: bne.un.s 563
 0530: ldarg.0 
 0531: callvirt method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0536: ldloc.3 
 0537: ldfld field:System.Object Player
 0542: bne.un.s 563
 0544: ldarg.0 
 0545: callvirt method:MegaCrit.Sts2.Core.Rewards.RewardsSet.MegaCrit.Sts2.Core.Entities.Players.Player get_Player()
 0550: callvirt method:MegaCrit.Sts2.Core.Entities.Players.Player.MegaCrit.Sts2.Core.Runs.IRunState get_RunState()
 0555: ldloc.3 
 0556: ldfld field:System.Object Run
 0561: beq.s 578
 0563: ldloc.3 
 0564: ldstr str:rewards_set_identity_mismatch
 0569: callvirt method:STS2_MCP.CombatExitOperation.Void Fail(System.String)
 0574: ldnull 
 0575: stloc.3 
 0576: br.s 606
 0578: nop 
 0579: ldloc.3 
 0580: ldarg.0 
 0581: callvirt method:STS2_MCP.CombatExitOperation.Void BeginSet(System.Object)
 0586: leave.s 606
 0588: pop 
 0589: ldloc.3 
 0590: ldstr str:rewards_set_reentry
 0595: callvirt method:STS2_MCP.CombatExitOperation.Void Fail(System.String)
 0600: ldnull 
 0601: stloc.3 
 0602: leave.s 606
 0604: ldnull 
 0605: stloc.3 
 0606: ldarg.1 
 0607: ldloc.3 
 0608: ldc.i4.1 
 0609: ldarg.0 
 0610: ldnull 
 0611: ldc.i4.0 
 0612: call method:STS2_MCP.McpMod.RewardCapture BeginRewardCapture(STS2_MCP.CombatExitOperation, Int32, System.Object, System.Object, Boolean)
 0617: stind.ref 
 0618: ret 
