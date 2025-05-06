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
	
; Counts the number of times `$target` is in `$text`
; $text: The text to check
; $target: The text to search and count in $text
function @Text_Count($text: text, $target: text): number
	var $targetLength = size($target)
	var $textLength = size($text)
	var $count = 0
	
	for 0, $textLength($i)
		var $str = substring($text, $i, $targetLength)
	
		if $str == $target
			$count++
			
	return $count
	
; Built-in substring(), but takes a start and an end argument instead of a start and a length
; and also returns the result.
; $text: The text to check
; $start: The start index (0 = first character)
; $end: The end index
function @Text_Substring($text: text, $start: number, $end: number): text
	return substring($text, $start, $end - $start + 1)
	
; Truncates text and adds something on the end to imply it has been truncated (e.g: "...")
; $text: The text to truncate
; $limit: The character limit (the length of $ending is subtracted from this)
; $ending: The suffix to add if the limit is reached and the text is truncated
function @Text_Truncate($text: text, $limit: number, $ending: text): text
	var $trueLimit = $limit - size($ending)

	if size($text) > $trueLimit
		return substring($text, 0, $trueLimit) & $ending
		
	return $text