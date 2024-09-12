; // ---------------------------------------------------------------------
; // ------- Beacon
; // ---------------------------------------------------------------------

; // Main

; Creates a new beacon object
; $alias: The alias for the beacon
function @Beacon_New($alias: text): text
	var $beacon = ""
	$beacon.Alias = $alias
	$beacon.ReceiveFrequency = 0
	$beacon.TransmitFrequency = 0
	$beacon.IncomingData = ""
	$beacon.Distance = 0
	$beacon.DirectionX = 0
	$beacon.DirectionY = 0
	$beacon.DirectionZ = 0
	$beacon.IsReceiving = 0

	return $beacon
	
; Updates a beacon object. This is to be called in `update`
; $self: The beacon object
function @Beacon_Update($self: text): text
	$self.IncomingData = input_text($self.Alias, 0)
	$self.Distance = input_number($self.Alias, 1)
	$self.DirectionX = input_number($self.Alias, 2)
	$self.DirectionY = input_number($self.Alias, 3)
	$self.DirectionZ = input_number($self.Alias, 4)
	$self.IsReceiving = input_number($self.Alias, 5)

	return $self

; Transmit the provided data
; $self: The beacon object
; $data: The data to transmit
function @Beacon_Transmit($self: text, $data: text): text
	output_number($self.Alias, 0, $data)
	return $self

; Set the frequencies for a beacon
; $self: The beacon object
; $transmit: The transmitting frequency
; $receive: The receiving frequency
function @Beacon_SetFrequencies($self: text, $transmit: number, $receive: number): text
	output_number($self.Alias, 1, $transmit)
	$self.TransmitFrequency = $transmit

	output_number($self.Alias, 2, $receive)
	$self.ReceiveFrequency = $receive

	return $self