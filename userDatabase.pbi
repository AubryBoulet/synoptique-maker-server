Procedure addUser(mail$, password$)
  Protected hashedPassword$, result
  If connect()
    hashedPassword$ = CreatePasswordHash(password$)
    SetDatabaseString(db,0,mail$)
    SetDatabaseString(db,1,hashedPassword$)
    ProcedureReturn DatabaseUpdate(db,"INSERT INTO User (Mail, Password,Status) VALUES (?,?,0)")
  EndIf
EndProcedure

Procedure valideUserAccount(mail$, code$)
  If connect()
    SetDatabaseString(db,0,mail$)
    SetDatabaseString(db,1,code$)
    DatabaseQuery(db,"SELECT * FROM User WHERE Mail=? AND Validation=?")
    If NextDatabaseRow(db)
      FinishDatabaseQuery(db)
      SetDatabaseString(db,0,mail$)
      ProcedureReturn DatabaseUpdate(db,"UPDATE User SET Status=1 WHERE Mail=?")
    EndIf
    FinishDatabaseQuery(db)
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure verifyUser(mail$, password$)
  Protected result = #False
  If connect()
    SetDatabaseString(db,0,mail$)
    DatabaseQuery(db,"SELECT * FROM User WHERE Mail=?")
    If NextDatabaseRow(db)
      If VerifyPasswordHash(password$,GetDatabaseString(db,2))
        If GetDatabaseLong(db,3)
          result = 1
        Else
          result = 2
        EndIf
      EndIf
    EndIf
    FinishDatabaseQuery(db)
  EndIf
  ProcedureReturn result
EndProcedure

Procedure getUserId(mail$)
  Protected result = #False
  If connect()
    SetDatabaseString(db,0,mail$)
    DatabaseQuery(db,"SELECT id FROM User WHERE Mail=?")
    If NextDatabaseRow(db)
      result= GetDatabaseLong(db,0)
    EndIf
    FinishDatabaseQuery(db)
  EndIf
  ProcedureReturn result
EndProcedure

Procedure addValidationCode(mail$,code$)
  Protected result = #False
  If connect()
    SetDatabaseString(db,1,mail$)
    SetDatabaseString(db,0,code$)
    result = DatabaseUpdate(db,"UPDATE User SET Validation = ? WHERE Mail = ?")
  EndIf
  ProcedureReturn result
EndProcedure

Procedure.s getValidationCode(mail$)
  Protected result$ = ""
  If connect()
    SetDatabaseString(db,0,mail$)
    DatabaseQuery(db,"SELECT Validation FROM User WHERE Mail = ?")
    If NextDatabaseRow(db)
      result$ = GetDatabaseString(db,0)
    EndIf
    FinishDatabaseQuery(db)
  EndIf
  ProcedureReturn result$
EndProcedure

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
; IDE Options = PureBasic 6.10 LTS (Linux - x64)
; CursorPosition = 86
; Folding = B-
; EnableXP
; DPIAware