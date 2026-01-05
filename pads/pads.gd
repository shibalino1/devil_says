extends Area2D

var arrow_cursor = preload("res://assets/pointer/cursor.png")
var hand_cursor = preload("res://assets/pointer/hand.png")

signal pad_clicked(padID)

@export_range(1, 4) var padID : int = 1
@export_enum("green", "red", "yellow", "blue", "grey") var padBaseColor: String
@export var padSoundEffect: AudioStreamWAV

const PAD_COLORS := {
	"green": Color("14D76FFF"),
	"red": Color("FB452EFF"),
	"yellow": Color("F0D929FF"),
	"blue": Color("23A3E2FF"),
	"grey" : Color(0.501, 0.501, 0.501, 1.0)
}
var pad_sprites
var sound_player
var rot_deg_anim = 1
var anim_duration = 0.07
var lightened_amount = 0.4
var input_locked := false
var lock_duration := 0.12

func _ready() -> void:
	pad_sprites = $PadSprite
	sound_player = $PadSoundPLayer
	set_pad_base_sprite()

func get_pad_color(color):
	return PAD_COLORS.get(color)

func set_pad_base_sprite():
	self.modulate = get_pad_color(padBaseColor)

func set_pad_grey():
	padBaseColor = "grey"
	self.modulate = get_pad_color(padBaseColor)
	
func _on_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(hand_cursor)

func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(arrow_cursor)

func play_sound(sound):
	sound_player.stream = sound
	sound_player.play()

func animate_pad(color):
	play_sound(padSoundEffect)
	var shake = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC)
	shake.tween_property(pad_sprites, "rotation_degrees", rot_deg_anim, anim_duration)
	shake.tween_property(pad_sprites, "rotation_degrees", -rot_deg_anim, anim_duration)
	shake.tween_property(pad_sprites, "rotation_degrees", 0, 0.05)	
	var flash_color = get_pad_color(color).lightened(lightened_amount)
	var base_color = get_pad_color(color)
	var flash = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC)
	flash.tween_property(self, "modulate", flash_color, anim_duration)
	flash.tween_property(self, "modulate", base_color, anim_duration)

func animate_start_stop_pad(color):
	var shake = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC)
	shake.tween_property(pad_sprites, "rotation_degrees", rot_deg_anim, anim_duration)
	shake.tween_property(pad_sprites, "rotation_degrees", -rot_deg_anim, anim_duration)
	shake.tween_property(pad_sprites, "rotation_degrees", 0, 0.05)	
	var flash_color = get_pad_color(color).lightened(lightened_amount)
	var base_color = get_pad_color(color)
	var flash = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC)
	flash.tween_property(self, "modulate", flash_color, anim_duration)
	flash.tween_property(self, "modulate", base_color, anim_duration)	

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if input_locked:
		return

	if event is InputEventScreenTouch and event.pressed:
		_register_pad_click()

	elif event is InputEventMouseButton and event.pressed:
		_register_pad_click()

func _register_pad_click():
	input_locked = true
	pad_clicked.emit(padID)
	await get_tree().create_timer(lock_duration).timeout	
	input_locked = false
