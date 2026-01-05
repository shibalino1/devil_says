extends Node2D

var arrow_cursor = preload("res://assets/pointer/cursor.png")
var hand_cursor = preload("res://assets/pointer/hand.png")


signal color_blind
signal deaf
signal twist

var twist_card
var deaf_card
var blind_card

var cards_size

func _ready() -> void:
	twist_card = $Twist
	deaf_card = $Deaf
	blind_card = $ColorBlind
	
	wooble_cards(blind_card, 0.02, false)
	wooble_cards(deaf_card, 0.01, true)
	wooble_cards(twist_card, 0.02,  true)


func wooble_cards(node, start, inv):
	var tween_wooble
	var speed
	
	if tween_wooble:
		tween_wooble.kill()
	if not inv:
		start = start
		speed = 2
	if inv:
		start = - start
		speed = 1.7
	tween_wooble = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween_wooble.tween_property(node, "rotation", start, speed)
	tween_wooble.tween_property(node, "rotation", - start, speed)



func on_color_blind(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.pressed:
		color_blind.emit()
		
	if event is InputEventMouseButton and event.is_pressed():
		color_blind.emit()

func on_deaf(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		deaf.emit()
		
	if event is InputEventScreenTouch and event.pressed:
		deaf.emit()

func on_twist(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		twist.emit()
	
	if event is InputEventScreenTouch and event.pressed:
		twist.emit()
	
func on_mouse_enter_tween(node):
	Input.set_custom_mouse_cursor(hand_cursor)
	var tween
	cards_size = node.get_scale()
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(node, "scale", Vector2(0.8, 0.8), 0.2)

func on_mouse_exit_tween(node):
	Input.set_custom_mouse_cursor(arrow_cursor)
	var tween	
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(node, "scale", Vector2(cards_size), 0.2)

func _on_twist_mouse_entered() -> void:
	on_mouse_enter_tween(twist_card)

func _on_twist_mouse_exited() -> void:
	on_mouse_exit_tween(twist_card)

func _on_deaf_mouse_entered() -> void:
	on_mouse_enter_tween(deaf_card)

func _on_deaf_mouse_exited() -> void:
	on_mouse_exit_tween(deaf_card)

func _on_color_blind_mouse_entered() -> void:
	on_mouse_enter_tween(blind_card)

func _on_color_blind_mouse_exited() -> void:
	on_mouse_exit_tween(blind_card)
