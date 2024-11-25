; // ---------------------------------------------------------------------
; // ------- Wheel
; // ---------------------------------------------------------------------

; Example:
; var $MyWheel = @Wheel_New("WheelAlias")
; $MyWheel.@Wheel_Update() # updates the wheel object
; $MyWheel.@Wheel_Accelerate(0.5) # sets the wheel's acceleration

; // Main

; Creates a new wheel object
; $alias: The alias for the wheel
function @Wheel_New($alias: text): text
	var $wheel = ""
	$wheel.Alias = $alias
	$wheel.RotationSpeed = 0
	$wheel.GroundFriction = 0

	return $wheel
	
; Updates a wheel object. This is to be called in `update`
; $self: The wheel object
function @Wheel_Update($self: text): text
	$self.RotationSpeed = input_number($self.Alias, 0)
	$self.GroundFriction = input_number($self.Alias, 1)
	
	return $self
	
; Sets the steering of a wheel
; $self: The wheel object
; $steer: The amount to steer, -1 to 1
function @Wheel_Steer($self: text, $steer: number): text
	output_number($self.Alias, 1, $steer)
	return $self
		
; Sets the gearbox of a wheel
; $self: The wheel object
; $gearbox: The gearbox value
function @Wheel_SetGearbox($self: text, $gearbox: number): text
	output_number($self.Alias, 4, $gearbox)
	return $self

; Sets the acceleration of a wheel
; $self: The wheel object
; $acceleration: The amount to accelerate, -1 to 1. Values below 0 = reverse
function @Wheel_Accelerate($self: text, $acceleration: number): text
	output_number($self.Alias, 0, $acceleration)
	return $self
	
; Sets the brakes of a wheel
; $self: The wheel object
; $brake: The amount to brake, 0 to 1
function @Wheel_Brake($self: text, $brake: number): text
	output_number($self.Alias, 3, $brake)
	return $self