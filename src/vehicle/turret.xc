; // ---------------------------------------------------------------------
; // ------- Turret
; // ---------------------------------------------------------------------

; Dependencies: shared/PID.xc, vehicle/nav-instrument.xc

; // Main

; Create a new turret
; $aliasPrefix: The prefix of all turret-related component aliases
; $invertAzimuth: Whether or not to invert the azimuth pivot
; $invertElevation: Whether or not to invert the elevation pivot
; $invertRestingAzimuth: Whether or not to invert the azimuth pivot when the turret goes to rest
; $invertRestingElevation: Whether or not to invert the elevation pivot when the turret goes to rest
; $restingAzimuthAngle: The resting angle for the turret's azimuth. 0.5 is normally good
; $restingElevationAngle: The resting angle for the turret's elevation. 0.5 is normally good
function @Turret_New($aliasPrefix: text, $invertAzimuth: number, $invertElevation: number, $invertRestingAzimuth: number, $invertRestingElevation: number, $restingAzimuthAngle: number, $restingElevationAngle: number): text
	var $turret = ""
	$turret.AliasPrefix = $aliasPrefix

	$turret.AzimuthAlias = $aliasPrefix & "_Azimuth"
	$turret.AzimuthPID = @PID_New(0.2, 0, 0.05, -1, 1)
	$turret.InvertAzimuth = $invertAzimuth
	$turret.InvertRestingAzimuth = $invertRestingAzimuth
	$turret.AzimuthRestingAngle = $restingAzimuthAngle

	$turret.ElevationAlias = $aliasPrefix & "_Elevation"
	$turret.ElevationPID = @PID_New(0.2, 0, 0.05, -1, 1)
	$turret.InvertElevation = $invertElevation
	$turret.InvertRestingElevation = $invertRestingElevation
	$turret.ElevationRestingAngle = $restingElevationAngle
	$turret.ElevLimitTop = 0.8 ; todo
	$turret.ElevLimitBottom = 0.04 ; todo
	
	$turret.RadarAlias = $aliasPrefix & "_Radar" ; actually a beacon
	
	$turret.NavInstrument = @NavInstrument_New($aliasPrefix & "_Nav")

	$turret.Enabled = 0
	$turret.Fire = 0
	$turret.Resting = 0
	$turret.TargetFreq = -1
	
	return $turret
	
; Toggle a turret
; $self: The turret to toggle on/off
; $on: Whether or not to turn the turret on
function @Turret_Toggle($self: text, $on: number): text
	$self.Enabled = $on
	return $self
	
; Make a turret fire
; $self: The turret object
; $fire: Whether or not to fire
function @Turret_Fire($self: text, $fire: number): text
	$self.Fire = $fire and !$self.Resting and $self.Enabled
	return $self
	
; Get the elevation of a turret
; $self: The turret object
function @Turret_GetElevation($self: text): number
	return input_number($self.ElevationAlias, 0)

; Get the azimuth of a turret
; $self: The turret object
function @Turret_GetAzimuth($self: text): number
	return input_number($self.AzimuthAlias, 0)

; Rotates the turret by however much provided
; $self: The turret object
; $azimuth: The amount to yaw
; $elevation: The amount to pitch
function @Turret_Rotate($self: text, $azimuth: number, $elevation: number): text
	output_number($self.AzimuthAlias, 0, if($self.InvertAzimuth, -$azimuth, $azimuth))
	output_number($self.ElevationAlias, 0, if($self.InvertElevation, -$elevation, $elevation))
	
	return $self

; Runs the elev PID and returns the value
; $self: The turret object
; $processVariable: The value to process
; $setPoint: The point to aim for
function @Turret_RunElevPID($self: text, $processVariable: number, $setPoint: number): number
	var $elevPID = $self.ElevationPID
	$elevPID.@PID_Update($processVariable, $setPoint)
	$self.ElevationPID = $elevPID
	
	return $elevPID.Value / 5
	
; Runs the azi PID and returns the value
; $self: The turret object
; $processVariable: The value to process
; $setPoint: The point to aim for
function @Turret_RunAziPID($self: text, $processVariable: number, $setPoint: number): number
	var $aziPID = $self.AzimuthPID
	$aziPID.@PID_Update($processVariable, $setPoint)
	$self.AzimuthPID = $aziPID
	
	return $aziPID.Value / 5

; Run a PID to reset turret elevation
; $self: The turret object
function @Turret_ElevationResetPID($self: text): number
	var $error = $self.ElevationRestingAngle - @Turret_GetElevation($self)
	var $value = @Turret_RunElevPID($self, $error, 0) * clamp(abs($error) * 200, 2, 500)
	
	if $self.InvertRestingElevation
		$value = -$value
	
	return $value

; Run a PID to reset turret azimuth
; $self: The turret object
function @Turret_AzimuthResetPID($self: text): number
	var $error = $self.AzimuthRestingAngle - @Turret_GetAzimuth($self)
	var $value = @Turret_RunAziPID($self, $error, 0) * clamp(abs($error) * 200, 2, 500)
	
	if $self.InvertRestingAzimuth
		$value = -$value
	
	return $value

; Sets the turret's target
; $self: The turret object
; $targetFreq: The target's beacon frequency
function @Turret_SetTarget($self: text, $targetFreq: number): text
	$self.TargetFreq = $targetFreq
	return $self

; Make a turret rest
; $self: The turret object
; $rest: Whether or not to rest
function @Turret_Rest($self: text, $rest: number): text
	$self.Resting = $rest or !$self.Enabled
	return $self
	
; Manage resting
; $self: The turret object
function @Turret_ManageResting($self: text): text
	if !$self.Resting
		return $self

	$self.@Turret_Rotate(@Turret_AzimuthResetPID($self), @Turret_ElevationResetPID($self))
	$self.@Turret_Fire(0)

	return $self
	
; Manage aiming at targets
; $self: The turret object
function @Turret_ManageAiming($self: text): text
	; Check if we're even getting a signal
	if !input_number($self.RadarAlias, 5)
		return $self
		
	; Check if turret is enabled
	if !$self.Enabled
		return $self

	; Calculate azimuth
	var $nav = $self.NavInstrument
	var $azimuth = @Turret_RunAziPID($self, -$nav.LocatorYaw, 0) * clamp(abs($nav.LocatorYaw) * 100, 100, 1000)

	; Calculate elevation
	var $elevation = @Turret_RunAziPID($self, $nav.LocatorPitch, 0) * clamp(abs($nav.LocatorPitch) * 100, 100, 1000)
	
	; Aim
	$self.@Turret_Rest(0)
	$self.@Turret_Rotate($azimuth, $elevation)
	
	; Fire
	if abs($nav.LocatorYaw) < 0.1 and abs($nav.LocatorPitch) < 0.1
		$self.@Turret_Fire(1)
	
	; Return
	return $self
	
; Update a turret (aims the turret, etc)
; $self: The turret object
function @Turret_Update($self: text): text
	; Update nav instrument
	var $nav = $self.NavInstrument
	$nav.@NavInstrument_Update()
	$nav.@NavInstrument_SetLocate("", input_number($self.RadarAlias, 1), input_number($self.RadarAlias, 2), input_number($self.RadarAlias, 3), input_number($self.RadarAlias, 4))

	$self.NavInstrument = $nav
	
	; Update beacon freq
	output_number($self.RadarAlias, 2, $self.TargetFreq:number)

	; Check if we're getting a signal
	if !input_number($self.RadarAlias, 5)
		$self.@Turret_Rest(1)

	; Check if turret is enabled
	if !$self.Enabled
		$self.@Turret_Rest(1)
	
	; Manage resting/aiming
	$self.@Turret_ManageResting()
	$self.@Turret_ManageAiming()

	; Return
	return $self