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
	
; Set the propeller's collective
; $self: The propeller object
; $collective: The collective, -1 to 1
function @Propeller_SetCollective($self: text, $collective: number): text
	output_number($self.Alias, 1, $collective)
	return $self