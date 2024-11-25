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
function @PID_New($P: number, $I: number, $D: number, $min: number, $max: number): text
	var $PID = ""
	$PID.P = $P
	$PID.I = $I
	$PID.D = $D
	$PID.LastTime = 0
	$PID.Integral = 0 ; = Total error over time
	$PID.LastError = 0
	$PID.Value = 0
	$PID.Minimum = $min
	$PID.Maximum = $max

	return $PID
	
; Updates a PID object
; $self: The PID object
; $processVariable: The value to push to $setPoint
; $setPoint: The value to push $processVariable towards
function @PID_Update($self: text, $processVariable: number, $setPoint: number): text
	var $error = $setPoint - $processVariable
	
	var $deltaTime = (time - $self.LastTime)
	$self.LastTime = time

	var $deltaError = $error - $self.LastError
	$self.LastError = $error
	
	$self.Integral += $error * $deltaTime
	var $derivative = $deltaError / $deltaTime
	
	$self.Value = clamp(($self.P * $error) + ($self.I * $self.Integral) + ($self.D * $derivative), $self.Minimum, $self.Maximum)
	
	; Return
	return $self