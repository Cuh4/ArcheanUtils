; // ---------------------------------------------------------------------
; // ------- TEProtocol: Classes
; // ---------------------------------------------------------------------

; This is a file containing classes for the Text-Exchange Protocol (TEProtocol/TEP).
; You won't need to use this. This is used internally.

; // Main

; Creates a TEPHold instance
; $duration: The duration (in seconds) of the client hold
function @TEPHold_New($duration: number): text
	var $TEPHold = ""
	$TEPHold.SetAt = time
	$TEPHold.Duration = $duration
	
	return $TEPHold
	
; Returns if a hold has expired
; $self: The TEPHold instance
function @TEPHold_IsExpired($self: text): number
	return time - $self.SetAt > $self.Duration

; Creates a new TEPResponse instance
; $responseID: The ID of this response
; $content: The content of the response
; $request: The request this response is for
function @TEPResponse_New($responseID: text, $content: text, $request: text): text
	var $TEPResponse = ""
	$TEPResponse.ResponseID = $responseID
	$TEPResponse.Content = $content
	$TEPResponse.Request = $request
	$TEPResponse.MadeAt = time
	$TEPResponse.Tick = tick
	
	return $TEPResponse

; Creates a new TEPRequest instance
; $type: The request type
; $payload: The request payload
; $timeout: How many ticks to wait until the request times out
; $requestID: A unique ID for this request
; $clientID: The client's ID
function @TEPRequest_New($type: text, $payload: text, $timeout: number, $requestID: text, $clientID: text): text
	var $TEPRequest = ""
	$TEPRequest.Type = $type
	$TEPRequest.Payload = $payload
	$TEPRequest.Timeout = $timeout
	$TEPRequest.SentAtTime = time
	$TEPRequest.SentAtTick = tick
	$TEPRequest.RequestID = $requestID
	$TEPRequest.ClientID = $clientID
	
	return $TEPRequest
	
; Returns if a request has timed out
; $self: The TEP request instance
function @TEPRequest_IsTimedOut($self: text): number
	return tick - $self.SentAtTick > $self.Timeout
	
; Extends this request's timeout by a tick
; $self: The TEP request instance
function @TEPRequest_ExtendTimeout($self: text): text
	$self.Timeout++
	return $self