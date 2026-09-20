METHOD System.Threading.Tasks.Task AfterSelectingOptionAsync(MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption)
 0000: ldloca.s 0
 0002: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.System.Runtime.CompilerServices.AsyncTaskMethodBuilder Create()
 0007: stfld field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0012: ldloca.s 0
 0014: ldarg.0 
 0015: stfld field:MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom <>4__this
 0020: ldloca.s 0
 0022: ldarg.1 
 0023: stfld field:MegaCrit.Sts2.Core.Entities.RestSite.RestSiteOption option
 0028: ldloca.s 0
 0030: ldc.i4.m1 
 0031: stfld field:Int32 <>1__state
 0036: ldloca.s 0
 0038: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0043: ldloca.s 0
 0045: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.Void Start[<AfterSelectingOptionAsync>d__60](<AfterSelectingOptionAsync>d__60 ByRef)
 0050: ldloca.s 0
 0052: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder <>t__builder
 0057: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder.System.Threading.Tasks.Task get_Task()
 0062: ret 
