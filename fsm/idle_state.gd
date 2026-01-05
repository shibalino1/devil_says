extends StateInterface

class_name IdleState

func enter(previous_state : String = "") -> void:
	state_machine.main.reset_score()
	state_machine.main.reset_level()
	state_machine.main.disable_pads()
	if previous_state == "stop_game":
		state_machine.main.enable_simon_body()

func on_start_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		state_machine.change_state("start_game")
		
	if event is InputEventScreenTouch and event.is_pressed():
		state_machine.change_state("start_game")
