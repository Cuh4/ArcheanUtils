; // ---------------------------------------------------------------------
; // ------- Signature
; // ---------------------------------------------------------------------

; Dependencies: beacon.xc

; Example:
; var $signature: text
; 
; init
; 	$signature = @Signature_New("Spaceship-1", "Designed for exploration", "Corvette", @Beacon_New("BeaconAlias")) ; create a signature (essentially information about the vehicle)
; 
; update
; 	var $payload = "" ; anything to broadcast along with the signature
; 	$payload.SomeDataToAlsoBroadcast = 1
; 	$payload.TopSpeed = 200
; 	$payload.Author = "Cuh4"
; 
; 	$signature.@Signature_SetPayload($payload)
; 	$signature.@Signature_Broadcast() ; broadcast signature along with payload

; // Main

; Create a vehicle signature
; $name: The name of the vehicle
; $description: The description of the vehicle
; $type: The type of vehicle
; $beacon: The beacon to transmit this information through
function @Signature_New($name: text, $description: text, $type: text, $beacon: text): text
	var $signature = ""
	$signature.Name = $name
	$signature.Description = $description
	$signature.Type = $type
	$signature.Payload = ""
	$signature.Beacon = $beacon
	
	return $signature
	
; Returns if a beacon signal is a vehicle signature
; $data: The data from the signal
function @Signature_IsSignature($data: text): number
	return $data.IsSignature == 1
	
; Set signature payload to send over data along with signature
; $self: The signature object
; $payload: The payload to send over, preferably key-value pair
function @Signature_SetPayload($self: text, $payload: text): text
	$self.Payload = $payload
	return $self
	
; Broadcast the signature
; $self: The signature object
function @Signature_Broadcast($self: text): text
	var $beacon = $self.Beacon
	
	var $data = ""
	$data.IsSignature = 1
	$data.Name = $self.Name
	$data.Description = $self.Description
	$data.Type = $self.Type
	$data.Payload = $self.Payload
	
	$beacon.@Beacon_Transmit($data)

	return $self