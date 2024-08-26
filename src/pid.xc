; // ---------------------------------------------------------------------
; // ------- PID
; // ---------------------------------------------------------------------

; Runs a PID
; $setPoint: The goal
; $processValue: The current point
; $KP: the P in PID (proportional)
; $KI: the I in PID (integral)
; $KD: the D in PID (derivative)
; $previousError: ignore, leave out
function @PID($setPoint: number, $processValue: number, $KP: number, $KI: number, $KD: number, $integral: number, $previousError: number): number
	var $error = $setPoint - $processValue
	var $deltaTime = delta_time
	var $derivative = ($error - $previousError) / $deltaTime
	$integral += $error * $deltaTime
	$previousError = $error

	return $KP * $error + $KI * $integral + $KD * $derivative