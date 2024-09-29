; // ---------------------------------------------------------------------
; // ------- Propeller
; // ---------------------------------------------------------------------

; // Main

; Creates a new propeller object
; $alias: The alias for the propeller
function @Propeller_New($alias: text): text
	var $propeller = ""
	$propeller.Alias = $alias

	return $propeller
	
; Set the propeller's speed
; $self: The propeller object
; $speed: The speed, 0-1
function @Propeller_SetSpeed($self: text, $speed: number): text
	output_number($self.Alias, 0, $speed)
	return $self
	
; Set the propeller's pitch
; $self: The propeller object
; $pitch: The pitch, -1 to 1
function @Propeller_SetPitch($self: text, $pitch: number): text
	output_number($self.Alias, 1, $pitch)
	return $self