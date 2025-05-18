; // ---------------------------------------------------------------------
; // ------- KVArray
; // ---------------------------------------------------------------------

; Example:
; var $array: text

; init
; 	$array = @KVArray_New()

; 	repeat 6($_)
; 		$array.@KVArray_Append(random(1, 100):text)
	
; 	foreach $array($index, $value)
; 		if @KVArray_IsIterationValid($index, $value)
; 			print("INDEX", @KVArray_ReverseConvert($index), "VALUE", $value)

; // Variables
var $arrayIndexPrefix = "_ArrayIndex"
var $arrayNullValue = ""

; // Main

; Creates a new array
function @KVArray_New(): text
	var $array = ""
	$array._Index = 0
	
	return $array
	
; Print an error
; $message: The error message
function @KVArray_Error($message: text)
	print("[ERROR] " & $message)
	
; Convert index to key-value index
; $index: The index
function @KVArray_ConvertIndex($index: number): text
	return $arrayIndexPrefix & $index:text
	
; Convert a converted index
; $convertedIndex: The index to convert back
function @KVArray_ReverseConvert($convertedIndex: text): number
	return substring($convertedIndex, size($arrayIndexPrefix), size($convertedIndex)):number
	
; Get next index in an array
; $self: The array
function @KVArray_GetNextIndex($self: text): number
	return $self._Index
	
; Get last index in an array
; $self: The array
function @KVArray_GetLastIndex($self: text): number
	return $self._Index - 1
	
; Returns the amount of values in an array
; $self: The array
function @KVArray_Count($self: text): number
	return $self._Index:number
	
; Returns whether or not an index and value is from an array (use during foreach)
; $index: The index to check
; $value: The value to check
function @KVArray_IsIterationValid($index: text, $value: text): number
	return substring($index, 0, size($arrayIndexPrefix)) == $arrayIndexPrefix and $value != $arrayNullValue
	
; Append a value to the array
; $self: The array
; $value: The value to append
function @KVArray_Append($self: text, $value: text): text
	; Append value
	var $index = @KVArray_ConvertIndex(@KVArray_GetNextIndex($self))
	$self.$index = $value
	
	; Increment index
	$self._Index++
	
	; Return
	return $self
	
; Get a value at an index
; $self: The array
; $index: The index
function @KVArray_Get($self: text, $index: number): text
	if $index < 0
		@KVArray_Error("@KVArray_Get: $index out of bounds (< 0)")
		return $self
	elseif $index > @KVArray_GetLastIndex($self)
		@KVArray_Error("@KVArray_Get: $index out of bounds")
		return $self

	var $valueIndex = @KVArray_ConvertIndex($index)
	return $self.$valueIndex
	
; Insert a value at an index in an array
; $self: The array
; $index: The index to insert the value at
; $value: The value to insert
function @KVArray_Insert($self: text, $index: number, $value: text): text
	if $index < 0
		@KVArray_Error("@KVArray_Insert: $index out of bounds (< 0)")
		return $self
	elseif $index > @KVArray_GetNextIndex($self) ; not using @KVArray_GetLastIndex() here so the user can insert a value at index 0 when there are no values in the array
		@KVArray_Error("@KVArray_Insert: $index out of bounds")
		return $self
		
	; Increment index
	if $index == 0
		$self._Index++
	
	; Shift all values up (start from top)
	var $max = @KVArray_GetLastIndex($self)

	if $max > $index
		var $at = $max + 1
		
		while $at > $index
			$at--

			var $indexToShift = @KVArray_ConvertIndex($at)
			var $preShiftValue = @KVArray_Get($self, $at)
			var $nextIndex = @KVArray_ConvertIndex($at + 1)

			$self.$indexToShift = $arrayNullValue
			$self.$nextIndex = $preShiftValue
			
	; Insert the value
	var $valueIndex = @KVArray_ConvertIndex($index)
	$self.$valueIndex = $value
	
	; Return
	return $self
	
; Pop a value at an index
; $self: The array
; $index: The index
function @KVArray_Pop($self: text, $index: number): text
	if $index < 0
		@KVArray_Error("@KVArray_Pop: $index out of bounds (< 0)")
		return $self
	elseif $index > @KVArray_GetLastIndex($self)
		@KVArray_Error("@KVArray_Pop: $index out of bounds")
		return $self
		
	; Remove the value
	if @KVArray_Get($self, $index) == $arrayNullValue
		@KVArray_Error("@KVArray_Pop: $index unused")
		return $self
	
	var $valueIndex = @KVArray_ConvertIndex($index)
	$self.$valueIndex = $arrayNullValue
	
	; Shift all values down
	var $max = @KVArray_GetLastIndex($self)

	if $max > $index
		var $at = $index
		
		while $at < $max
			$at++

			var $indexToShift = @KVArray_ConvertIndex($at)
			var $value = @KVArray_Get($self, $at)
			var $nextIndex = @KVArray_ConvertIndex($at - 1)

			$self.$indexToShift = $arrayNullValue
			$self.$nextIndex = $value
	
	; Return
	return $self