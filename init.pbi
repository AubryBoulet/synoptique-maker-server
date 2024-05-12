UseJPEGImageDecoder()
UsePNGImageDecoder()
UsePNGImageEncoder()
UseMySQLDatabase()

Global dataMutex = CreateMutex(), processMutex = CreateMutex()

Global BaseDirectory$ 
Global DefaultPage$   
Global ErrorPage$ 
Global Port 
Global dbHost$ 
Global dbPort$ 
Global dbName$ 
Global dbUser$ 
Global dbPassword$ 
Global db

Structure users
  id.i
  token$
EndStructure

Global NewList users.users()

Procedure loadSettings()
  If OpenPreferences("settings.ini")
    BaseDirectory$ = ReadPreferenceString("BaseDirectory","")
    DefaultPage$ = ReadPreferenceString("DefaultPages","")
    ErrorPage$ = ReadPreferenceString("ErrorPage","")
    Port = ReadPreferenceInteger("Port",80)
    dbHost$ = ReadPreferenceString("dbHost","127.0.0.1")
    dbPort$ = ReadPreferenceString("dbPort","3306")
    dbName$ = ReadPreferenceString("dbName","")
    dbUser$ = ReadPreferenceString("dbUser","")
    dbPassword$ = ReadPreferenceString("dbPassword","")
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

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
; CursorPosition = 4
; Folding = -
; EnableXP
; DPIAware