; // ---------------------------------------------------------------------
; // ------- Timestamp
; // ---------------------------------------------------------------------

; // Variables
array $daysInMonth: number
array $daysInMonthLeapYear: number

; // Main
; Would be called in `init`, but stupid circular dependencies cockblocks that from happening
function @Utils_PopulateDaysArrays()
	; normal year
	if $daysInMonth.size == 0
		$daysInMonth.append(31)
		$daysInMonth.append(28)
		$daysInMonth.append(31)
		$daysInMonth.append(30)
		$daysInMonth.append(31)
		$daysInMonth.append(30)
		$daysInMonth.append(31)
		$daysInMonth.append(31)
		$daysInMonth.append(30)
		$daysInMonth.append(31)
		$daysInMonth.append(30)
		$daysInMonth.append(31)
	
	; leap year
	if $daysInMonthLeapYear.size == 0
		$daysInMonthLeapYear.append(31)
		$daysInMonthLeapYear.append(29)
		$daysInMonthLeapYear.append(31)
		$daysInMonthLeapYear.append(30)
		$daysInMonthLeapYear.append(31)
		$daysInMonthLeapYear.append(30)
		$daysInMonthLeapYear.append(31)
		$daysInMonthLeapYear.append(31)
		$daysInMonthLeapYear.append(30)
		$daysInMonthLeapYear.append(31)
		$daysInMonthLeapYear.append(30)
		$daysInMonthLeapYear.append(31)

; Returns if a year is a leap year
; $year: The year to check
function @Utils_IsLeapYear($year: number): number
	var $isLeap = ($year % 4 == 0 and $year % 100 != 0) or ($year % 400 == 0)
	return $isLeap
		
; Converts a unix timestamp to a formatted date
; $timestamp: The timestamp to convert
function @Utils_TimestampToDate($timestamp: number): text
	; Setup
	@Utils_PopulateDaysArrays()

	var $secondsInDay = 86400
	var $days = floor($timestamp / $secondsInDay)
	
	; Start from 1970
	var $year = 1970
	
	; Calculate current year
	while 1
		var $yearDays = 365 + @Utils_IsLeapYear($year)
		
		if $days < $yearDays
			break
			
		$days -= $yearDays
		$year++
		
	; Calculate current month
	var $month = 0 ; 0 = 1st month
	
	if @Utils_IsLeapYear($year)
		while $days >= $daysInMonth.$month
			$days -= $daysInMonth.$month
			$month++
	else
		while $days >= $daysInMonthLeapYear.$month
			$days -= $daysInMonthLeapYear.$month
			$month++
		
	; Format
	$month = $month + 1
	return text("{00}/{00}/{}", $days, $month, $year)