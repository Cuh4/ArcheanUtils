; // ---------------------------------------------------------------------
; // ------- TEProtocol: Server
; // ---------------------------------------------------------------------

; This is the server code for the Text-Exchange Protocol (TEProtocol/TEP).
; This is a system for communicating with an in-game server with support for multiple clients.
; This file allows you to handle incoming requests and give your own responses to them.

; Example:
; include "beacon.xc"
; include "TEProtocol_Shared.xc"
; include "TEProtocol_Classes.xc"
; include "TEProtocol_Server.xc"
; 
; function @TEPServer()
; 	foreach $TEPRequestsAwaitingResponse ($index, $request)
; 		if $request.Type == "ping"
; 			@TEPServer_ServeResponse($request, text("Pong! {0.00}ms", (time - $request.SentAtTime) * 1000))
; 		else
; 			@TEPServer_ServeResponse($request, "") ; a response MUST be served
; 
; init
; 	@TEPServer_Log($TEP_LOG_LEVEL_ENUM.INFO, "Listening for requests...")
; 	@TEPServer_Init(150, "Beacon") ; frequency, beacon alias
; 	
; update
; 	@TEPServer_Update()
; 	@TEPServer()

; Dependencies: vehicle/beacon.xc, vehicle/TEProtocol_Classes.xc, vehicle/TEProtocol_Shared.xc

; // Variables
const $TEPSERVER_OVERLOAD_CHARACTER_COUNT = 3200 ; if $TEPServerHolds, $TEPServerResponses, etc, exceeds this character count, the server will drop incoming requests to prevent "Text too large" error
const $TEPSERVER_RESPONSE_EXPIRY_TIME = 7 ; ticks. how long it takes for a response to expire
const $TEPSERVER_REQUEST_ACKNOWLEDGEMENT_EXPIRY_TIME = 7 ; ticks. how long it takes for a request acknowledgement to expire
const $TEPSERVER_ONHOLD_RANDOM_MIN = 2 ; minimum time in ticks for randomized client hold
const $TEPSERVER_ONHOLD_RANDOM_MAX = 5 ; maximum time in ticks for randomized client hold

var $TEPServerBeacon: text ; The beacon in-use for TEP
var $TEPServerFrequency: number ; The frequency to listen on (add 1 for transmit frequency)
var $TEPRequestsAwaitingResponse: text ; An array of requests that need a response. This is for the user (you) to handle

var $TEPServerHolds: text ; A key-value array of clients on hold
var $TEPServerResponses: text ; A key-value array of responses to requests
var $TEPServerAcknowledgedRequests: text ; A key-value array of acknowledged requests

; // Main

; Sends a log
; $level: The log level (see $TEP_LOG_LEVEL_ENUM)
; $content: The log content
function @TEPServer_Log($level: text, $content: text)
	@TEP_Log("Server", $level, $content)

; Puts a client on hold meaning they can't send requests until the hold expires
; $clientID: The client's ID
; $duration: How long to put the client on hold for in seconds
function @TEPServer_SetClientOnHold($clientID: text, $duration: number)
	var $hold = $TEPServerHolds.$clientID

	if $hold
		return

	$TEPServerHolds.$clientID = @TEPHold_New($duration)
	@TEPServer_Log($TEP_LOG_LEVEL_ENUM.INFO, text("Placed client {} on hold for {0} ticks", $clientID, $duration))

; Puts a client off hold
; $clientID: The client's ID
function @TEPServer_RemoveClientHold($clientID: text)
	$TEPServerHolds.$clientID = ""
	
; Returns if this server is overloaded (key-value pairs getting too close to text limit)
function @TEPServer_IsOverloaded(): number
	if size($TEPRequestsAwaitingResponse) > $TEPSERVER_OVERLOAD_CHARACTER_COUNT
		return 1
		
	if size($TEPServerHolds) > $TEPSERVER_OVERLOAD_CHARACTER_COUNT
		return 1
		
	if size($TEPServerResponses) > $TEPSERVER_OVERLOAD_CHARACTER_COUNT
		return 1
		
	if size($TEPServerAcknowledgedRequests) > $TEPSERVER_OVERLOAD_CHARACTER_COUNT
		return 1
		
	return 0
	
; Handles the provided request and provides the client a response.
; Call this after giving a response to a request
; $request: The request to handle
; $content: The response content
function @TEPServer_ServeResponse($request: text, $content: text)
	var $servedRequestID = $request.RequestID

	if !$servedRequestID
		return

	$TEPRequestsAwaitingResponse.@TEP_RemoveValue($servedRequestID)
	$TEPServerResponses.$servedRequestID = @TEPResponse_New(@TEP_GetUUID(), $content, $request)
	
	@TEPServer_Log($TEP_LOG_LEVEL_ENUM.INFO, text("Responded to {} with: {}", $servedRequestID, $content))

; Handles the incoming request if any
function @_TEPServer_HandleIncomingRequest()
	; Get request
	var $request = $TEPServerBeacon.IncomingData

	if !$request or !$TEPServerBeacon.IsReceiving
		return

	; Get request ID
	var $requestID = $request.RequestID
	
	if !$requestID
		return ; not a request, just some random data being transmitted probably
		
	; Overloaded check
	if @TEPServer_IsOverloaded()
		@TEPServer_Log($TEP_LOG_LEVEL_ENUM.WARNING, text("Request {} dropped due to server overload", $requestID))
		return
		
	; Only handle this request once
	if $TEPServerAcknowledgedRequests.$requestID != ""
		return

	$TEPServerAcknowledgedRequests.$requestID = tick + 1000
	
	; Log
	@TEPServer_Log($TEP_LOG_LEVEL_ENUM.INFO, "Accepted request: " & $requestID & " from " & $request.ClientID)
		
	; Add to array
	$TEPRequestsAwaitingResponse.$requestID = $request
	
	; Don't let closer clients hog requests by telling them to stop
	; transmitting for a little bit (closer signals on same frequency
	; take priority in Archean, so this is to account for that)
	@TEPServer_SetClientOnHold($request.ClientID, random($TEPSERVER_ONHOLD_RANDOM_MIN, $TEPSERVER_ONHOLD_RANDOM_MAX))
	
; Removes all expired client holds
function @_TEPServer_RemoveExpiredHolds()
	var $newHolds = "" ; instead of removing values during iteration, lets remove all needed values at the end to prevent an error
	
	foreach $TEPServerHolds ($index, $hold)
		if !@TEPHold_IsExpired($hold)
			$newHolds.$index = $hold
			
	$TEPServerHolds = $newHolds
	
; Removes all expired responses
function @_TEPServer_RemoveExpiredResponses()
	var $newResponses = "" ; see comment above in @_TEPServer_RemoveExpriedHolds()
	
	foreach $TEPServerResponses ($index, $response)
		if tick - $response.Tick < $TEPSERVER_RESPONSE_EXPIRY_TIME
			var $request = $response.Request
			var $requestID = $request.RequestID
			$TEPServerAcknowledgedRequests.$requestID = tick + $TEPSERVER_REQUEST_ACKNOWLEDGEMENT_EXPIRY_TIME
			
			$newResponses.$index = $response
			
	$TEPServerResponses = $newResponses
	
; Clears acknowledged requests that don't need to be acknowledged anymore
function @_TEPServer_CleanupAcknowledgedRequests()
	var $newServerAcknowledgedRequests = ""

	foreach $TEPServerAcknowledgedRequests ($requestID, $tick)
		if $TEPServerResponses.$requestID ; we gave a response to the request, so the client will stop bugging us and we can rid the acknowledgement after a little
			if tick < $tick
				$newServerAcknowledgedRequests.$requestID = $tick
					
	$TEPServerAcknowledgedRequests = $newServerAcknowledgedRequests
	
; Transmits everything needed via beacon
function @_TEPServer_Transmit()
	var $data = ""
	$data.OnHold = $TEPServerHolds
	$data.Responses = $TEPServerResponses
	
	$TEPServerBeacon.@Beacon_Transmit($data)

; Sets up the TEP server beacon
function @_TEPServer_SetupBeacon()
	$TEPServerBeacon.@Beacon_SetFrequencies($TEPServerFrequency + 1, $TEPServerFrequency)
	$TEPServerBeacon.@Beacon_Update()
	@_TEPServer_Transmit()

; Initializes the TEP server library. To be called in `init` entry point
; $serverFrequency: The frequency of the TEP server
; $beaconAlias: The alias of the beacon to use for TEP.
function @TEPServer_Init($serverFrequency: number, $beaconAlias: text)
	$TEPServerFrequency = $serverFrequency
	$TEPServerBeacon = @Beacon_New($beaconAlias)
		
; Updates the TEP server library. To be called in `update` entry point
function @TEPServer_Update()
	@_TEPServer_RemoveExpiredHolds()
	@_TEPServer_RemoveExpiredResponses()
	@_TEPServer_CleanupAcknowledgedRequests()
	@_TEPServer_HandleIncomingRequest()
	@_TEPServer_SetupBeacon()