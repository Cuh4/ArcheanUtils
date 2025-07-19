; // ---------------------------------------------------------------------
; // ------- Text
; // ---------------------------------------------------------------------

; // Main

; Replaces all instances of `$target` in `$text` with `$to`
; $text: The text to check
; $target: The text to look for within the provided text
; $to: The text to replace the instances of `$target` with
function @Text_Replace($text: text, $target: text, $to: text): text
	var $new = ""
	var $textLength = size($text)
	var $targetLength = size($target)

	for 0, $textLength($i)
		var $str = substring($text, $i, $targetLength)
	
		if $str == $target
			$new &= $to
		else
			$new &= $str

	return $new

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


; Returns the index of the n-th occurrence of the given search string
; $text: The text to search
; $search: The given search string
; $n: The number that determines which occurrence we're looking for
function @Text_Get_Nth_Index_Of($text: text, $search: text, $n: number): number
	if $n == 0
		return 0
	var $index = 0
	while $index < size($text) && $n > 0
		if $text.$index != $search.0
			$index++
		else
			var $nextTextBlock = substring($text, $index, size($search))
			if $nextTextBlock == $search
				$n--
				if $n > 0
					$index += size($search)
	if $n > 0
		return -1
	else
		return $index


; Returns what is between the n-th and n+1-th occurrence of the $splitter string
; If the splitter is not contained at least n+1 times, "INVALID" is returned instead
; $text: The text that is being split
; $splitter: The split string
; $n: The number that determines which occurrence we're looking for

function @Text_Get_Nth_Split_Chunk($text: text, $splitter: text, $n: number): text
	if @Text_Count($text, $splitter) < $n
		return "INVALID"
	var $startIndex = @Text_Get_Nth_Index_Of($text, $splitter, $n)
	if $n > 0
		$startIndex++
	var $endIndex = @Text_Get_Nth_Index_Of($text, $splitter, $n+1) - 1

	if $startIndex < 0
		return "INVALID"

	return @Text_Substring($text, $startIndex, $endIndex)