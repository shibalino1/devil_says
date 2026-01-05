extends StateInterface

class_name  ShowSequenceState
var main
var did_start

var time
var timer

var sequence

var step_position

func enter(previous_state : String = ""):
	main = state_machine.main
	main.reset_timer_bar_size()
	timer = main.next_step_wait_time
	if previous_state == "start_game":
		did_start = false
	else:
		did_start = true
		
	if main.is_modified:
		if main.modifier == "color_blind" :
			main.blind_simon()
		if main.modifier == "deaf" :
			main.no_sound()
		if main.modifier == "twist" :
				main.rotate_simon()
			
	step_position = main.step_position
	time = 0
	sequence = main.sequence
	main.disable_pads()

func update(delta : float) -> void:
	time += delta
	if not did_start:
		main.animate_pad(sequence[0])
		step_position +=1
		did_start = true

	if time >= timer:
		if step_position < sequence.size():
			main.animate_pad(sequence[step_position])
			step_position +=1
			time = 0
			
		if step_position >= sequence.size():
			if time >= timer:
				state_machine.change_state("player_turn")
				time = 0
