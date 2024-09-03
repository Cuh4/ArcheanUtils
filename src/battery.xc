; // ---------------------------------------------------------------------
; // ------- Battery
; // ---------------------------------------------------------------------

; // Main

; Creates a new battery object
; $alias: The alias for the battery
function @Battery_New($alias: text): text
	var $battery = ""
	$battery.Alias = $alias
	$battery.Voltage = 0
	$battery.MaxCapacity = 0
	$battery.StateOfCharge = 0
	$battery.Throughputs = 0

	return $battery
	
; Update a battery object
; $self: The battery object
function @Battery_Update($self: text): text
	$self.Voltage = input_number($self.Alias, 0)
	$self.MaxCapacity = input_number($self.Alias, 1)
	$self.StateOfCharge = input_number($self.Alias, 2)
	$self.Throughputs = input_number($self.Alias, 3)

	return $self