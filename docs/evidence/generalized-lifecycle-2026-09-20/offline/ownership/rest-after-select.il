METHOD Void AfterSelectingOption(MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption)
 0000: ldarg.0 
 0001: ldarg.1 
 0002: call method:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom.System.Threading.Tasks.Task AfterSelectingOptionAsync(MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption)
 0007: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0012: pop 
 0013: ret 
