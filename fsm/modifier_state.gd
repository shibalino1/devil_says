extends StateInterface

class_name  ModifierState

var twist_sound = preload("res://assets/sounds/twist_sound.wav")
var deaf_sound = preload("res://assets/sounds/deaf_sound.wav")
var blind_sound = preload("res://assets/sounds/blind_sound.wav")

var main

func enter(_prev_state : String = "") -> void:
	main = state_machine.main
	
	main.reset_modifiers()
	main.reset_timer_bar_size()
	main.load_modifiers()

func play_sound(sound):
	main.play_sfx_sound(sound)

func on_color_blind():
	play_sound(blind_sound)
	main.next_step_wait_time = main.next_step_wait_time - (main.next_step_wait_time * 0.05)
	main.modifier = "color_blind"
	main.is_modified = true
	main.increase_score_multiplier()
	state_machine.change_state("show_sequence")
	main.kill_modifiers_scene()

func on_deaf():
	play_sound(deaf_sound)
	main.modifier = "deaf"
	main.is_modified = true
	main.increase_score_multiplier()
	state_machine.change_state("show_sequence")
	main.kill_modifiers_scene()
	
func on_twist():
	play_sound(twist_sound)
	main.modifier = "twist"
	main.is_modified = true
	main.increase_score_multiplier()
	state_machine.change_state("show_sequence")
	main.kill_modifiers_scene()
