; // ---------------------------------------------------------------------
; // ------- Door
; // ---------------------------------------------------------------------

; // Main

; Creates a new door object
; $alias: The alias for the door pivot
; $dashboard: The alias for the door handle dashboard. This dashboard requires a switch button which will be used as the door open/closing switch
; $channel: The channel for the dashboard switch
; $pivotAngle: The angle the pivot should achieve when the door is opened
function @Door_New($alias: text, $dashboard: text, $channel: number, $pivotAngle: number): text
	var $door = ""
	$door.Pivot = $alias
	$door.Dashboard = $dashboard
	$door.Channel = $channel
	$door.Opened = 0
	$door.RequestOpen = 0
	$door.Locked = 0
	$door.PivotAngle = $pivotAngle

	return $door
	
; Updates this door object
; $self: The door object
function @Door_Update($self: text): text
	; Update opened
	$self.Opened = input_number($self.Dashboard, $self.Channel:number)
	
	; Update door pivot
	if $self.Opened != $self.RequestOpen and !$self.Locked
		output_number($self.Pivot, 0, $self.PivotAngle:number)
	else
		output_number($self.Pivot, 0, 0)

	; Return
	return $self
	
; Lock the door
; $self: The door object
; $lock: Whether or not to lock the door
function @Door_Lock($self: text, $lock: number): text
	$self.Locked = $lock
	return $self
	
; Open/close the door
; $self: The door object
; $open: Whether or not to open the door
function @Door_Open($self: text, $open: number): text
	$self.RequestOpen = $open
	return $self