; // ---------------------------------------------------------------------
; // ------- Buzzer
; // ---------------------------------------------------------------------

; // Main

; Creates a new buzzer object
; $alias: The alias for the buzzer
function @Buzzer_New($alias: text): text
	var $buzzer = ""
	$buzzer.Alias = $alias

	return $buzzer
	
; Set's buzzer settings
; $self: The buzzer object
; $amplitude: The amplitude of the buzzer. Use 0 for no sound
; $frequency: The frequency in Hz (0-20000)
function @Buzzer_Set($self: text, $amplitude: number, $frequency: number): text
	output_number($self.Alias, 0, $amplitude)
	output_number($self.Alias, 1, $frequency)
		
	return $self