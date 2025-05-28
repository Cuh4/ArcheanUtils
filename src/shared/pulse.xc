; // ---------------------------------------------------------------------
; // ------- Pulse
; // ---------------------------------------------------------------------

; Example:
; storage var $pulse: text
;
; init
;   $pulse.@Pulse_New()
;
; update
;   $pulse.@Pulse_Toggle(input_number("Seat", 10))
;
; 	if $pulse.On
;		; do something

; // Main

; Creates a new pulse object
; $text: The text to make the pulse object (syntax: $myTextVar.@Pulse_New())
function @Pulse_New($text: text): text
	if $text
		return $text

	var $pulse = ""
	$pulse.Last = 0
	$pulse.On = 0

	return $pulse

; Updates pulse object from input
; $input: The toggle input
function @Pulse_Toggle($self: text, $input: number): text
	if $input and !$self.Last
		$self.On = 1
	else
		$self.On = 0

	$self.Last = $input

	return $self