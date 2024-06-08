Declare newNetworkData(ClientID)
Declare get(URL$,ClientID)
Declare BuildRequestHeader(*Buffer, DataLength, ContentType$, Code$)

Procedure BuildRequestHeader(*Buffer, DataLength, ContentType$, Code$)
  Protected EOL$ = Chr(13)+Chr(10), Length
  Debug "start : "+*Buffer
  Length = PokeS(*Buffer, Code$+EOL$, -1, #PB_UTF8) : *Buffer+Length
  Length = PokeS(*Buffer, "Date: "+FormatDate("%dd %mm %yyyy %hh:%ii:%ss",Date())+" GMT"+EOL$, -1, #PB_UTF8) : *Buffer+Length
  Length = PokeS(*Buffer, "Server: Synoptique Maker"+EOL$, -1, #PB_UTF8)      : *Buffer+Length
  Length = PokeS(*Buffer, "Access-Control-Allow-Origin: *"+EOL$, -1, #PB_UTF8)         : *Buffer+Length
  Length = PokeS(*Buffer, "Access-Control-Allow-Headers: *"+EOL$, -1, #PB_UTF8)         : *Buffer+Length
  Length = PokeS(*Buffer, "Access-Control-Allow-Methods: *"+EOL$, -1, #PB_UTF8)         : *Buffer+Length
  Length = PokeS(*Buffer, "Content-Length: "+Str(DataLength)+EOL$, -1, #PB_UTF8)    : *Buffer+Length
  Length = PokeS(*Buffer, "Content-Type: "+ContentType$+EOL$, -1, #PB_UTF8)         : *Buffer+Length
  Length = PokeS(*Buffer, #CRLF$, -1, #PB_UTF8)                                     : *Buffer+Length
  Debug "end : "+*Buffer
  ; Length = PokeS(*Buffer, "Accept-Ranges: bytes"+EOL$, -1, #PB_UTF8) : *Buffer+Length
  ; Length = PokeS(*Buffer, "Connection: close"+EOL$, -1, #PB_UTF8) : *Buffer+Length
  ProcedureReturn *Buffer
EndProcedure

Procedure sendClientFile(ClientID, RequestedFile$)
  Protected ContentType$ = "", file = 0, extention$ = "", FileLength, *FileBuffer, *BufferOffset
  file = ReadFile(#PB_Any, BaseDirectory$+RequestedFile$, #PB_UTF8)
  If file
    extention$ = GetExtensionPart(GetCurrentDirectory()+RequestedFile$)
    Select extention$
          Case "gif"
            ContentType$ = "image/gif"

          Case "jpg"
            ContentType$ = "image/jpeg"
            
          Case "png"
            ContentType$ = "image/png"
            
          Case "bmp"
            ContentType$ = "image/bmp"

          Case "txt"
            ContentType$ = "text/plain"

          Case "zip"
            ContentType$ = "application/zip"
            
          Case "css"
            ContentType$ = "text/css"
            
          Case "js"
            ContentType$ = "text/javascript"

          Default
            ContentType$ = "text/html"
    EndSelect
    FileLength = Lof(file)
    
    *FileBuffer   = AllocateMemory(FileLength+250)
    *BufferOffset = BuildRequestHeader(*FileBuffer, FileLength, ContentType$, "HTTP/1.1 200 OK")
    
    ReadData(file, *BufferOffset, FileLength)
    CloseFile(file)
    SendNetworkData(ClientID, *FileBuffer, *BufferOffset-*FileBuffer+FileLength)    
    FreeMemory(*FileBuffer)
  EndIf
EndProcedure

Procedure sendClientJson(ClientID,json)
  Protected ContentType$ = "application/json", json$ = ComposeJSON(json), length = StringByteLength(json$,#PB_UTF8), *fileBuffer, *BufferOffset
  *fileBuffer = AllocateMemory(length+250)
  *BufferOffset = BuildRequestHeader(*FileBuffer, length, ContentType$, "HTTP/1.1 200 OK")
  PokeS(*BufferOffset,json$,-1,#PB_UTF8)
  SendNetworkData(ClientID,*fileBuffer,*BufferOffset-*FileBuffer+length)
  FreeMemory(*fileBuffer)
  FreeJSON(json)
EndProcedure

Procedure sendError(ClientID,message$)
  Protected length = StringByteLength(message$,#PB_UTF8)+2, *buffer = AllocateMemory(length+250), *bufferOffset
  *bufferOffset = BuildRequestHeader(*buffer,length,"application/json","HTTP/1.1 403 Forbidden")
  PokeS(*bufferOffset,Chr(34)+message$+Chr(34),-1,#PB_UTF8)
  SendNetworkData(ClientID,*buffer,*bufferOffset-*buffer+length)
  FreeMemory(*buffer)
EndProcedure

Procedure sendMessage(ClientID,message$)
  Protected length = StringByteLength(message$,#PB_UTF8)+2, *buffer = AllocateMemory(length+250), *bufferOffset
  *bufferOffset = BuildRequestHeader(*buffer,length,"application/json","HTTP/1.1 200 OK")
  PokeS(*bufferOffset,Chr(34)+message$+Chr(34),-1,#PB_UTF8)
  SendNetworkData(ClientID,*buffer,*bufferOffset-*buffer+length)
  FreeMemory(*buffer)
EndProcedure

Procedure getFile(*datas.dataFunction)
  With *datas
    If \URL$ = "/" : \URL$ = DefaultPage$ : EndIf
    sendClientFile(\ClientID, \URL$)
  EndWith
EndProcedure

Procedure testFile(*datas.dataFunction)
  Protected length, name$
  With *datas
    length = getContentLenght(\request$)
    If length
      If getContentType(\request$) = "image"
        name$ = getImageFromRequest(\buffer,length,\request$)
        Debug name$
      EndIf
    EndIf
  EndWith
EndProcedure

Procedure register(*datas.dataFunction)
  Structure register
    Mail$
    Password$
  EndStructure
  Protected json, r.register, error$, code$
  With *datas
    json = extractJson(\request$)
    If json
      ExtractJSONStructure(JSONValue(json),@r.register,register)
      FreeJSON(json)
      If addUser(r\Mail$,r\Password$)
        code$ = generateValidationCode(r\Mail$)
        If code$
          If sendVerificationMail(r\Mail$,code$)
            sendMessage(\ClientID,"ok")
          Else
            sendError(\ClientID,"Une erreur est survenue lors de l'envoie du mail de validation")
          EndIf
        Else
          sendError(\ClientID,"Une erreur est survenue.")
        EndIf
      Else
        error$ = DatabaseError()
        If FindString(error$,"Duplicate entry")
          sendError(\ClientID,"Le nom d'utilisateur existe déjà.")
        Else
          sendError(\ClientID,"Une erreur est survenue, veuillez réessayer plus tard.")
        EndIf
      EndIf
    EndIf
  EndWith
EndProcedure

Procedure valideAccount(*datas.dataFunction)
  Structure confirmation
    Mail$
    Code$
  EndStructure
  Protected json, c.confirmation
  With *datas
    json = extractJson(\request$)
    If json
      ExtractJSONStructure(JSONValue(json),@c.confirmation,confirmation)
      FreeJSON(json)
      If valideUserAccount(c\Mail$, c\Code$)
        sendMessage(\ClientID,"ok")
      Else
        sendError(\ClientID,"Le code de validation de correspond pas")
      EndIf
    EndIf
  EndWith
EndProcedure

Procedure login(*datas.dataFunction)
  Structure login
    Mail$
    Password$
  EndStructure
  Structure user
    token$
    id.i
  EndStructure
  Protected json, l.login, *token.token = AllocateMemory(SizeOf(token)), user.user, status
  With *datas
    json = extractJson(\request$)
    If json
      ExtractJSONStructure(JSONValue(json),l.login,login)
      FreeJSON(json)
      status = verifyUser(l\Mail$,l\Password$)
      If status = 1
        generateToken(*token)
        If *token\encodedToken$
          user\id = getUserId(l\Mail$)
          user\token$ = *token\encodedToken$
          json = CreateJSON(#PB_Any)
          If json
            InsertJSONStructure(JSONValue(json),@user,user)
            sendClientJson(\ClientID,json)
            AddElement(users())
            users()\id = user\id
            users()\token$ = *token\token$
          Else
            sendError(\ClientID,"Une erreur est survenue, veuillez réessayer plus tard")
          EndIf
        Else
          sendError(\ClientID,"Une erreur est survenue, veuillez réessayer plus tard")
        EndIf
      ElseIf status = 2
        sendMessage(\ClientID,"to validate")
      Else
        sendError(\ClientID,"Couple adresse mail + mot de passe invalide")
      EndIf
    Else
      sendError(\ClientID,"Une erreur est survenue, veuillez réessayer plus tard")
    EndIf
  EndWith
  FreeMemory(*token)
EndProcedure

Procedure sendNewMail(*datas.dataFunction)
  Structure newMail
    Mail$
  EndStructure
  Protected json, n.newMail, code$
  With *datas
    json = extractJson(\request$)
    ExtractJSONStructure(JSONValue(json),n.newMail,newMail)
    FreeJSON(json)
    code$ = getValidationCode(n\Mail$)
    If code$
      If sendVerificationMail(n\Mail$,code$)
        sendMessage(\ClientID,"ok")
      Else
        sendError(\ClientID,"Une erreur est survenue, veuillez réessayer plus tard")
      EndIf
    Else
      sendError(\ClientID,"redirect")
    EndIf
  EndWith
EndProcedure

Procedure checkValidToken(*datas.dataFunction)
  Protected token$, decodedtoken$, tokenIsValid = #False
  With *datas
    token$ = getRequestArgument(\request$,"token:")
    If token$
      decodedtoken$ = decodeToken(token$)
      ResetList(users())
      While NextElement(users())
        If users()\token$ = decodedtoken$
          tokenIsValid = #True
          sendMessage(\ClientID,Str(users()\id))
          Break
        EndIf
      Wend
      If Not tokenIsValid
        sendError(\ClientID,"Token invalide")
      EndIf
    Else
      sendError(\ClientID,"Token invalide")
    EndIf
  EndWith
EndProcedure

Procedure listSynoptiques(*datas.dataFunction)
  Protected id = Val(getRequestArgument(*datas\request$,"clientId:")),NewList syns.synoptiqueList(), json
  If getSynoptiqueList(id,syns())
    json = CreateJSON(#PB_Any)
    If json
      InsertJSONList(JSONValue(json),syns())
      sendClientJson(*datas\ClientID,json)
    EndIf
  EndIf
EndProcedure

Procedure listPoints(*datas.dataFunction)
  Protected synoptiqueId = Val(getRequestArgument(*datas\request$,"synoptiqueid:")), NewList points.pointList(), json
  If getPointList(synoptiqueId,points())
    json = CreateJSON(#PB_Any)
    If json
      InsertJSONList(JSONValue(json),points())
      sendClientJson(*datas\ClientID,json)
    EndIf
  EndIf
EndProcedure

Procedure movePoint(*datas.dataFunction)
  Structure point
    Id.i
    x.i
    y.i
  EndStructure
  Protected json, p.point
  With *datas
    json = extractJson(\request$)
    If json
      ExtractJSONStructure(JSONValue(json),p.point,point)
      FreeJSON(json)
      If updatePointPosition(p\Id,p\x,p\y)
        sendMessage(\ClientID,"ok")
      Else
        sendError(\ClientID,"Une erreur est survenue, veuillez réessayer plus tard")
      EndIf
    Else
      sendError(\ClientID,"Une erreur est survenue, veuillez réessayer plus tard")
    EndIf
  EndWith
EndProcedure
; IDE Options = PureBasic 6.10 LTS (Linux - x64)
; CursorPosition = 16
; Folding = fI9
; EnableXP
; DPIAware