; // ---------------------------------------------------------------------
; // ------- Light
; // ---------------------------------------------------------------------

; Example:
; var $MyLight = @Light_New("LightAlias")
; $MyLight.@Light_Toggle(0) # turn off
; $MyLight.@Light_SetColor(255, 0, 0) # set color to red

; // Main

; Creates a new light object
; $alias: The alias for the lamp/spotlight
function @Light_New($alias: text): text
	var $light = ""
	$light.Alias = $alias

	return $light
	
; Turns on/off the lamp/spotlight behind the light object
; $self: The light object
; $on: Whether or not to turn on the light
function @Light_Toggle($self: text, $on: number): text
	output_number($self.Alias, 0, $on)
	return $self

; Sets the light's color
; $self: The light object
; $R: (R)GB
; $G: R(G)B
; $B: RG(B)
function @Light_SetColor($self: text, $R: number, $G: number, $B: number): text
	output_number($self.Alias, 1, $R)
	output_number($self.Alias, 2, $G)
	output_number($self.Alias, 3, $B)

	return $self