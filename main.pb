EnableExplicit
IncludeFile "init.pbi"
IncludeFile "routes.pbi"
IncludeFile "userDatabase.pbi"
IncludeFile "utils.pbi"
IncludeFile "controllers.pbi"
IncludeFile "server management.pbi"

Define Title$ = "Synoptique Maker", ServerEvent, ClientID

If Not loadSettings()
  MessageRequester(Title$,"Error : unable to load settings",#PB_MessageRequester_Error)
  End
EndIf

If CreateNetworkServer(0, Port, #PB_Network_IPv4 | #PB_Network_TCP, "127.0.0.1")
  If connect()
    If OpenConsole(Title$)
      Repeat
        ServerEvent = NetworkServerEvent()
        If ServerEvent
          ClientID = EventClient()
          Select ServerEvent        
            Case #PB_NetworkEvent_Connect  ; When a new client has been connected...
              ;Debug "New client connected"
              
            Case #PB_NetworkEvent_Disconnect  ; When a client has closed the connection...
              ;Debug "Client disconnected"
      
            Case #PB_NetworkEvent_Data 
              newNetworkData(ClientID)
  
          EndSelect
        Else
          Delay(10)
         EndIf
      ForEver
    Else
      MessageRequester(Title$,"An error has occured",#PB_MessageRequester_Error)
    EndIf
  Else
    MessageRequester(Title$,"Error: unable to reach database server",#PB_MessageRequester_Error)
  EndIf
Else
  MessageRequester(Title$,"Error: can't create the server (port "+Port+" in use ?).",#PB_MessageRequester_Error)
EndIf
; IDE Options = PureBasic 6.10 LTS (Linux - x64)
; CursorPosition = 13
; EnableXP
; DPIAware