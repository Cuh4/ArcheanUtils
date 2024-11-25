; // ---------------------------------------------------------------------
; // ------- Gyro
; // ---------------------------------------------------------------------

; // Main

; Creates a new gyro object
; $alias: The alias for the gyro
function @Gyro_New($alias: text): text
	var $gyro = ""
	$gyro.Alias = $alias

	return $gyro
	
; Set the gyro speed
; $self: The gyro object
; $speed: The speed, 0-1
function @Gyro_SetSpeed($self: text, $speed: number): text
	output_number($self.Alias, 0, $speed)
	return $self
	
; Set the gyro control
; $self: The gyro object
; $control: The control, -1 to 1
function @Gyro_SetControl($self: text, $control: number): text
	output_number($self.Alias, 1, $control)
	return $self