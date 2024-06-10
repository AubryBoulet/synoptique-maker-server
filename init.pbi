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

Structure users ;{ structure declaration
  id.i
  token$
EndStructure

Structure dataFunction
  ClientID.i
  URL$
  request$
  *buffer
EndStructure

Structure route
  methode.s
  url.s
  function.i
  requierToken.b
EndStructure

Structure token
  token$
  encodedToken$
EndStructure

Structure synoptiqueList
  id.i
  image.s
  title.s
  slug.s
EndStructure

Structure pointList
  id.i
  name.s
  type.i
  link.s
  description.s
  file.s
  color.s
  x.i
  y.i
EndStructure

Structure dataSynoptique
  User_Id.i
  Main_Synoptique_Id.i
  Image$
  Title$
  Slug$
EndStructure 

Structure dataPoint
  Name$
  Type.i
  Link.i
  Description$
  File$
  Color$
  Synoptique_Id.i
EndStructure ;}
  
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
; CursorPosition = 76
; FirstLine = 40
; Folding = -
; EnableXP
; DPIAware