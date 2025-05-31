; // ---------------------------------------------------------------------
; // ------- PID
; // ---------------------------------------------------------------------

; // Main

; Creates a new PID object
; $P: The proportional
; $I: The integral
; $D: The derivative
; $min: The minimum the output can be
; $max: The maximum the output can be
; $iMin: The minimum the integral can be
; $iMax: The maximum the integral can be
function @PID_New($P: number, $I: number, $D: number, $min: number, $max: number, $iMin: number, $iMax: number): text
	var $PID = ""
	$PID.P = $P
	$PID.I = $I
	$PID.D = $D
	$PID.LastTime = 0
	$PID.Integral = 0
	$PID.LastError = 0
	$PID.Value = 0
	$PID.Minimum = $min
	$PID.Maximum = $max
	$PID.MinimumIntegral = $iMin
	$PID.MaximumIntegral = $iMax

	return $PID
	
; Updates a PID object
; $self: The PID object
; $processVariable: The value to push to $setPoint
; $setPoint: The value to push $processVariable towards
function @PID_Update($self: text, $processVariable: number, $setPoint: number): text
	var $error = $setPoint - $processVariable
	var $now = time
	
	if $self.LastTime == $now
		$self.LastTime = time
	
	var $deltaTime = ($now - $self.LastTime)
	$self.LastTime = $now

	var $deltaError = $error - $self.LastError
	$self.LastError = $error
	
	$self.Integral = clamp($self.Integral + ($error * $deltaTime), $self.MinimumIntegral, $self.MaximumIntegral)
	var $derivative = $deltaError / $deltaTime
	
	$self.Value = clamp(($self.P * $error) + ($self.I * $self.Integral) + ($self.D * $derivative), $self.Minimum, $self.Maximum)
	
	; Return
	return $self