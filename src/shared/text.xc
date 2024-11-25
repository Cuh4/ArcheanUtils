; // ---------------------------------------------------------------------
; // ------- Text
; // ---------------------------------------------------------------------

; // Main

; Returns whether or not a text starts with the provided prefix
; $text: The text to check
; $prefix: The prefix to check with
function @Text_StartsWith($text: text, $prefix: text): number
	return substring($text, 0, size($prefix)) == $prefix
	
; Returns whether or not a text ends with the provided suffix
; $text: The text to check
; $suffix: The suffix to check with
function @Text_EndsWith($text: text, $suffix: text): number
	return substring($text, size($text) - size($suffix), size($text)) == $suffix