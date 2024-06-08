﻿Procedure getPointList(synoptiqueId, List result.pointList())
  If connect()
    SetDatabaseLong(db,0,synoptiqueId)
    DatabaseQuery(db,"SELECT * FROM Point AS p INNER JOIN Pointlist AS pl ON pl.Point_id = p.id WHERE pl.Synoptique_id = ?")
    While NextDatabaseRow(db)
      AddElement(result())
      With result()
        \id = GetDatabaseLong(db,0)
        \name = GetDatabaseString(db,1)
        \type = GetDatabaseLong(db,2)
        \link = GetDatabaseString(db,3)
        \description = GetDatabaseString(db,4)
        \file = GetDatabaseString(db,5)
        \color = GetDatabaseString(db,6)
        \x = GetDatabaseLong(db,7)
        \y = GetDatabaseLong(db,8)
      EndWith
    Wend
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure updatePointPosition(pointId,pointX,pointY)
  Protected result = #False
  If connect()
    SetDatabaseLong(db,0,pointX)
    SetDatabaseLong(db,1,pointY)
    SetDatabaseLong(db,2,pointId)
    result = DatabaseUpdate(db,"UPDATE Point SET x = ?, y = ? WHERE Id = ?")
  EndIf
  ProcedureReturn result
EndProcedure
; IDE Options = PureBasic 6.10 LTS (Linux - x64)
; CursorPosition = 29
; Folding = -
; EnableXP
; DPIAware