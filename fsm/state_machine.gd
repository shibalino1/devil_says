extends RefCounted

class_name StateMachine

var states: Dictionary = {}
var current_state: StateInterface
var current_state_name: String = ""
var main

func add_state(name: String, state: StateInterface):
	states[name.to_lower()] = state
	state.state_machine = self

func set_initial_state(state_name: String) -> void:
	change_state(state_name)
	
func change_state(new_state_name: String) -> void:
	var prev_state_name = current_state_name
	if current_state:
		current_state.exit()
	
	current_state_name = new_state_name.to_lower()
	current_state = states.get(current_state_name)
	
	if current_state:
		current_state.enter(prev_state_name)

func on_start_clicked(event: InputEvent) -> void:
	if current_state:
		current_state.on_start_input(event)

func on_pad_clicked(pad_id):
	if current_state.has_method("on_pad_clicked"):
		current_state.on_pad_clicked(pad_id)

func on_speed_up():
	if current_state.has_method("on_speed_up"):
		current_state.on_speed_up()
		
func on_color_blind():
	if current_state.has_method("on_color_blind"):
		current_state.on_color_blind()
		
func on_deaf():
	if current_state.has_method("on_deaf"):
		current_state.on_deaf()
		
func on_twist():
	if current_state.has_method("on_twist"):
		current_state.on_twist()

func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)
