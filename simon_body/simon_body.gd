extends Area2D

var arrow = preload("res://assets/pointer/cursor.png")
var hand = preload("res://assets/pointer/hand.png")

@export var wrong_sound : AudioStreamWAV
@export var gameStartSoundEffect : AudioStreamWAV

var time = 0
var timer = 0
var original_color

var simon_body_sprite

var shake_pos_amount = 5
var rot_deg_anim = 1
var shake_anim_dur = 0.01
var rot_anim_dur = 0.07
var scale_anim_amount = 0.28

signal start
var eyes


func _ready() -> void:
	simon_body_sprite = $SimonBodySprite
	$SimonBodySprite.modulate = Color(0.47, 0.47, 0.47, 1.0)
	eyes = $Eyes
	eyes.play("idle")
	randomize_close_eyes()
	eyes.connect("animation_finished", Callable(self, "_on_eyes_animation_finished"))
	
func _on_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(hand)

func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(arrow)

func playSound(sound):
	$SimonBodySoundPLayer.stream = sound
	$SimonBodySoundPLayer.play()

func play_hit_animation():
	eyes.play("hit")

func _on_eyes_animation_finished():
	if eyes.animation == "hit":
		eyes.play("idle")

func start_stop_animation(sound):
	playSound(sound)
	var initial_scale = self.get_scale()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(scale_anim_amount, scale_anim_amount), rot_anim_dur)
	tween.tween_property(self, "scale", Vector2(initial_scale.x, initial_scale.y), shake_anim_dur)
	for r in range(2) :
		tween.tween_property(self,  "position:x", shake_pos_amount, shake_anim_dur).as_relative()
		tween.tween_property(self,  "position:x", -(shake_pos_amount * 2), shake_anim_dur).as_relative()
		tween.tween_property(self,  "position:y", -shake_pos_amount, shake_anim_dur).as_relative()
		tween.tween_property(self,  "position:y", shake_pos_amount * 2, shake_anim_dur).as_relative()
		tween.tween_property(self,  "position:x", shake_pos_amount, shake_anim_dur).as_relative()
		tween.tween_property(self,  "position:y", -shake_pos_amount, shake_anim_dur).as_relative()
		tween.tween_property(self,  "rotation_degrees", -rot_deg_anim, rot_anim_dur)
		tween.tween_property(self,  "rotation_degrees", (rot_deg_anim - rot_deg_anim), rot_anim_dur)
	

func wrong_animation():
	playSound(wrong_sound)
	var tween = get_tree().create_tween()
	for r in range(2) :
		tween.tween_property(self,  "position:x", shake_pos_amount, shake_anim_dur).as_relative()
		tween.tween_property(self,  "position:x", -(shake_pos_amount * 2), shake_anim_dur).as_relative()
		tween.tween_property(self,  "position:y", -shake_pos_amount, shake_anim_dur).as_relative()
		tween.tween_property(self,  "position:y", shake_pos_amount * 2, shake_anim_dur).as_relative()
		tween.tween_property(self,  "position:x", shake_pos_amount, shake_anim_dur).as_relative()
		tween.tween_property(self,  "position:y", -shake_pos_amount, shake_anim_dur).as_relative()
		tween.tween_property(self,  "rotation_degrees", -rot_deg_anim, rot_anim_dur)
		tween.tween_property(self,  "rotation_degrees", (rot_deg_anim - rot_deg_anim), rot_anim_dur)
	
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed():
		start.emit()
func randomize_close_eyes():
	timer = randi_range(8, 16)

func _process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	var center = Vector2(326, 448)
	var radius =  40
	var offset = mouse - center
	if offset.length() > radius:
		offset = offset.normalized() * radius
	eyes.global_position = center + offset
	
	time += delta
	if time >= timer:
		eyes.play("close")
		time = 0
		randomize_close_eyes()
