METHOD Void OnRelease()
 0000: ldarg.0 
 0001: ldfld field:Boolean _isUnclickable
 0006: brfalse.s 9
 0008: ret 
 0009: ldarg.0 
 0010: call method:MegaCrit.Sts2.Core.Nodes.GodotExtensions.NClickableControl.Void OnRelease()
 0015: ldarg.0 
 0016: ldarg.0 
 0017: call method:MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteButton.MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption get_Option()
 0022: call method:MegaCrit.Sts2.Core.Nodes.RestSite.NRestSiteButton.System.Threading.Tasks.Task SelectOption(MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption)
 0027: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0032: pop 
 0033: ret 
