UseJPEGImageDecoder()
UsePNGImageDecoder()
UsePNGImageEncoder()
UseMySQLDatabase()

Global dataMutex = CreateMutex(), processMutex = CreateMutex()

Global BaseDirectory$ = "www/"
Global DefaultPage$   = "Index.html"
Global ErrorPage$ = "Error.html"
Global Port = 8081
Global dbHost$ = "127.0.0.1"
Global dbPort$ = "3306"
Global dbName$ = "synoptiquemaker"
Global dbUser$ = "synoptiquemaker"
Global dbPassword$ = "azerty"
Global db
Structure users
  id.i
  token$
EndStructure
Global NewList users.users()
Procedure connect()
  If IsDatabase(db) = 0
    db = OpenDatabase(#PB_Any,"host="+dbHost$+" port="+dbPort$+" dbname='"+dbName$+"'",dbUser$,dbPassword$,#PB_Database_MySQL)
  EndIf
  If IsDatabase(db)
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure
; IDE Options = PureBasic 6.10 LTS (Linux - x64)
; CursorPosition = 20
; Folding = -
; EnableXP
; DPIAware