; // ---------------------------------------------------------------------
; // ------- Array
; // ---------------------------------------------------------------------

; Example:
; var $array: text

; init
; 	$array = @Array_New()

; 	repeat 6($_)
; 		$array.@Array_Append(random(1, 100):text)
	
; 	foreach $array($index, $value)
; 		if @Array_IsIterationValid($index, $value)
; 			print("INDEX", @Array_ReverseConvert($index), "VALUE", $value)

; // Variables
var $arrayIndexPrefix = "_ArrayIndex"
var $arrayNullValue = ""

; // Main

; Creates a new array
function @Array_New(): text
	var $array = ""
	$array._Index = 0
	
	return $array
	
; Print an error
; $message: The error message
function @Array_Error($message: text)
	print("[ERROR] " & $message)
	
; Convert index to key-value index
; $index: The index
function @Array_ConvertIndex($index: number): text
	return $arrayIndexPrefix & $index:text
	
; Convert a converted index
; $convertedIndex: The index to convert back
function @Array_ReverseConvert($convertedIndex: text): number
	return substring($convertedIndex, size($arrayIndexPrefix), size($convertedIndex)):number
	
; Get next index in an array
; $self: The array
function @Array_GetNextIndex($self: text): number
	return $self._Index
	
; Get last index in an array
; $self: The array
function @Array_GetLastIndex($self: text): number
	return $self._Index - 1
	
; Returns the amount of values in an array
; $self: The array
function @Array_Count($self: text): number
	return $self._Index:number
	
; Returns whether or not an index and value is from an array (use during foreach)
; $index: The index to check
; $value: The value to check
function @Array_IsIterationValid($index: text, $value: text): number
	return substring($index, 0, size($arrayIndexPrefix)) == $arrayIndexPrefix and $value != $arrayNullValue
	
; Append a value to the array
; $self: The array
; $value: The value to append
function @Array_Append($self: text, $value: text): text
	; Append value
	var $index = @Array_ConvertIndex(@Array_GetNextIndex($self))
	$self.$index = $value
	
	; Increment index
	$self._Index++
	
	; Return
	return $self
	
; Get a value at an index
; $self: The array
; $index: The index
function @Array_Get($self: text, $index: number): text
	if $index < 0
		@Array_Error("@Array_Get: $index out of bounds (< 0)")
		return $self
	elseif $index > @Array_GetLastIndex($self)
		@Array_Error("@Array_Get: $index out of bounds")
		return $self

	var $valueIndex = @Array_ConvertIndex($index)
	return $self.$valueIndex
	
; Insert a value at an index in an array
; $self: The array
; $index: The index to insert the value at
; $value: The value to insert
function @Array_Insert($self: text, $index: number, $value: text): text
	if $index < 0
		@Array_Error("@Array_Insert: $index out of bounds (< 0)")
		return $self
	elseif $index > @Array_GetNextIndex($self) ; not using @Array_GetLastIndex() here so the user can insert a value at index 0 when there are no values in the array
		@Array_Error("@Array_Insert: $index out of bounds")
		return $self
		
	; Increment index
	if $index == 0
		$self._Index++
	
	; Shift all values up (start from top)
	var $max = @Array_GetLastIndex($self)

	if $max > $index
		var $at = $max + 1
		
		while $at > $index
			$at--

			var $indexToShift = @Array_ConvertIndex($at)
			var $preShiftValue = @Array_Get($self, $at)
			var $nextIndex = @Array_ConvertIndex($at + 1)

			$self.$indexToShift = $arrayNullValue
			$self.$nextIndex = $preShiftValue
			
	; Insert the value
	var $valueIndex = @Array_ConvertIndex($index)
	$self.$valueIndex = $value
	
	; Return
	return $self
	
; Pop a value at an index
; $self: The array
; $index: The index
function @Array_Pop($self: text, $index: number): text
	if $index < 0
		@Array_Error("@Array_Pop: $index out of bounds (< 0)")
		return $self
	elseif $index > @Array_GetLastIndex($self)
		@Array_Error("@Array_Pop: $index out of bounds")
		return $self
		
	; Remove the value
	if @Array_Get($self, $index) == $arrayNullValue
		@Array_Error("@Array_Pop: $index unused")
		return $self
	
	var $valueIndex = @Array_ConvertIndex($index)
	$self.$valueIndex = $arrayNullValue
	
	; Shift all values down
	var $max = @Array_GetLastIndex($self)

	if $max > $index
		var $at = $index
		
		while $at < $max
			$at++

			var $indexToShift = @Array_ConvertIndex($at)
			var $value = @Array_Get($self, $at)
			var $nextIndex = @Array_ConvertIndex($at - 1)

			$self.$indexToShift = $arrayNullValue
			$self.$nextIndex = $value
	
	; Return
	return $self