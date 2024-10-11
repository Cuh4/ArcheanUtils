; // ---------------------------------------------------------------------
; // ------- Stalker
; // ---------------------------------------------------------------------

; Example
; var $stalker: text
; 
; init
; 	$stalker = @Stalker_New("Stalker", 8, 10000)
; 
; update
; 	$stalker.@Stalker_Stalk(1)
; 	$stalker.@Stalker_Update()
; 	
; timer interval 1
; 	var $targets = $stalker.Targets
; 
; 	foreach $targets($index, $target)
; 		print("---", text("[{00000}] {0.0}m away, found {0.0}s ago", $target.Frequency, $target.Distance, time - $target.FoundAt))

; // Main

; Creates a new target object representing a target found via a stalker
; $frequency: The frequency of the target
; $data: The data received at the time of finding
; $directionX: The direction X
; $directionY: The direction Y
; $directionZ: The direction Z
; $distance: The distance of the target
; $foundAt: The timestamp the target was found
function @Target_New($frequency: number, $data: text, $directionX: number, $directionY: number, $directionZ: number, $distance: number, $foundAt: number): text
	var $target = ""
	$target.Frequency = $frequency
	$target.Data = $data
	$target.DirectionX = $directionX
	$target.DirectionY = $directionY
	$target.DirectionZ = $directionZ
	$target.Distance = $distance
	$target.FoundAt = $foundAt
	
	return $target

; Creates a new stalker object for scanning for any in-use beacon frequencies
; $aliasPrefix: The prefix of the beacons to use for frequency scanning
; $beaconCount: The amount of beacons to use for frequency scanning
; $upTo: The frequency to stalk up to (recommended: 10000)
function @Stalker_New($aliasPrefix: text, $beaconCount: number, $upTo: number): text
	var $stalker = ""
	$stalker.AliasPrefix = $aliasPrefix
	$stalker.BeaconCount = $beaconCount
	$stalker.FrequencyChunkSize = $upTo / $beaconCount
	$stalker.At = 0
	$stalker.UpTo = $upTo
	$stalker.Stalking = 0
	$stalker.Targets = ""
	
	return $stalker
	
; Set whether or not to stalk
; $self: The stalker object
; $stalk: Whether or not to stalk
function @Stalker_Stalk($self: text, $stalk: number): text
	$self.Stalking = $stalk
	return $self
	
; Get target index via frequency
; $frequency: The frequency
function @Stalker_GetIndexViaFreq($frequency: number): text
	return "Freq" & $frequency:text
	
; Update this stalker object (scanning, etc)
; $self: The stalker object
function @Stalker_Update($self: text): text
	if !$self.Stalking
		return
		
	; Set targets as var
	var $targets = $self.Targets
		
	; Iterate through beacons
	var $beaconCount = $self.BeaconCount:number

	repeat $beaconCount($beaconIndex)
		; Get frequency for beacon the next tick
		var $nextFrequency = ($self.FrequencyChunkSize * $beaconIndex) + $self.At
		
		; Get frequency of current tick so we can read beacon properly
		var $previousFrequency = $nextFrequency - 1
		
		; Get alias of beacon
		var $alias = $self.AliasPrefix & $beaconIndex:text
		
		; Check for signal
		if input_number($alias, 5) and $previousFrequency != -1
			; Read beacon
			var $data = input_text($alias, 0)
			var $directionX = input_number($alias, 2)
			var $directionY = input_number($alias, 3)
			var $directionZ = input_number($alias, 4)
			var $distance = input_number($alias, 1)
			var $foundAt = time
			
			; Create target
			var $target = @Target_New($previousFrequency, $data, $directionX, $directionY, $directionZ, $distance, $foundAt) ; subtract 1 from frequency due to beacon tick update delay
			
			; Save target
			var $targetIndex = @Stalker_GetIndexViaFreq($previousFrequency)
			$targets.$targetIndex = $target
		
		; Set frequency for next tick
		output_number($alias, 2, $nextFrequency)
		
	; Increment frequency
	$self.At++
	
	if $self.At > $self.UpTo
		$self.At = 0
		
	; Update targets
	$self.Targets = $targets
	
	; Return
	return $self