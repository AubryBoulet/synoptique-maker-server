Declare getContentLenght(request$)
Declare.s getContentType(request$)
Declare.s getImageType(request$)
Declare.s getImageNameFromRequest(request$)
Declare extractJson(request$)
Declare.s getImageFromRequest(*buffer, length, request$)
Declare generateToken(*token.token)
Declare.s decodeToken(token$)
Declare sendVerificationMail(mail$,code$)
Declare.s generateValidationCode(mail$)
Declare.s getRequestArgument(request$, argument$)
Declare isValideToken(request$)

Procedure getContentLenght(request$)
  Protected index, offset
  index = FindString(request$,"Content-Length:")
    If index
      offset = FindString(request$,Chr(13)+Chr(10),index)
      index+15
      ProcedureReturn Val(Mid(request$,index,offset-index))
    EndIf
  ProcedureReturn #False
EndProcedure

Procedure.s getContentType(request$)
  Protected index, offset
  index = FindString(request$, "Content-Type:")
  If index
    offset = FindString(request$,"/",index)
    index + 14
    ProcedureReturn Mid(request$,index,offset-index)
  EndIf
  ProcedureReturn ""
EndProcedure

Procedure.s getRequestArgument(request$, argument$)
  Protected index, offset
  index = FindString(request$,argument$)
  If index
    offset = FindString(request$,Chr(13)+Chr(10),index)
    index + StringByteLength(argument$,#PB_UTF8)+1
    ProcedureReturn Mid(request$,index,offset-index)
  EndIf
  ProcedureReturn ""
EndProcedure

Procedure.s getImageType(request$)
  Protected index, offset
  index = FindString(request$, "Content-Type: image/")
  If index
    offset = FindString(request$,Chr(13)+Chr(10),index)
    index + 20
    ProcedureReturn Mid(request$,index,offset-index)
  EndIf
  ProcedureReturn ""
EndProcedure

Procedure extractJson(request$)
  Protected index, lenght, json$
  lenght = getContentLenght(request$)
  If lenght
    index = FindString(request$,"{")
    json$ = Mid(request$,index,lenght)
    ProcedureReturn ParseJSON(#PB_Any,json$)
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure.s getImageNameFromRequest(request$)
  Protected index, offset, name$
  index = FindString(request$, "Content-Name:")
  If index
    offset = FindString(request$,Chr(13)+Chr(10),index)
    index + 14
    name$ = Mid(request$,index,offset-index)
    index = 1
    Repeat
      index = FindString(name$,".",index)
      If index
        offset = index
        index + 1
      EndIf
    Until index = 0
    ProcedureReturn Mid(name$,1,offset-1)
  EndIf
  ProcedureReturn ""
EndProcedure

Procedure.s getImageFromRequest(*buffer, length, request$)
  Protected name$, img, offset
  offset = FindString(request$,#CRLF$ + #CRLF$)
  If offset
    offset + 3
    img = CatchImage(#PB_Any,*buffer+offset,length)
    If img
      name$ = Str(Date())+getImageNameFromRequest(request$)+".png"
      If name$
        SaveImage(img,name$,#PB_ImagePlugin_PNG)
        FreeImage(img)
        ProcedureReturn name$
      EndIf
    EndIf
  EndIf
  ProcedureReturn ""
EndProcedure

Procedure generateToken(*token.token)
  Protected i, str$, encodedStr$, length = 64, *text
  For i = 0 To 63
    str$ + Chr(Random(122,48))
  Next
  *text = UTF8(str$)
  encodedStr$ = Base64Encoder(*text,length)
  FreeMemory(*text)
  *token\token$ = str$
  *token\encodedToken$ = encodedStr$
EndProcedure

Procedure.s decodeToken(token$)
  Protected length = 64, decodedToken$, *decodedBuffer 
  *decodedBuffer = AllocateMemory(length)
  Base64Decoder(token$,*decodedBuffer,length)
  decodedToken$ = PeekS(*decodedBuffer,64,#PB_UTF8)
  FreeMemory(*decodedBuffer)
  ProcedureReturn decodedToken$
EndProcedure

Procedure sendVerificationMail(mail$,code$)
  Debug mail$
  If CreateMail(0,"synoptiquemaker@gmail.com","Code de validation")
    AddMailRecipient(0,mail$,#PB_Mail_To)
    SetMailBody(0,"Votre code de validation pour activer votre compte SynoptiqueMaker est : "+code$)
    ProcedureReturn  SendMail(0,"smtp.gmail.com",465,#PB_Mail_UseSSL | #PB_Mail_UseSMTPS | #PB_Mail_Asynchronous,"synoptiquemaker@gmail.com","gjnzglwozcnhldth ")
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure.s generateValidationCode(mail$)
  Protected code$, i
  For i = 0 To 5
    code$ + Chr(Random(57,48))
  Next
  If addValidationCode(mail$,code$)
    ProcedureReturn code$
  EndIf
  ProcedureReturn ""
EndProcedure

Procedure isValideToken(request$)
  Protected token$, id
  token$ = getRequestArgument(request$,"token:")
  id = Val(getRequestArgument(request$,"clientId:"))
  If token$ = ""
    ProcedureReturn #False
  EndIf
  token$ = decodeToken(token$)
  ResetList(users())
  While NextElement(users())
    If users()\token$ = token$ And users()\id = id
      ProcedureReturn #True
    EndIf
  Wend
  ProcedureReturn #False
EndProcedure
; IDE Options = PureBasic 6.10 LTS (Linux - x64)
; CursorPosition = 161
; FirstLine = 12
; Folding = Ag-
; EnableXP
; DPIAware