extends StateInterface

class_name StopGameState

var main
var time
var timer

var did_start

var step_position
var sequence

var loose_sound = preload("res://assets/sounds/loose_sound.wav")

func enter(_prev_state : String = "") -> void:
	main = state_machine.main
	time = 0
	timer = main.start_stop_animation_next_step_wait_time
	main.clear_sequence()
	main.reset_timer_bar_size()
	main.reset_modifiers()
	main.reset_health_bar_size()
	main.reset_healt()
	did_start = false
	step_position = main.step_position
	sequence = main.sequence
	play_sound(loose_sound)

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
				state_machine.change_state(("idle"))
