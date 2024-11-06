; // ---------------------------------------------------------------------
; // ------- Dashboard
; // ---------------------------------------------------------------------

; // Main

; Creates a new dashboard object
; $alias: The alias for the dashboard
function @Dashboard_New($alias: text): text
	var $dashboard = ""
	$dashboard.Alias = $alias

	return $dashboard
	
; Returns if a button is being pressed on the provided channel. Cannot be called via trailing
; $self: The dashboard object
; $channel: The channel of the button
function @Dashboard_IsPressed($self: text, $channel: number): number
	return input_number($self.Alias, $channel)

; Set an LED's state
; $self: The dashboard object
; $channel: The channel of the LED
; $on: Whether or not to turn the LED on
function @Dashboard_SetLED($self: text, $channel: number, $on: number): text
	output_number($self.Alias, $channel, $on)
	return $self