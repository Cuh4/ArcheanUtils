; // ---------------------------------------------------------------------
; // ------- Beacon Locator
; // ---------------------------------------------------------------------

; // Main

; Create a new beacon locator object
; $dashboard: The dashboard object
; $toggleButtonChannel: The channel for the switch that toggles the beacon locator
function @BeaconLocator_New($dashboard: text, $toggleButtonChannel: number): text
	var $beaconLocator = ""
	$beaconLocator.Dashboard = $dashboard
	$beaconLocator.ToggleButtonChannel = $toggleButtonChannel
	$beaconLocator.BackgroundColor = color(0, 0, 0, 0) ; transparent
	$beaconLocator.On = 1
	
	return $beaconLocator
	
; Set whether or not the beacon locator is enabled
; $self: The beacon locator object
; $on: Whether or not to enable the beacon locator
function @BeaconLocator_Toggle($self: text, $on: number): text
	$self.On = $on
	return $self

; Update this beacon locator object
; $self: The beacon locator object
function @BeaconLocator_Update($self: text): text
	$self.@BeaconLocator_Toggle(@Dashboard_IsPressed($self.Dashboard, $self.ToggleButtonChannel))
	return $self
	
; Set the beacon locator background color
; $self: The beacon locator object
; $color: The background color
function @BeaconLocator_SetBGColor($self: text, $color: number): text
	$self.BackgroundColor = $color
	return $self
	
; Write centered text
; $screen: The screen to write on
; $x: The X position
; $y: The Y position
; $color: The color of the text
; $text: The text to show
function @BeaconLocator_RenderCenteredText($screen: screen, $x: number, $y: number, $color: number, $text: text)
	var $textWidthHalf = size($text) * $screen.char_w / 2
	$screen.write($x - $textWidthHalf, $y - $screen.char_h / 2, $color, $text)
	
; Draw a crosshair on the center of the screen
; $screen: The screen to draw on
; $crosshairSize: The size of the crosshair in pixels
; $crosshairColor: The color of the crosshair
function @BeaconLocator_RenderCrosshair($screen: screen, $crosshairSize: number, $crosshairColor: number)
	$screen.draw_line($screen.width / 2 - $crosshairSize * 1.5, $screen.height / 2 - $crosshairSize, $screen.width / 2 - $crosshairSize * 1.5, $screen.height / 2 + $crosshairSize, $crosshairColor)
	$screen.draw_line($screen.width / 2 + $crosshairSize * 1.5, $screen.height / 2 - $crosshairSize, $screen.width / 2 + $crosshairSize * 1.5, $screen.height / 2 + $crosshairSize, $crosshairColor)
	$screen.draw_circle($screen.width / 2, $screen.height / 2, $crosshairSize, $crosshairColor)

; Returns a formatted distance
; $distance: The distance in meters
function @BeaconLocator_FormatDistance($distance: number): text
	if $distance < 1000
		return text("{0.0}m", $distance)
	else
		return text("{0.0}km", $distance / 1000)
	
; Render the beacon locator
; $self: The beacon locator object
; $screen: The screen to render on
; $beacon: The beacon to render for
function @BeaconLocator_Render($self: text, $screen: screen, $beacon: text): text
	; Background
	$screen.blank($self.BackgroundColor:number)
	
	; Color
	var $color = color(45, 45, 65)
	var $isFacingWrongDirection = $beacon.DirectionZ > 0

	if $isFacingWrongDirection > 0
		$color = color(75, 25, 25)

	; Don't render if not on
	if !$self.On
		return $self
	
	; Beacon location circle
	var $multiplier = 100
	
	var $circleX = $screen.width / 2
	$circleX += ($beacon.DirectionX * 500)
	
	var $circleY = $screen.height / 2
	$circleY -= ($beacon.DirectionY * 500) + 70
	
	var $radius = 10
	$radius = clamp($radius + $beacon.Distance / 125, 25, 45)

	$screen.draw_circle($circleX, $circleY, $radius, $color)
	
	; Direction line
	$screen.draw_line($screen.width / 2, $screen.height / 2, $circleX, $circleY, color(100, 100, 125))
	$screen.draw_rect($circleX - 3, $circleY - 3, $circleX + 3, $circleY + 3, 0, color(100, 100, 125))
	
	; Show distance
	var $distanceTextY = $circleY + $radius + $screen.char_h + 4
	$screen.@BeaconLocator_RenderCenteredText($circleX, $distanceTextY, white, @BeaconLocator_FormatDistance($beacon.Distance))
		
	if $isFacingWrongDirection
		$screen.@BeaconLocator_RenderCenteredText($circleX, $distanceTextY + $screen.char_h + 5, color(75, 25, 25), "Wrong Way!")
	
	; Show "crosshair"
	$screen.@BeaconLocator_RenderCrosshair(6, color(45, 45, 50))

	; If no signal, stop here
	if !$beacon.IsReceiving
		$screen.blank(0)
	
		$screen.text_size(3)
		$screen.@BeaconLocator_RenderCenteredText($screen.width / 2, $screen.height / 2, color(75, 65, 65), "No signal!")

		$screen.text_size(1)
		$screen.@BeaconLocator_RenderCenteredText($screen.width / 2, $screen.height / 2 + 17, white, "Ensure the receiving frequency is correct")
		
		$screen.@BeaconLocator_RenderCenteredText($screen.width / 2, $screen.height / 2 + 27, color(65, 65, 75), text("Freq: {}", $beacon.ReceiveFrequency))

	; Show title
	var $titleHeight = 16
	$screen.draw_rect(80, 0, $screen.width - 80, $titleHeight, 0, color(5, 5, 5, 150))
	$screen.@BeaconLocator_RenderCenteredText($screen.width / 2, $titleHeight / 2, white, "Beacon Locator")

	; Return
	return $self