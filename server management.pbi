Structure threadData
  ClientID.i
  *buffer
EndStructure
Declare newNetworkData(ClientID)
Declare processRequest(*data.threadData)

Procedure newNetworkData(ClientID)
  Protected *buffer, offSet, DataLength, *param.threadData
  *buffer = AllocateMemory(60000)
  offSet = 0
  Repeat
    DataLength = ReceiveNetworkData(ClientID,*buffer+offSet,60000)
    If DataLength = MemorySize(*buffer) - offSet
      offSet + 60000
      *buffer = ReAllocateMemory(*buffer,60000+offSet,#PB_Memory_NoClear)
    Else
      Break
    EndIf
  ForEver
  *param.threadData = AllocateMemory(SizeOf(threadData))
  *param\ClientID = ClientID
  *param\buffer = *buffer
  CreateThread(@processRequest(),*param)
EndProcedure

Procedure processRequest(*data.threadData)
  Protected request$, REQ$, index, methode$, URL$, routeAllowed = #False, i, *dataFunction.dataFunction
  LockMutex(processMutex)
  With *data
    request$ = PeekS(\buffer,-1,#PB_UTF8)
    REQ$ = Left(request$,FindString(request$,Chr(13)+Chr(10)))
    index = FindString(REQ$,"/")
    methode$ = Left(REQ$,index-2)
    REQ$ = Right(REQ$,StringByteLength(REQ$,#PB_UTF8)-(index-1))
    index = FindString(REQ$," ")
    URL$ = Left(REQ$,index-1)
    URL$ = Right(URL$,StringByteLength(URL$,#PB_UTF8)-1)
    If URL$ = "" : URL$ = "/" : EndIf
    For i = 0 To ArraySize(AllowedRoutes())
      index = FindString(AllowedRoutes(i)\url,"[s]")
      If AllowedRoutes(i)\methode = methode$
        If index
          If Left(AllowedRoutes(i)\url,index-1) = Left(URL$,index-1)
            routeAllowed = #True
            Break
          EndIf
        Else
          If AllowedRoutes(i)\url = URL$
            routeAllowed = #True
            Break
          EndIf
        EndIf
      EndIf
    Next
    *dataFunction.dataFunction = AllocateMemory(SizeOf(dataFunction))
    *dataFunction\ClientID = \ClientID
    *dataFunction\buffer = \buffer
    *dataFunction\request$ = request$
    If routeAllowed = #True
      *dataFunction\URL$ = URL$
      UnlockMutex(processMutex)
      LockMutex(dataMutex)
      CallCFunctionFast(AllowedRoutes(i)\function,*dataFunction)
    Else
      *dataFunction\URL$ = ErrorPage$
      UnlockMutex(processMutex)
      LockMutex(dataMutex)
      getFile(*dataFunction)
    EndIf
    FreeMemory(\buffer)
    FreeMemory(*data)
    FreeMemory(*dataFunction)
    UnlockMutex(dataMutex)
  EndWith
EndProcedure
; IDE Options = PureBasic 6.10 LTS (Linux - x64)
; CursorPosition = 62
; FirstLine = 37
; Folding = -
; EnableXP
; DPIAware