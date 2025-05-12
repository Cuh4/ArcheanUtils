; // ---------------------------------------------------------------------
; // ------- TEProtocol: Client
; // ---------------------------------------------------------------------

; This is the client code for the Text-Exchange Protocol (TEProtocol/TEP).
; This is a system for communicating with an in-game server with support for multiple clients.
; This file allows you to easily send requests to a TEP server while handling timeouts,
; request queues, etc, for you.

; Example:
; include "beacon.xc"
; include "TEProtocol_Shared.xc"
; include "TEProtocol_Classes.xc"
; include "TEProtocol_Client.xc"
; 
; function @TEPClient()
; 	foreach $TEPClientResponses ($index, $response)
; 		var $request = $response.Request
; 		
; 		if $request.Type == "ping"
; 			print("Ping > " & $response.Content)
; 
; 		@TEPClient_HandleResponse($response)
; 
; function @ping($message: text)
; 	@TEPClient_Send("ping", "", 25) ; request type, payload, timeout in ticks
; 		
; init
; 	@TEPClient_Init(150, "Beacon") ; frequency, beacon alias
; 	
; update
; 	@TEPClient_Update()
; 	@TEPClient()
; 	
; timer interval 1
; 	@ping()

; Dependencies: vehicle/beacon.xc, vehicle/TEProtocol_Classes.xc, vehicle/TEProtocol_Shared.xc

; // Variables
const $TEPCLIENT_RESPONSE_ACKNOWLEDGEMENT_EXPIRY_TIME = 15 ; ticks

storage var $TEPClientID: text ; The ID of this client
var $TEPClientBeacon: text ; The beacon in-use for TEP
var $TEPClientServerFrequency: number ; The frequency to transmit to. Add 1 for receiving frequency
var $TEPClientTransmit = 0 ; Whether or not to transmit via beacon. Variable is used internally and shouldn't be changed manually

array $TEPClientRequestQueue: text ; The request queue
var $TEPClientResponses: text ; Responses for the user (you) to iterate through and handle
var $TEPClientAcknowledgedResponses: text ; Key-value of acknowledged responses. Index = Response ID

; // Main

; Sends a log
; $level: The log level (see $TEP_LOG_LEVEL_ENUM)
; $content: The log content
function @TEPClient_Log($level: text, $content: text)
	@TEP_Log("Client", $level, $content)

; Removes the first request
function @_TEPClient_RemoveFirstRequest()
	$TEPClientRequestQueue.erase(0)
	
; Checks if the provided request has been responded to
; $request: The request to check
function @_TEPClient_DoesRequestHaveResponse($request: text): number
	foreach $TEPClientResponses ($index, $response)
		var $_request = $response.Request
		
		if $_request.RequestID == $request.RequestID
			return 1
			
	return 0
	
; Returns if we are on hold for requests
; This is to let other clients get their requests through
function @TEPClient_IsOnHold(): number
	var $incomingData = $TEPClientBeacon.IncomingData
	
	if !$incomingData or !$TEPClientBeacon.IsReceiving
		return 1
	
	var $onHold = $incomingData.OnHold
	
	return $onHold.$TEPClientID != ""

; Handles the first request
function @_TEPClient_HandleRequest()
	$TEPClientTransmit = 0

	if size($TEPClientRequestQueue) <= 0
		return

	; Get request
	var $request = $TEPClientRequestQueue.0

	; Check if timed out
	if @TEPRequest_IsTimedOut($request)
		@TEPClient_Log($TEP_LOG_LEVEL_ENUM.WARNING, text("Request {} timed out", $request.RequestID))
		@_TEPClient_RemoveFirstRequest()
		return
		
	; Check if responded to
	if @_TEPClient_DoesRequestHaveResponse($request)
		@TEPClient_Log($TEP_LOG_LEVEL_ENUM.INFO, text("Request {} has been responded to!", $request.RequestID))
		@_TEPClient_RemoveFirstRequest()
		return
		
	; Check if on hold
	if @TEPClient_IsOnHold()
		$request.@TEPRequest_ExtendTimeout() ; requests shouldn't timeout if this is an intentional hold
		$TEPClientRequestQueue.0 = $request ; update changes
	
		return ; don't transmit anything. this is so clients that are further away can still get their requests through
		
	; Transmit the request til we get a response or we get timed out
	$TEPClientBeacon.@Beacon_Transmit($request)
	$TEPClientTransmit = 1
	
; Registers a TEP request internally
; $request: The request to register
function @_TEPClient_RegisterRequest($request: text)
	$TEPClientRequestQueue.append($request)
	
; Returns all server responses
function @_TEPClient_GetServerResponses(): text
	var $incomingData = $TEPClientBeacon.IncomingData
	
	if !$incomingData or !$TEPClientBeacon.IsReceiving
		return ""
		
	return $incomingData.Responses
	
; Returns if a response is acknowledged
function @_TEPClient_IsResponseAcknowledged($response: text): number
	var $responseID = $response.ResponseID
	
	if !$responseID
		return 0
	
	return $TEPClientAcknowledgedResponses.$responseID != ""
	
; Updates responses
function @_TEPClient_GetOurResponses()
	var $responses = @_TEPClient_GetServerResponses()

	if $responses
		foreach $responses ($index, $response)
			var $request = $response.Request
			var $responseID = $response.ResponseID

			if $request.ClientID == $TEPClientID and !@_TEPClient_IsResponseAcknowledged($response)
				$TEPClientResponses.$responseID = $response
				
; Handles a response. This should be called directly after your code finishes handling a response.
; $response: The response to handle
function @TEPClient_HandleResponse($response: text)
	var $responseID = $response.ResponseID
	
	if !$responseID
		return
	
	$TEPClientAcknowledgedResponses.$responseID = tick + $TEPCLIENT_RESPONSE_ACKNOWLEDGEMENT_EXPIRY_TIME
	$TEPClientResponses.@TEP_RemoveValue($responseID)
	
; Sets up the TEP client beacon
function @_TEPClient_SetupBeacon()
	; Set frequencies
	if $TEPClientTransmit
		$TEPClientBeacon.@Beacon_SetFrequencies($TEPClientServerFrequency, $TEPClientServerFrequency + 1)
	else
		$TEPClientBeacon.@Beacon_SetFrequencies(-1, $TEPClientServerFrequency + 1)
		
	; Update beacon
	$TEPClientBeacon.@Beacon_Update()
	
; Clears acknowledged responses that don't need to be acknowledged anymore
function @_TEPClient_CleanupAcknowledgedResponses()
	var $serverResponses = @_TEPClient_GetServerResponses()
	var $newClientAcknowledgedResponses = ""

	foreach $TEPClientAcknowledgedResponses ($responseID, $tick)
		if tick < $tick
			$newClientAcknowledgedResponses.$responseID = $tick
			
	$TEPClientAcknowledgedResponses = $newClientAcknowledgedResponses
	
; Sends a TEP request
; $type: The request type
; $payload: The payload to supply with the request
; $timeout: The timeout in ticks. If the request doesn't get a response after this timeout, it is dismissed
function @TEPClient_Send($type: text, $payload: text, $timeout: number): text
	if $timeout < 5
		@TEPClient_Log($TEP_LOG_LEVEL_ENUM.ERROR, "@TEPClient_Send(): Timeout must be >5")
		return

	var $request = @TEPRequest_New($type, $payload, $timeout, @TEP_GetUUID(), $TEPClientID)
	@_TEPClient_RegisterRequest($request)

	@TEPClient_Log($TEP_LOG_LEVEL_ENUM.INFO, "Created and registered request: " & $request)

; Initializes the TEP client library. To be called in `init` entry point
; $serverFrequency: The frequency of the TEP server
; $beaconAlias: The alias of the beacon to use for TEP.
function @TEPClient_Init($serverFrequency: number, $beaconAlias: text)
	$TEPClientServerFrequency = $serverFrequency
	$TEPClientBeacon = @Beacon_New($beaconAlias)
	
	if !$TEPClientID
		$TEPClientID = @TEP_GetUUID()
		@TEPClient_Log($TEP_LOG_LEVEL_ENUM.INFO, "Client ID: " & $TEPClientID)
		
; Updates the TEP client library. To be called in `update` entry point
function @TEPClient_Update()
	@_TEPClient_SetupBeacon()
	@_TEPClient_GetOurResponses() ; important this is called before request handling. i think
	@_TEPClient_HandleRequest()
	@_TEPClient_CleanupAcknowledgedResponses()