; // ---------------------------------------------------------------------
; // ------- Logging
; // ---------------------------------------------------------------------

; Example:
; var $Logger = @Logger_New("Name")
; $Logger.@Logger_SetName("Rocket")
; $Logger.@Logger_Success("This operation worked")
; $Logger.@Logger_Error("This operation didn't work")
; $Logger.@Logger_Info("Something is happening")
; $Logger.@Logger_Warning("Something didn't go as intended")

; // Main

; Creates a new logger
; $name: The name for the logger
function @Logger_New($name: text): text
	var $logger = ""
	$logger.Name = $name
	
	return $logger
	
; Set the name of a logger
; $self: The logger
; $name: The name of the logger
function @Logger_SetName($self: text, $name: text): text
	$self.Name = $name
	return $self
	
; Send a log
; $self: The logger
; $icon: The icon for the log to show severity
; $title: The title of the log
; $message: The message of the log
function @Logger_Log($self: text, $icon: text, $title: text, $message: text): text
	print(text("[{}] [{}] {}: {}", $self.Name, $icon, $title, $message))
	return $self
	
; Send a success message
; $self: The logger
; $title: The title of the log
; $message: The message of the log
function @Logger_Success($self: text, $title: text, $message: text): text
	$self.@Logger_Log(":)", $title, $message)
	return $self
	
; Send an info message
; $self: The logger
; $title: The title of the log
; $message: The message of the log
function @Logger_Info($self: text, $title: text, $message: text): text
	$self.@Logger_Log("?", $title, $message)
	return $self
	
; Send a warning message
; $self: The logger
; $title: The title of the log
; $message: The message of the log
function @Logger_Warning($self: text, $title: text, $message: text): text
	$self.@Logger_Log("!", $title, $message)
	return $self
	
; Send an error message
; $self: The logger
; $title: The title of the log
; $message: The message of the log
function @Logger_Error($self: text, $title: text, $message: text): text
	$self.@Logger_Log("!!!", $title, $message)
	return $self