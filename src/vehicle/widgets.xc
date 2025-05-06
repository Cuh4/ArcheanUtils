; // ---------------------------------------------------------------------
; // ------- Widgets
; // ---------------------------------------------------------------------

; // Main

; Draws a burner on a stovetop
; $screen: The screen to draw on
; $x: The X coord to draw at
; $y: The Y coord to draw at
; $size: The size of the burner
; $active: Whether or not the burner is on
function @Widgets_StovetopBurner($screen: screen, $x: number, $y: number, $size: number, $active: number)
	$screen.draw_circle($x, $y, $size, 0, color(5, 5, 5))
	$screen.draw_circle($x, $y, $size - 2, 0, color(7, 7, 7))

	if $active
		$screen.draw_circle($x, $y, $size - 4, color(255, 100, 43), 0)
		
; Draws a fake stovetop. Yup. A fucking stovetop.
; This covers the entire screen and blanks it automatically, so you'll need a dedicated screen for this widget.
; $screen: The screen to draw on
; $tl: If top left burner is active
; $tr: If top right burner is active
; $bl: If bottom left burner is active
; $br: If bottom right burner is active
function @Widgets_Stovetop($screen: screen, $tl: number, $tr: number, $bl: number, $br: number)
	$screen.blank(color(0, 0, 0))

	var $quarterWidth = $screen.width / 4
	var $leftX = $quarterWidth
	var $rightX = $screen.width - $quarterWidth
	
	var $quarterHeight = $screen.height / 4
	var $topY = $quarterHeight
	var $bottomY = $screen.height - $quarterHeight
	
	var $size = (($quarterHeight + $quarterHeight) / 2)
	
	$screen.@Widgets_StovetopBurner($leftX, $topY, $size, $tl)
	$screen.@Widgets_StovetopBurner($rightX, $topY, $size, $tr)
	$screen.@Widgets_StovetopBurner($leftX, $bottomY, $size, $bl)
	$screen.@Widgets_StovetopBurner($rightX, $bottomY, $size, $br)

; Draws header text
; $screen: The screen to draw on
; $x: The X coord to draw at
; $y: The Y coord to draw at
; $backgroundColor: The background color to use
; $textColor: The text color to use
; $headerColor: The color of the "icon" before the text
; $text: The text to display
function @Widgets_HeaderText($screen: screen, $x: number, $y: number, $backgroundColor: number, $textColor: number, $headerColor: number, $text: text)
	$screen.draw_rect($x, $y, $x + 3, $y + $screen.char_h, 0, $headerColor)
	$screen.write($x + $screen.char_w, $y, $textColor, $text)
	
; Draws a rectangular status icon
; $screen: The screen to draw on
; $x: The X coord to draw at
; $y: The Y coord to draw at
; $width: The width of the widget
; $height: The height of the widget
; $backgroundColor: The background color to use
; $offColor: The color to show if status is 0
; $onColor: The color to show if status is 1
; $status: The status
function @Widgets_RectStatus($screen: screen, $x: number, $y: number, $width: number, $height: number, $backgroundColor: number, $offColor: number, $onColor: number, $status: number)
	$screen.draw_rect($x, $y, $x + $width, $y + $height, 0, $backgroundColor)
	
	var $color = 0
	
	if $status
		$color = $onColor
	else
		$color = $offColor
	
	$screen.draw_rect($x + 3, $y + 3, $x + $width - 3, $y + $height - 3, 0, $color)
	
; Draws a futuristic button, and returns if it is being pressed or not
; $screen: The screen to draw on
; $x: The X coord to draw at
; $y: The Y coord to draw at
; $backgroundColor: The background color to use
; $cornerColor: The corner color to use
; $textColor: The text color to use
; $text: The text to draw on the button
function @Widgets_FuturisticButton($screen: screen, $x: number, $y: number, $backgroundColor: number, $cornerColor: number, $textColor: number, $text: text): number
	var $textWidth = size($text) * $screen.char_w
	
	; Background
	var $pressed = $screen.button_rect($x - 1, $y - 1, $x + $textWidth + 1, $y + $screen.char_h + 1, 0, $backgroundColor)
	
	; Top left corner
	var $cornerLineHeight = 3
	var $cornerLineWidth = 35
	var $topLeftCornerX = $x - $cornerLineHeight - 2
	var $topLeftCornerY = $y - $cornerLineHeight - 2
	$screen.draw_rect($topLeftCornerX, $topLeftCornerY, $topLeftCornerX + $cornerLineWidth, $topLeftCornerY + $cornerLineHeight, 0, $cornerColor)
	$screen.draw_rect($topLeftCornerX, $topLeftCornerY + $cornerLineHeight, $topLeftCornerX + $cornerLineHeight, $topLeftCornerY + $cornerLineWidth / 3, 0, $cornerColor)
	
	; Bottom right corner
	var $bottomRightCornerX = $x + $textWidth + $cornerLineHeight + 2
	var $bottomRightCornerY = $y + $screen.char_h + $cornerLineHeight + 2
	$screen.draw_rect($bottomRightCornerX, $bottomRightCornerY, $bottomRightCornerX - $cornerLineWidth, $bottomRightCornerY - $cornerLineHeight, 0, $cornerColor)
	$screen.draw_rect($bottomRightCornerX, $bottomRightCornerY - $cornerLineHeight, $bottomRightCornerX - $cornerLineHeight, $bottomRightCornerY - $cornerLineWidth / 3, 0, $cornerColor)
	
	; Text
	$screen.write($x, $y, $textColor, $text)

	return $pressed
	
; Draws a vertical gradient
; $screen: The screen to draw to
; $x: The X coord to start at (origin: bottom left of gradient)
; $width: The width of the gradient
; $fromY: The Y coord to draw the gradient from
; $toY: The Y coord to draw the gradient up to
; $step: The amount of pixels to skip over per little gradient bar. Higher = less laggy but less detail
; $colorStart: The color to start with
; $colorEnd: The color to end with
function @Widgets_VerticalGradient($screen: screen, $x: number, $width: number, $fromY: number, $toY: number, $step: number, $colorStart: number, $colorEnd: number)
	var $colorStartR = color_r($colorStart)
	var $colorStartG = color_g($colorStart)
	var $colorStartB = color_b($colorStart)
	var $colorStartA = color_a($colorStart)
	
	var $colorEndR = color_r($colorEnd)
	var $colorEndG = color_g($colorEnd)
	var $colorEndB = color_b($colorEnd)
	var $colorEndA = color_a($colorEnd)
	
	var $_fromY = $fromY / $step
	var $_toY = $toY / $step

	for $_fromY, $_toY ($_y)
		var $progress = ($_y - $_fromY) / ($_toY - $_fromY)
		var $y = $_y * $step
		var $endY = $y + $step
		
		var $colorR = lerp($colorStartR, $colorEndR, $progress)
		var $colorG = lerp($colorStartG, $colorEndG, $progress)
		var $colorB = lerp($colorStartB, $colorEndB, $progress)
		var $colorA = lerp($colorStartA, $colorEndA, $progress)
		$screen.draw_rect($x, $y, $x + $width, $endY, 0, color($colorR, $colorG, $colorB, $colorA))
		
; Draws a futuristic screen background by drawing background tiles, fancy gradients and a small screen border.
; This can really look nice with the right colors and screen background.
; Blank the screen before using this, and you should really only draw this once if possible
; $screen: The screen to draw on
; $tileSize: The size of the individual background tiles. 50 is good
; $gradientStep: The amount of pixels between each gradient bar
; $gradientHeight: The height of the gradient, e.g: 25 pixels
; $gradientColorStart: The beginning color of the top and bottom gradients
; $gradientColorEnd: The end color of the top and bottom gradients
; $tileColor: The color of the background tiles
function @Widgets_FuturisticBackground($screen: screen, $tileSize: number, $gradientStep: number, $gradientHeight: number, $gradientColorStart: number, $gradientColorEnd: number, $tileColor: number)
	; Draw background tiles
	var $toX = $screen.width / $tileSize
	var $toY = $screen.height / $tileSize

	for 0, $toX ($x)
		for 0, $toY ($y)
			$screen.draw_rect($x * $tileSize, $y * $tileSize, $x * $tileSize + $tileSize, $y * $tileSize + $tileSize, $tileColor)
	
	; Gradients (top and bottom)
	$screen.@Widgets_VerticalGradient(0, $screen.width, 0, $gradientHeight, $gradientStep, $gradientColorStart, $gradientColorEnd)
	$screen.@Widgets_VerticalGradient(0, $screen.width, $screen.height, $screen.height - $gradientHeight, $gradientStep, $gradientColorStart, $gradientColorEnd)
	
	; Border
	$screen.draw_rect(0, 0, $screen.width, $screen.height, color(25, 25, 25), 0)
	
; Draws a horizontal slider-ish element (think throttle lever).
; Returns the user's input as -1 for value decrease, 0 for nothing, and 1 for value increase.
; $screen: The screen to draw on
; $x: The X coord to use
; $y: The Y coord to use
; $width: The width of this slider
; $height: The height of this slider
; $label: The text to display on the slider
; $backgroundColor: The color of the slider's background
; $progressColor: The color of the progress bar
; $buttonColor: The color of the buttons
; $textColor: The color of the label
; $value: The value of this slider (0 - 1)
function @Widgets_Slider($screen: screen, $x: number, $y: number, $width: number, $height: number, $label: text, $backgroundColor: number, $progressColor: number, $buttonColor: number, $textColor: number, $value: number): number
	; Background
	var $buttonGap = 4
	var $buttonOffset = $width / 6

	$screen.draw_rect($x + $buttonOffset + $buttonGap, $y, $x + $width - $buttonGap - $buttonOffset, $y + $height, 0, $backgroundColor)
	
	; Decrease button
	var $valueDown = $screen.button_rect($x, $y, $x + $buttonOffset - $buttonGap, $y + $height, 0, $buttonColor)
	$screen.write($x + 5, $y + $height / 2 - $screen.char_h / 2, $textColor, "<")
	
	; Increase button
	var $valueUp = $screen.button_rect($x + $width + $buttonGap, $y, ($x + $width) - $buttonOffset, $y + $height, 0, $buttonColor)
	$screen.write($x + $width - $screen.char_w - 5, $y + $height / 2 - $screen.char_h / 2, $textColor, ">")
	
	; Progress
	var $progressPadding = 3
	
	var $progressStartX = $x + $buttonOffset + $buttonGap + $progressPadding
	var $progressEndX = $x + $width - $buttonOffset - $buttonGap - $progressPadding
	var $progressDiff = $progressEndX - $progressStartX
	$screen.draw_rect($progressStartX, $y + 3, $progressStartX + ($progressDiff * $value), $y + $height - 3, 0, $progressColor)
	
	; Label
	$screen.write(($x + ($width / 2)) - (size($label) * $screen.char_w) / 2 , $y + ($height / 2) - ($screen.char_h / 2), $textColor, $label)
	
	; Return
	if $valueUp
		return 1
	elseif $valueDown
		return -1
	else
		return 0