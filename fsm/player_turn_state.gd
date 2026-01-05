extends StateInterface

class_name PLayerTurnState

var main
var time
var timer

var sequence
var step_position

var level
var next_level_range

var health
var damage_amout

func enter(_prev_state : String = "") -> void:
	main = state_machine.main
	time = 0
	sequence = main.sequence
	timer = main.initial_time
	step_position = main.step_position
	main.enable_pads()
	main.animate_timer_bar_size(timer)
	level = main.level
	next_level_range = main.next_level_range
	
func on_pad_clicked(pad_id):
	if (step_position < sequence.size()):
		if (pad_id == sequence[step_position]):
			step_position +=1
			level +=1
			main.play_hit_animation()
			if (step_position == sequence.size()):
				main.add_step()
				if level % next_level_range != 0:
					if main.is_modified and main.modifier == "twist":
						main.rotate_simon()
					state_machine.change_state("show_sequence")
				if level % next_level_range == 0:
					state_machine.change_state("modifiers")
				else :
					state_machine.change_state("show_sequence")
			main.animate_pad(pad_id)
		else:			
			health = main.health
			damage_amout = main.damage_amount
			if health >0:
				main.animate_simon_body_wrong()
				main.reset_modifiers()
				health -= damage_amout
				main.reset_level()
				main.reset_score_multiplier()
				if health >0:
					main.health = health
					main.animate_health_bar()
					state_machine.change_state("show_sequence")
				else:
					state_machine.change_state("stop_game")

func update(delta : float) -> void:
	time += delta
	if time >= timer:
		state_machine.change_state("stop_game")
