; // ---------------------------------------------------------------------
; // ------- Pump
; // ---------------------------------------------------------------------

; Example:
; var $Pump = @Pump_New("PumpAlias")
; $Pump.@Pump_SetPower(1) ; -1 to 1

; // Main

; Creates a new pump object
; $alias: The pump alias
function @Pump_New($alias: text): text
	var $pump = ""
	$pump.Alias = $alias
	$pump.Flow = 0

	return $pump

; Updates a pump object
; $self: The pump to update
function @Pump_Update($self: text): text
	$self.Flow = input_number($self.Alias, 0)
	return $self
	
; Sets a pump's power
; $self: The pump to manipulate
; $power: The pumping power, -1 to 1
function @Pump_SetPower($self: text, $power: number): text
	output_number($self.Alias, 0, $power)
	return $self