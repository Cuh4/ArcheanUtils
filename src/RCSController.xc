; // ---------------------------------------------------------------------
; // ------- RCS Controller
; // ---------------------------------------------------------------------

; Example:
; var $RCSController: text
;
; init
; 	$RCSController = @RCSController_New("AngularVelocitySensorAlias")
; 	$RCSController.RCSAliasPrefix = "RCS" ; The prefix of all RCS components. Defaults to "RCS"
; 	$RCSController.RCSPower = 0.8 ; The general power of all of the RCS components, 0 to 1
; 	$RCSController.PumpPower = 0.6 ; Power of pump, 0 to 1
; 	$RCSController.AutoStabPower = 0.4 ; Power of auto-stabilization, 0 to 1
;
; 	$RCSController.AngVelPitchMultiplier = -1 ; placed angular velocity sensor incorrectly? you can invert axes like so
; 	$RCSController.AngVelYawMultiplier = 1
; 	$RCSController.AngVelRollMultiplier = -1
;
; update
; 	$RCSController.@RCSController_Update() ; Required, otherwise the RCS controller won't do anything
;
; 	$RCSController.@RCSController_Rotate(1, 0, 0) ; Pitch down
; 	$RCSController.@RCSController_Translate(1, 0, -1) ; Go forward (1), and down (-1)
;
; 	$RCSController.@RCSController_ControlRCS("Front", 0, 0, 1) ; Control all front-left RCS components to propel up (don't call this method, let the controller do its thing)

; // Main

; Creates a new RCS controller object (tip: H2 is the best fuel to use for RCS, produces the most force)
; RCS placement: top = 1, bottom = 2, left side = 4, right side = 3, front = 0
; $angularVelocitySensorAlias: The alias for the angular velocity sensor. Sensor specs: +X = Pitch Forward, +Y = Yaw Right, +Z = Roll Right
function @RCS_New($angularVelocitySensorAlias: text): text
	; Create object
	var $RCSController = ""
	
	; Settings
	$RCSController.On = 1
	$RCSController.RCSPower = 1 ; 0 to 1
	$RCSController.PumpPower = 1 ; 0 to 1
	$RCSController.AutoStabPower = 0.6 ; 0 to 1
	$RCSController.RCSAliasPrefix = "RCS"
	$RCSController.AngVelPitchMultiplier = 1 ; For inverting
	$RCSController.AngVelYawMultiplier = -1 ; For inverting
	$RCSController.AngVelRollMultiplier = 1 ; For inverting
	
	; Aliases
	$RCSController.RCSAliasPrefix = "RCS"

	; Rotation
	$RCSController.DesiredPitch = 0 ; Desired = What the user wants the RCS controller to do
	$RCSController.DesiredYaw = 0
	$RCSController.DesiredRoll = 0
	
	$RCSController.SystemPitch = 0 ; System = What the RCS controller wants itself to do
	$RCSController.SystemYaw = 0
	$RCSController.SystemRoll = 0

	; Translation
	$RCSController.DesiredLongitudinal = 0
	$RCSController.DesiredHorizontal = 0
	$RCSController.DesiredVertical = 0
	
	; no system translation here since there's no translation auto-stabilization (not much of a point in space)
	
	; Sensor
	$RCSController.AngularVelocitySensorAlias = $angularVelocitySensorAlias

	$RCSController.PitchRate = 0 ; Ang Vel X
	$RCSController.YawRate = 0 ; Ang Vel Y
	$RCSController.RollRate = 0 ; Ang Vel Z

	$RCSController.AngVelPitchMultiplier = 1 ; For inverting
	$RCSController.AngVelYawMultiplier = -1 ; For inverting
	$RCSController.AngVelRollMultiplier = 1 ; For inverting

	; Return object
	return $RCSController
	
; Control a RCS nozzle
; $self: The RCS controller object
; $location: The RCS location (main part of alias, eg: "Front", "Back", etc)
; $longitudinal: Forward/backwards thrust
; $horizontal: Horizontal thrust
; $vertical: Vertical thrust
function @RCS_ControlRCS($self: text, $location: text, $longitudinal: number, $horizontal: number, $vertical: number): text
	output_number($self.RCSAliasPrefix & $location & "*", 0, $longitudinal * $self.On * $self.RCSPower)

	output_number($self.RCSAliasPrefix & $location & "*", 4, -$horizontal * $self.On * $self.RCSPower)
	output_number($self.RCSAliasPrefix & $location & "*", 3, $horizontal * $self.On * $self.RCSPower)

	output_number($self.RCSAliasPrefix & $location & "*", 1, -$vertical * $self.On * $self.RCSPower)
	output_number($self.RCSAliasPrefix & $location & "*", 2, $vertical * $self.On * $self.RCSPower)

	return $self
	
; Updates the RCS controller object
; $self: The RCS controller object
function @RCS_Update($self: text): text
	; Update sensor
	$self.PitchRate = input_number($self.AngularVelocitySensorAlias, 0) * $self.AngVelPitchMultiplier
	$self.YawRate = input_number($self.AngularVelocitySensorAlias, 1) * $self.AngVelYawMultiplier
	$self.RollRate = input_number($self.AngularVelocitySensorAlias, 2) * $self.AngVelRollMultiplier
	
	; Update system variables (rotation)
	if $self.DesiredPitch
		$self.SystemPitch = $self.DesiredPitch
	else
		$self.SystemPitch = -$self.PitchRate * 3 * $self.AutoStabPower
		
	if $self.DesiredRoll
		$self.SystemRoll = $self.DesiredRoll
	else
		$self.SystemRoll = -$self.RollRate * 3 * $self.AutoStabPower
	
	if $self.DesiredYaw
		$self.SystemYaw = $self.DesiredYaw
	else
		$self.SystemYaw = -$self.YawRate * 3 * $self.AutoStabPower
		
	; Update RCS (Front)
	$self.@RCS_ControlRCS("Front", -$self.DesiredLongitudinal, ($self.SystemYaw + $self.DesiredHorizontal) / 2, (-$self.SystemPitch + $self.DesiredVertical) / 2)
	
	; Update RCS (Left)
	$self.@RCS_ControlRCS("Left", $self.DesiredHorizontal, ($self.SystemYaw + $self.DesiredLongitudinal) / 2, ($self.SystemRoll + $self.DesiredVertical) / 2)
	
	; Update RCS (Right)
	$self.@RCS_ControlRCS("Right", -$self.DesiredHorizontal, ($self.SystemYaw + -$self.DesiredLongitudinal) / 2, (-$self.SystemRoll + $self.DesiredVertical) / 2)
	
	; Update RCS (Back)
	$self.@RCS_ControlRCS("Back", $self.DesiredLongitudinal, ($self.SystemYaw + -$self.DesiredHorizontal) / 2, ($self.SystemPitch + $self.DesiredVertical) / 2)
	
	; Pumps
	output_number($self.RCSAliasPrefix & "Pump", 0, $self.On:number * $self.PumpPower * 0.1)
	
	; Return
	return $self
	
; Update desired rotational movement
; $self: The RCS controller object
; $pitch: The desired pitch
; $yaw: The desired yaw
; $roll: The desired roll
function @RCS_Rotate($self: text, $pitch: number, $yaw: number, $roll: number): text
	$self.DesiredPitch = $pitch
	$self.DesiredYaw = $yaw
	$self.DesiredRoll = $roll

	return $self
	
; Update desired translational movement
; $self: The RCS controller object
; $longitudinal: Desired forwards/backwards
; $horizontal: Desired left/right
; $vertical: Desired up/down
function @RCS_Translate($self: text, $longitudinal: number, $horizontal: number, $vertical: number): text
	$self.DesiredLongitudinal = $longitudinal
	$self.DesiredHorizontal = $horizontal
	$self.DesiredVertical = $vertical

	return $self