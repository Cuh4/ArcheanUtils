; // ---------------------------------------------------------------------
; // ------- Toggle
; // ---------------------------------------------------------------------

; Example:
; storage var $LightsToggle: text
; $LightsToggle.@Toggle_New()
; $LightsToggle.@Toggle_Pulse(1)
; print($LightsToggle.On)

; // Main

; Creates a new toggle
; $toggle: The text to turn into a toggle
function @Toggle_New($text: text): text
	; Already created, so return it
	if $text
		return $text

	; Not created, so create one
	var $toggle = ""
	$toggle.Last = 0
	$toggle.On = 0

	return $toggle

; Sends a pulse to the toggle object
; $self: The toggle object
; $pulse: 0 or 1, off or on
function @Toggle_Pulse($self: text, $pulse: number): text
	if $pulse and !$self.Last
		$self.On!!
	
	$self.Last = $pulse
	
	return $self