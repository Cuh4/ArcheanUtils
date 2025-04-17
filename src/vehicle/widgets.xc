; // ---------------------------------------------------------------------
; // ------- Widgets
; // ---------------------------------------------------------------------

; // Main

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
	var $pressed = $screen.button_rect($x, $y, $x + $textWidth, $y + $screen.char_h, 0, $backgroundColor)
	
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