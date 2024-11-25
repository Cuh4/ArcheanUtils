; // ---------------------------------------------------------------------
; // ------- Thruster
; // ---------------------------------------------------------------------

; Example:
; var $Thruster = @Thruster_New("ThrusterAlias")
; $Thruster.@Thruster_Ignite(1)
; $Thruster.@Thruster_SetGimbal(0.7, 0.2)
; print($Thruster.BurnedFlow)

; // Main

; Creates a new thruster object
; $alias: The thruster alias
function @Thruster_New($alias: text): text
	var $thruster = ""
	$thruster.Alias = $alias
	$thruster.Thrust = 0
	$thruster.BurnedFlow = 0
	$thruster.UnburnedFlow = 0

	return $thruster
	
; Updates a thruster object. This is to be called in `update`
; $self: The thruster object
function @Thruster_Update($self: text): text
	$self.Thrust = input_number($self.Alias, 0)
	$self.BurnedFlow = input_number($self.Alias, 1)
	$self.UnburnedFlow = input_number($self.Alias, 2)
	
	return $self

; Ignites a thruster
; $self: The thruster to ignite
; $ignition: The amount to ignite, 0-1
function @Thruster_Ignite($self: text, $ignition: number): text
	output_number($self.Alias, 0, $ignition)
	return $self

; Sets a thruster's gimbal
; $self: The thruster to ignite
; $x: Gimbal X, -1 to 1
; $z: Gimbal Z -1 to 1
function @Thruster_SetGimbal($self: text, $x: number, $z: number): text
	output_number($self.Alias, 1, $x)
	output_number($self.Alias, 2, $z)
	return $self