METHOD Void ActionQueueChanged()
 0000: ldarg.0 
 0001: call method:MegaCrit.Sts2.Core.GameActions.ActionExecutor.Boolean get_IsRunning()
 0006: brtrue.s 37
 0008: ldarg.0 
 0009: ldfld field:MegaCrit.Sts2.Core.Logging.Logger _logger
 0014: ldstr str:Action queue changed, beginning ExecuteActions
 0019: ldc.i4.1 
 0020: callvirt method:MegaCrit.Sts2.Core.Logging.Logger.Void Debug(System.String, Int32)
 0025: ldarg.0 
 0026: call method:MegaCrit.Sts2.Core.GameActions.ActionExecutor.System.Threading.Tasks.Task ExecuteActions()
 0031: call method:MegaCrit.Sts2.Core.Helpers.TaskHelper.System.Threading.Tasks.Task RunSafely(System.Threading.Tasks.Task)
 0036: pop 
 0037: ret 
