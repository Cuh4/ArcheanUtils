; // ---------------------------------------------------------------------
; // ------- Docking Port
; // ---------------------------------------------------------------------

; // Main

; Creates a new docking port object
; $alias: The alias for the docking port
function @DockingPort_New($alias: text): text
	var $dockingPort = ""
	$dockingPort.Alias = $alias
	$dockingPort.Docked = 0

	return $dockingPort
	
; Arm/Disarm the docking port
; $self: The docking port object
; $arm: Whether or not to arm the docking port
function @DockingPort_Arm($self: text, $arm: number): text
	output_number($self.Alias, 0, $arm)
	return $self
	
; Updates a docking port object. This is to be called in `update`
; $self: The docking port object
function @DockingPort_Update($self: text): text
	$self.Docked = input_number($self.Alias, 0)
	return $self