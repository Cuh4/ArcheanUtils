; // ---------------------------------------------------------------------
; // ------- Nav Instrument
; // ---------------------------------------------------------------------

; // Main

; Creates a new nav instrument object
; $alias: The alias of the nav instrument
function @NavInstrument_New($alias: text): text
	var $navInstrument = ""
	$navInstrument.Alias = $alias
	$navInstrument.ForwardAirspeed = 0
	$navInstrument.VerticalSpeed = 0
	$navInstrument.Altitude = 0
	$navInstrument.AboveTerrain = 0
	$navInstrument.HorizonPitch = 0
	$navInstrument.HorizonRoll = 0
	$navInstrument.Heading = 0
	$navInstrument.Course = 0
	$navInstrument.Latitude = 0
	$navInstrument.Longitude = 0
	$navInstrument.GroundSpeed = 0
	$navInstrument.GroundSpeedForward = 0
	$navInstrument.GroundSpeedRight = 0
	$navInstrument.Celestial = ""
	$navInstrument.CelestialInnerRadius = 0
	$navInstrument.CelestialOuterRadius = 0
	$navInstrument.OrbitalSpeed = 0
	$navInstrument.Periapsis = 0
	$navInstrument.Apoapsis = 0
	$navInstrument.ProgradePitch = 0
	$navInstrument.ProgradeYaw = 0
	$navInstrument.RetrogradePitch = 0
	$navInstrument.RetrogradeYaw = 0
	$navInstrument.LocatorDistance = 0
	$navInstrument.LocatorPitch = 0
	$navInstrument.LocatorYaw = 0
	$navInstrument.OrbitalInclination = 0
	$navInstrument.OrbitTargetSpeed = 0
	$navInstrument.OrbitTargetAltitude = 0

	return $navInstrument

; Updates an nav instrument object
; $self: The nav instrument object
function @NavInstrument_Update($self: text): text
	$self.ForwardAirspeed = input_number($self.Alias, 0)
	$self.VerticalSpeed = input_number($self.Alias, 1)
	$self.Altitude = input_number($self.Alias, 2)
	$self.AboveTerrain = input_number($self.Alias, 3)
	$self.HorizonPitch = input_number($self.Alias, 4)
	$self.HorizonRoll = input_number($self.Alias, 5)
	$self.Heading = input_number($self.Alias, 6)
	$self.Course = input_number($self.Alias, 7)
	$self.Latitude = input_number($self.Alias, 8)
	$self.Longitude = input_number($self.Alias, 9)
	$self.GroundSpeed = input_number($self.Alias, 10)
	$self.GroundSpeedForward = input_number($self.Alias, 11)
	$self.GroundSpeedRight = input_number($self.Alias, 12)
	$self.Celestial = input_text($self.Alias, 13)
	$self.CelestialInnerRadius = input_number($self.Alias, 14)
	$self.CelestialOuterRadius = input_number($self.Alias, 15)
	$self.OrbitalSpeed = input_number($self.Alias, 16)
	$self.Periapsis = input_number($self.Alias, 17)
	$self.Apoapsis = input_number($self.Alias, 18)
	$self.ProgradePitch = input_number($self.Alias, 19)
	$self.ProgradeYaw = input_number($self.Alias, 20)
	$self.RetrogradePitch = input_number($self.Alias, 21)
	$self.RetrogradeYaw = input_number($self.Alias, 22)
	$self.LocatorDistance = input_number($self.Alias, 23)
	$self.LocatorPitch = input_number($self.Alias, 24)
	$self.LocatorYaw = input_number($self.Alias, 25)
	$self.OrbitalInclination = input_number($self.Alias, 26)
	$self.OrbitTargetSpeed = input_number($self.Alias, 27)
	$self.OrbitTargetAltitude = input_number($self.Alias, 28)
	
	return $self
	
; Set locate mode settings
; $self: The nav instrument object
; $celestial: The celestial to target
; $distance: The distance to the custom target
; $directionX: The direction X to custom target
; $directionY: The direction Y to custom target
; $directionZ: The direction Z to custom target
; $forwardVector: The forward vector config. 0 = forward, +1 = up, -1 = down
function @NavInstrument_SetLocate($self: text, $celestial: text, $distance: number, $directionX: number, $directionY: number, $directionZ: number, $forwardVector: number): text
	output_text($self.Alias, 0, $celestial)
	output_number($self.Alias, 1, $distance)
	output_number($self.Alias, 2, $directionX)
	output_number($self.Alias, 3, $directionY)
	output_number($self.Alias, 4, $directionZ)
	output_number($self.Alias, 5, $forwardVector)

	return $self