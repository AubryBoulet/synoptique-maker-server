Declare getFile(datas)
Declare testFile(datas)
Declare register(datas)
Declare valideAccount(datas)
Declare login(datas)
Declare sendNewMail(datas)
Declare checkValidToken(datas)
Declare listSynoptiques(datas)
Declare loadSynoptique(datas)
Declare loadSubSynoptique(datas)
Declare listPoints(datas)
Declare movePoint(datas)
Declare createSynoptique(datas)
Declare createPoint(datas)
Declare SaveNewImage(datas)

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
  \url = "api/loadsynoptique"
  \function = @loadSynoptique()
  \requierToken = #True
EndWith

With AllowedRoutes(9)
  \methode = "GET"
  \url = "api/loadsubsynoptique"
  \function = @loadSubSynoptique()
  \requierToken = #True
EndWith

With AllowedRoutes(10)
  \methode = "GET"
  \url = "api/listpoints"
  \function = @listPoints()
  \requierToken = #True
EndWith

With AllowedRoutes(11)
  \methode = "PUT"
  \url = "api/movepoint"
  \function = @movePoint()
  \requierToken = #True
EndWith

With AllowedRoutes(12)
  \methode = "POST"
  \url = "api/createsynoptique"
  \function = @createSynoptique()
  \requierToken = #True
EndWith

With AllowedRoutes(13)
  \methode = "POST"
  \url = "api/createpoint"
  \function = @createPoint()
  \requierToken = #True
EndWith

With AllowedRoutes(14)
  \methode = "POST"
  \url = "api/sendimage"
  \function = @SaveNewImage()
  \requierToken = #True
EndWith

; 
; With AllowedRoutes(3)
;   \methode = "POST"
;   \url = "api/testfile"
;   \function = @testFile()
; EndWith
; IDE Options = PureBasic 6.10 LTS (Linux - x64)
; CursorPosition = 119
; FirstLine = 85
; EnableXP
; DPIAware