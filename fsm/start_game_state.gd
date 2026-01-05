extends StateInterface

class_name StartGameState

var main
var time
var timer
var did_start
var step_position
var sequence

var welcome_sound = preload("res://assets/sounds/welcome_sound.wav")

func enter(_prev_state : String = "") -> void:
	main = state_machine.main
	time = 0
	timer = main.start_stop_animation_next_step_wait_time
	main.clear_sequence()
	main.reset_step_position()
	main.generate_initial_sequence()
	main.disable_simon_body()
	did_start = false
	step_position = main.step_position
	sequence = main.sequence
	play_sound(welcome_sound)

func play_sound(sound):
	main.play_sfx_sound(sound)

func update(delta : float) -> void:
	time += delta
	if not did_start:
		main.animate_start_stop()
		step_position +=1
		did_start = true

	if time >= timer:
		if step_position < sequence.size():
			main.animate_pad(sequence[step_position])
			step_position +=1
			time = 0
		if step_position >= sequence.size():
			if time >= 1:
				state_machine.change_state(("show_sequence"))
