extends RefCounted

class_name StateInterface

var state_machine : StateMachine

func enter(prev_state : String = "") -> void:
	pass

func exit() -> void:
	pass

func update(delta : float) -> void :
	pass

func on_start_clicked(event : InputEvent) -> void:
	pass
