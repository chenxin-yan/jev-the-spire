METHOD System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]] CardsSelected()
 0000: ldloca.s 0
 0002: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]].System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]] Create()
 0007: stfld field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]] <>t__builder
 0012: ldloca.s 0
 0014: ldarg.0 
 0015: stfld field:MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NChooseABundleSelectionScreen <>4__this
 0020: ldloca.s 0
 0022: ldc.i4.m1 
 0023: stfld field:Int32 <>1__state
 0028: ldloca.s 0
 0030: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]] <>t__builder
 0035: ldloca.s 0
 0037: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]].Void Start[<CardsSelected>d__26](<CardsSelected>d__26 ByRef)
 0042: ldloca.s 0
 0044: ldflda field:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]] <>t__builder
 0049: call method:System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]].System.Threading.Tasks.Task`1[System.Collections.Generic.IEnumerable`1[System.Collections.Generic.IReadOnlyList`1[MegaCrit.Sts2.Core.Models.CardModel]]] get_Task()
 0054: ret 
