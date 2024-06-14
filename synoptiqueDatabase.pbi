Procedure getSynoptiqueList(userId, List result.synoptiqueList())
  If connect()
    SetDatabaseLong(db,0,userId)
    DatabaseQuery(db,"SELECT Id, Image, Title, Slug FROM Synoptique WHERE User_Id = ? AND Main_Synoptique_Id = 0")
    While NextDatabaseRow(db)
      AddElement(result())
      With result()
        \id = GetDatabaseLong(db,0)
        \image = GetDatabaseString(db,1)
        \title = GetDatabaseString(db,2)
        \slug = GetDatabaseString(db,3)
      EndWith
    Wend
    FinishDatabaseQuery(db)
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure getSynoptique(synoptiqueId, *synoptique.synoptiqueList)
  If connect()
    SetDatabaseLong(db,0,synoptiqueId)
    DatabaseQuery(db,"SELECT Id, Image, Title, Slug FROM Synoptique WHERE Id = ?")
    If NextDatabaseRow(db)
      With *synoptique
        \id = GetDatabaseLong(db,0)
        \image = GetDatabaseString(db,1)
        \title = GetDatabaseString(db,2)
        \slug = GetDatabaseString(db,3)
      EndWith
      FinishDatabaseQuery(db)
      ProcedureReturn #True
    EndIf
    FinishDatabaseQuery(db)
    ProcedureReturn #False
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure getSubSynoptique(synoptiqueId, List result.synoptiqueList())
  If connect()
    SetDatabaseLong(db,0,synoptiqueId)
    SetDatabaseLong(db,1,synoptiqueId)
    DatabaseQuery(db,"SELECT Id, Image, Title, Slug FROM Synoptique WHERE Id = ? OR Main_Synoptique_Id = ?")
    While NextDatabaseRow(db)
      AddElement(result())
      With result()
        \id = GetDatabaseLong(db,0)
        \image = GetDatabaseString(db,1)
        \title = GetDatabaseString(db,2)
        \slug = GetDatabaseString(db,3)
      EndWith
    Wend
    FinishDatabaseQuery(db)
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure getPointList(synoptiqueId, List result.pointList())
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

Procedure addSynoptique(*datas.dataSynoptique)
  Protected result = #False
  If connect()
    With *datas
      SetDatabaseLong(db,0,\User_Id)
      SetDatabaseLong(db,1,\Main_Synoptique_Id)
      SetDatabaseString(db,2,\Image$)
      SetDatabaseString(db,3,\Title$)
      SetDatabaseString(db,4,\Slug$)
      result = DatabaseUpdate(db,"INSERT INTO Synoptique (User_Id, Main_Synoptique_Id, Image, Title, Slug) VALUES (?,?,?,?,?)")
      Debug DatabaseError()
      If result
        DatabaseQuery(db,"SELECT LAST_INSERT_ID()")
        If NextDatabaseRow(db)
          result = GetDatabaseLong(db,0)
        EndIf
        FinishDatabaseQuery(db)
      EndIf
    EndWith
  EndIf
  ProcedureReturn result
EndProcedure

Procedure addPoint(*datas.dataPoint)
  Protected result = #False
  If connect()
    With *datas
      Debug \Link
      SetDatabaseString(db,0,\Name$)
      SetDatabaseLong(db,1,\Type)
      SetDatabaseLong(db,2,\Link)
      SetDatabaseString(db,3,\Description$)
      SetDatabaseString(db,4,\File$)
      SetDatabaseString(db,5,\Color$)
      result = DatabaseUpdate(db,"INSERT INTO Point (Name, Type, Link, Description, File, Color, x, y) VALUES (?,?,?,?,?,?,0,0)")
      If result
        DatabaseQuery(db,"SELECT LAST_INSERT_ID()")
        If NextDatabaseRow(db)
          result = GetDatabaseLong(db,0)
        Else
          ProcedureReturn #False
        EndIf
        FinishDatabaseQuery(db)
        SetDatabaseLong(db,0,\Synoptique_Id)
        SetDatabaseLong(db,1,result)
        If Not  DatabaseUpdate(db,"INSERT INTO Pointlist (Synoptique_Id, Point_Id) VALUES (?,?)")
          ProcedureReturn #False
        EndIf
      EndIf
    EndWith
  EndIf
  ProcedureReturn result
EndProcedure
; IDE Options = PureBasic 6.10 LTS (Linux - x64)
; CursorPosition = 109
; FirstLine = 4
; Folding = w+
; EnableXP
; DPIAware