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
EndStructure

Structure token
  token$
  encodedToken$
EndStructure

Declare getFile(datas)
Declare testApi(datas)
Declare testFile(datas)
Declare register(datas)
Declare valideAccount(datas)
Declare login(datas)
Declare sendNewMail(datas)

Global Dim AllowedRoutes.route(5)
With AllowedRoutes(0)
  \methode = "GET"
  \url = "/"
  \function = @getFile()
EndWith

With AllowedRoutes(1)
  \methode = "GET"
  \url = "assets/[s]"
  \function = @getFile()
EndWith

With AllowedRoutes(2)
  \methode = "POST"
  \url = "api/register"
  \function = @register()
EndWith

With AllowedRoutes(3)
  \methode = "POST"
  \url = "api/registerconfirmation"
  \function = @valideAccount()
EndWith

With AllowedRoutes(4)
  \methode = "POST"
  \url = "api/login"
  \function = @login()
EndWith

With AllowedRoutes(5)
  \methode = "POST"
  \url = "api/registernewmail"
  \function = @sendNewMail()
EndWith

; With AllowedRoutes(2)
;   \methode = "POST"
;   \url = "api/test"
;   \function = @testApi()
; EndWith
; 
; With AllowedRoutes(3)
;   \methode = "POST"
;   \url = "api/testfile"
;   \function = @testFile()
; EndWith
; IDE Options = PureBasic 6.10 LTS (Linux - x64)
; CursorPosition = 60
; FirstLine = 35
; EnableXP
; DPIAware