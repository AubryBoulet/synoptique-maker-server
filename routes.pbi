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

Declare getFile(datas)
Declare testFile(datas)
Declare register(datas)
Declare valideAccount(datas)
Declare login(datas)
Declare sendNewMail(datas)
Declare checkValidToken(datas)
Declare listSynoptiques(datas)
Declare listPoints(datas)

Global Dim AllowedRoutes.route(20)
With AllowedRoutes(0)
  \methode = "GET"
  \url = "/"
  \function = @getFile()
  \requierToken = #False
EndWith

With AllowedRoutes(1)
  \methode = "GET"
  \url = "assets/[s]"
  \function = @getFile()
  \requierToken = #False
EndWith

With AllowedRoutes(2)
  \methode = "POST"
  \url = "api/register"
  \function = @register()
  \requierToken = #False
EndWith

With AllowedRoutes(3)
  \methode = "POST"
  \url = "api/registerconfirmation"
  \function = @valideAccount()
  \requierToken = #False
EndWith

With AllowedRoutes(4)
  \methode = "POST"
  \url = "api/login"
  \function = @login()
  \requierToken = #False
EndWith

With AllowedRoutes(5)
  \methode = "POST"
  \url = "api/registernewmail"
  \function = @sendNewMail()
  \requierToken = #False
EndWith

With AllowedRoutes(6)
  \methode = "GET"
  \url = "api/checkactivetoken"
  \function = @checkValidToken()
  \requierToken = #False
EndWith

With AllowedRoutes(7)
  \methode = "GET"
  \url = "api/listsynoptiques"
  \function = @listSynoptiques()
  \requierToken = #True
EndWith

With AllowedRoutes(8)
  \methode = "GET"
  \url = "api/listpoints"
  \function = @listPoints()
  \requierToken = #True
EndWith

; 
; With AllowedRoutes(3)
;   \methode = "POST"
;   \url = "api/testfile"
;   \function = @testFile()
; EndWith
; IDE Options = PureBasic 6.10 LTS (Linux - x64)
; CursorPosition = 108
; FirstLine = 72
; EnableXP
; DPIAware