; // ---------------------------------------------------------------------
; // ------- Seat
; // ---------------------------------------------------------------------

; Example:
; var $MySeat = @Seat_New("SeatAlias")
; $MySeat.@Seat_Update() ; update the seat object. required to read inputs

; // Main

; Creates a new seat object
; $alias: The alias of the seat
function @Seat_New($alias: text): text
	var $seat = ""
	$seat.Alias = $alias
	$seat.Occupied = 0
	$seat.BwFw = 0
	$seat.LfRi = 0
	$seat.DwUp = 0
	$seat.Pitch = 0
	$seat.Roll = 0
	$seat.Yaw = 0
	$seat.Thrust = 0

	$seat.Button1 = 0
	$seat.Button2 = 0
	$seat.Button3 = 0
	$seat.Button4 = 0
	$seat.Button5 = 0
	$seat.Button6 = 0
	$seat.Button7 = 0
	$seat.Button8 = 0
	$seat.Button9 = 0
	$seat.Button10 = 0

	return $seat

; Updates a seat object
; $self: The seat
function @Seat_Update($self: text): text
	$self.Occupied = input_number($self.Alias, 0)
	$self.BwFw = input_number($self.Alias, 1)
	$self.LfRi = input_number($self.Alias, 2)
	$self.DwUp = input_number($self.Alias, 3)
	$self.Pitch = input_number($self.Alias, 4)
	$self.Roll = input_number($self.Alias, 5)
	$self.Yaw = input_number($self.Alias, 6)
	$self.Thrust = input_number($self.Alias, 7)
	
	$self.Button1 = input_number($self.Alias, 1 + 7)
	$self.Button2 = input_number($self.Alias, 2 + 7)
	$self.Button3 = input_number($self.Alias, 3 + 7)
	$self.Button4 = input_number($self.Alias, 4 + 7)
	$self.Button5 = input_number($self.Alias, 5 + 7)
	$self.Button6 = input_number($self.Alias, 6 + 7)
	$self.Button7 = input_number($self.Alias, 7 + 7)
	$self.Button8 = input_number($self.Alias, 8 + 7)
	$self.Button9 = input_number($self.Alias, 9 + 7)
	$self.Button10 = input_number($self.Alias, 10 + 7)
	
	return $self