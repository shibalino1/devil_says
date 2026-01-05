extends Node2D

var state_machine : StateMachine

var simon_body

var simon_body_control
var padsDictionnary = {}

var sequence = []
var initial_steps = 1
var step_position

var speed_difficulty = 1
var initial_time = 5
var next_step_wait_time : float = 0.6 * speed_difficulty
var start_stop_animation_next_step_wait_time = 0.1
var timerExtender = speed_difficulty

var health_bar
var health :float = 100
var damage_amount = 25

var score

var level = 0
var next_level_range = 5

var sfx_player

var timer_bar
var score_label
var speed_up_label

var green_sound = preload("res://assets/sounds/green_sound.wav")
var red_sound = preload("res://assets/sounds/red_sound.wav")
var yellow_sound = preload("res://assets/sounds/yellow_sound.wav")
var blue_sound = preload("res://assets/sounds/blue_sound.wav")

var silent_sound = preload("res://assets/sounds/silence.wav")

var modifiers_scene

var is_modified = false
var modifier = null

var score_multiplier = 1

var UI
var eyes
var timer_bar_color = Color(0.027, 0.339, 0.488, 1.0)

func _ready() -> void:
	print(get_children())
	simon_body = $SimonBody
	simon_body_control = $SimonBody/SimonBodyControl
	UI = $UI
	timer_bar = $UI/TimerBarClip/TimerBar
	score_label = $UI/Score
	speed_up_label = $UI/SpeedUp
	health_bar = $UI/HealthBarClip/HealthBar
	
	timer_bar.modulate = timer_bar_color
	
	padsDictionnary = {
		1: $SimonBody/SimonBodyControl/GreenPad,
		2: $SimonBody/SimonBodyControl/RedPad,
		3: $SimonBody/SimonBodyControl/YellowPad,
		4: $SimonBody/SimonBodyControl/BluePad,
	}
	
	sfx_player = $ModifiersSoundPlayer
	
	state_machine = StateMachine.new()
	state_machine.main = self
	
	state_machine.add_state("idle", IdleState.new())
	state_machine.add_state("start_game", StartGameState.new())
	state_machine.add_state("show_sequence", ShowSequenceState.new())
	state_machine.add_state("player_turn", PLayerTurnState.new())
	state_machine.add_state("stop_game", StopGameState.new())
	state_machine.add_state("modifiers", ModifierState.new())
	
	state_machine.set_initial_state("idle")

func play_sfx_sound(sound):
	sfx_player.stream = sound
	sfx_player.play()

func _on_simon_body_start() -> void:
	state_machine.change_state("start_game")

func generate_random_number():
	return randi() % 1 + 1

func add_number_to_sequence(seq):
	seq.append(generate_random_number())

func generate_sequence(stepsNumber, seq):
	for s in range(stepsNumber):
		add_number_to_sequence(seq)

func generate_initial_sequence():
	generate_sequence(initial_steps, sequence)

func clear_sequence():
	sequence.clear()

func reset_step_position():
	step_position = 0

func reset_level():
	level = 0

func disable_click(pad):
	pad.input_pickable = false

func enable_click(pad):
	pad.input_pickable = true

func disable_pads():
	for i in padsDictionnary.values():
		disable_click(i)

func enable_pads():
	for i in padsDictionnary.values():
		enable_click(i)

func disable_simon_body():
	disable_click(simon_body)

func enable_simon_body():
	enable_click(simon_body)

func extend_timer(time_to_add):
	initial_time += time_to_add

func add_score():
	score = (score +1) * score_multiplier
	score_label.set_text("Score : " + str(score))

func increase_score_multiplier():
	if is_modified :
		score_multiplier += 1
		
func reset_score():
	score = 0
	score_label.set_text("Score : " + str(score))

func animate_pad(padID):
	var padToAnimate = padsDictionnary[padID]
	padToAnimate.animate_pad(padToAnimate.padBaseColor)

func animate_simon_body_wrong():
	simon_body.wrong_animation()

func animate_start_stop():
	simon_body.start_stop_animation(silent_sound)

func animate_timer_bar_size(timing):
	UI.reduce_timer_bar_animation(timing)

func reset_timer_bar_size():
	UI.reset_timer_bar()

func animate_health_bar():
	UI.animate_health_bar(health/100)

func reset_healt():
	health = 100

func reset_health_bar_size():
	UI.reset_health_bar()

func _on_pad_clicked(pad_id):
	state_machine.on_pad_clicked(pad_id)

func animate_healt_bar():
	UI.tween_shake_health_bar()

func add_step():
	reset_step_position()
	add_number_to_sequence(sequence)
	extend_timer(timerExtender)
	add_score()

func load_modifiers():
	var scene = preload("res://modifiers/modifiers.tscn")
	modifiers_scene = scene.instantiate()
	add_child(modifiers_scene)
	modifiers_scene.color_blind.connect(on_color_blind)
	modifiers_scene.deaf.connect(on_deaf)
	modifiers_scene.twist.connect(on_twist)

func kill_modifiers_scene():
	modifiers_scene.queue_free()

func on_speed_up():
	state_machine.on_speed_up()

func on_color_blind():
	state_machine.on_color_blind()
	
func on_deaf():
	state_machine.on_deaf()
	
func on_twist():
	state_machine.on_twist()

func rotate_simon():
	simon_body_control.rotate((45 * PI) / 180)

func reset_rotation():
	var tween = get_tree().create_tween()
	tween.tween_property(simon_body_control,  "rotation_degrees", 0, 0.05)

func blind_simon():
	for b in padsDictionnary:
		padsDictionnary[b].set_pad_grey()

func no_sound():
	for b in range(1, 5):
		padsDictionnary[b].padSoundEffect = silent_sound

func play_hit_animation():
	simon_body.play_hit_animation()

func reset_modifiers():
	state_machine.main.modifier = null
	state_machine.main.is_modified = false
	reset_rotation()
	padsDictionnary[1].padBaseColor = "green"
	padsDictionnary[2].padBaseColor = "red"
	padsDictionnary[3].padBaseColor = "yellow"
	padsDictionnary[4].padBaseColor = "blue"
	padsDictionnary[1].padSoundEffect = green_sound
	padsDictionnary[2].padSoundEffect = red_sound
	padsDictionnary[3].padSoundEffect = yellow_sound
	padsDictionnary[4].padSoundEffect = blue_sound
	for b in padsDictionnary:
		padsDictionnary[b].set_pad_base_sprite()

func reset_score_multiplier():
	score_multiplier = 1

func _process(delta: float) -> void:
	state_machine.update(delta)
