; // ---------------------------------------------------------------------
; // ------- Tertiary
; // ---------------------------------------------------------------------

; // Main

; A function that serves the same purpose as a tertiary operator (numbers only)
; $condition: 0 or 1
; $off: The number to return if $condition is 0
; $on: The number to return if $condition is 1
function @Tertiary_Number($condition: number, $off: number, $on: number): number
	if $condition
		return $on

	return $off

; A function that serves the same purpose as a tertiary operator (text only)
; $condition: 0 or 1
; $off: The text to return if $condition is 0
; $on: The text to return if $condition is 1
function @Tertiary_Number($condition: number, $off: text, $on: text): text
	if $condition
		return $on

	return $off