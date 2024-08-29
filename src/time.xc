; // ---------------------------------------------------------------------
; // ------- Time
; // ---------------------------------------------------------------------

; // Variables

array $daysInMonth: number
array $daysInMonthLeapYear: number
array $monthNames: text

; // Main

; Populates numerous arrays
function @Time_PopulateArrays()
	; For a normal year
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
	
	; For a leap year
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
		
	; Month names
	if $monthNames.size == 0
		$monthNames.append("January")
		$monthNames.append("February")
		$monthNames.append("March")
		$monthNames.append("April")
		$monthNames.append("June")
		$monthNames.append("July")
		$monthNames.append("August")
		$monthNames.append("September")
		$monthNames.append("October")
		$monthNames.append("November")
		$monthNames.append("December")

; Returns if a year is a leap year
; $year: The year to check
function @Time_IsLeapYear($year: number): number
	var $isLeap = ($year % 4 == 0 and $year % 100 != 0) or ($year % 400 == 0)
	return $isLeap
		
; Converts a unix timestamp to a formatted date
; $timestamp: The timestamp to convert
function @Time_TimestampToDate($timestamp: number): text
	; Setup
	@Time_PopulateArrays()

	var $secondsInDay = 86400
	var $days = floor($timestamp / $secondsInDay)
	
	; Start from 1970
	var $year = 1970
	
	; Calculate current year
	while 1
		var $yearDays = 365 + @Time_IsLeapYear($year)
		
		if $days < $yearDays
			break
			
		$days -= $yearDays
		$year++
		
	; Calculate current month
	var $month = 0 ; 0 = 1st month
	
	if @Time_IsLeapYear($year)
		while $days >= $daysInMonth.$month
			$days -= $daysInMonth.$month
			$month++
	else
		while $days >= $daysInMonthLeapYear.$month
			$days -= $daysInMonthLeapYear.$month
			$month++
		
	; Plop into key-value pair
	var $data = ""
	$data.Day = $days
	$data.Month = $month + 1
	$data.Year = $year
	
	; Return
	return $data
	
; Converts a month (eg: 1) to its name (eg: "January")
; $month: The month to convert
function @Time_MonthToMonthName($month: number): text
	return $monthNames.$month