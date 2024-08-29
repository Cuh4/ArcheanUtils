; // ---------------------------------------------------------------------
; // ------- Stabilization
; // ---------------------------------------------------------------------

; This was created for my motorcycle vehicle. You won't need this and probably shouldn't use this either way.

; // Includes

include "pid.xc"

; // Main

; Creates a new roll stabilization management object
; $gyroAlias: The alias for the gyroscope
; $tiltSensorAlias: The alias for the tilt sensor
function @RollStabilization_New($gyroAlias: text, $tiltSensorAlias: text): text
	var $stabilization = ""
	$stabilization.GyroAlias = $gyroAlias
	$stabilization.TiltAlias = $tiltSensorAlias
	$stabilization.Roll = 0

	return $stabilization
	
; Updates speed
; $self: The roll stabilization object
; $speed: The desired speed, -1 to 1
function @RollStabilization_ChangeSpeed($self: text, $speed: number): text
	output_number($self.GyroAlias, 0, $speed)
	return $self
	
; Updates control
; $self: The roll stabilization object
; $control: The desired control, -1 to 1
function @RollStabilization_ChangeControl($self: text, $control: number): text
	output_number($self.GyroAlias, 1, $control)
	return $self

; Updates a roll stabilization object
; $self: The roll stabilization object
; $goal: The goal tilt to achieve
function @RollStabilization_Update($self: text, $goal: number): text
	; Update rolls
	$self.Roll = input_number($self.TiltAlias, 0)
	
	; Stabilize
	var $result = -clamp(@PID($goal, $self.Roll, 0.5, 0, 0.1), -1, 1)
	$self.@RollStabilization_ChangeControl($result)
	
	; Return
	return $self