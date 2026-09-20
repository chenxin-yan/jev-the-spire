METHOD Void .ctor()
 0000: ldarg.0 
 0001: ldc.r4 -1
 0006: stfld field:Single _ignoreDragThreshold
 0011: ldarg.0 
 0012: ldc.i4.1 
 0013: stfld field:Boolean _isEnabled
 0018: ldarg.0 
 0019: call method:Godot.Control.Void .ctor()
 0024: ret 
