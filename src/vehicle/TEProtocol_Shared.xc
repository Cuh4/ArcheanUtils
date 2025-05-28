; // ---------------------------------------------------------------------
; // ------- TEProtocol: Shared
; // ---------------------------------------------------------------------

; This file provides functions for both the client and server side of the TEProtocol.

; // Variables
var $TEPLogging = 1 ; Whether or not to send TEP logs to console. 0 or 1

; // Enums
var $TEP_LOG_LEVEL_ENUM = ".DEBUG{DEBUG}.ERROR{ERROR}.INFO{INFO}.WARNING{WARNING}"

; // Main

; Sends a log
; $side: What side the log is coming from (Client? Server?)
; $level: The log level (see $TEP_LOG_LEVEL_ENUM)
; $content: The log content
function @TEP_Log($side: text, $level: text, $content: text)
	if !$TEPLogging
		return
		
	var $formattedLog = text("Tick #{0} | {} | {} - {}", tick, $side, $level, $content)
	print($formattedLog)
	
; Generates and returns a unique ID
function @TEP_GetUUID(): text
	return "ID" & substring(round((random(1, 10000) * time * 10000)): text, 5, 100)
	
; Removes a value from a key-value pair
; $text: The key-value pair text
; $key: The key of the value to remove
function @TEP_RemoveValue($text: text, $key: text): text
	var $newKVP = ""
	
	foreach $text ($index, $value)
		if $index != $key
			$newKVP.$index = $value
			
	return $newKVP