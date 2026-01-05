extends Node

var timer_bar
var health_bar

var tween_reduce_timer_bar
var tween_reduce_health_bar
var tween_shake_health_bar

func _ready() -> void:
	timer_bar = $TimerBarClip/TimerBar
	health_bar = $HealthBarClip/HealthBar

func reduce_timer_bar_animation(waitTime):
	tween_reduce_timer_bar = get_tree().create_tween()
	tween_reduce_timer_bar.tween_property(timer_bar, "scale:x", 0, waitTime)
	tween_reduce_timer_bar.parallel().tween_property(timer_bar, "modulate", Color(0.567, 0.082, 0.022, 1.0), (waitTime*0.5)).set_delay(waitTime * 0.45)

func reset_timer_bar():
	if tween_reduce_timer_bar:
		tween_reduce_timer_bar.kill()
	var tween_reset_timer_bar = get_tree().create_tween()
	tween_reset_timer_bar.tween_property(timer_bar, "scale:x", 1, 0.2)
	timer_bar.modulate = Color(0.027, 0.339, 0.488, 1.0)

	
func animate_health_bar(health_amount):
	var delay = 0.2
	if tween_reduce_health_bar:
		tween_reduce_health_bar.kill()
	tween_shake_health_bar =get_tree().create_tween()
	for shaking_pos in range(2) :
		tween_shake_health_bar.tween_property(health_bar,  "position:x", 2.5, 0.1).as_relative()
		tween_shake_health_bar.tween_property(health_bar,  "position:x", -5, 0.01).as_relative()
		tween_shake_health_bar.tween_property(health_bar,  "position:y", -2.5, 0.01).as_relative()
		tween_shake_health_bar.tween_property(health_bar,  "position:y", 5, 0.01).as_relative()
		tween_shake_health_bar.tween_property(health_bar,  "position:x", 2.5, 0.01).as_relative()
		tween_shake_health_bar.tween_property(health_bar,  "position:y", -2.5, 0.01).as_relative()
	tween_reduce_health_bar = get_tree().create_tween()
	tween_reduce_health_bar.tween_property(health_bar, "scale:x", health_amount, delay).set_delay(delay)

func reset_health_bar():
	#if tween_reduce_health_bar:
		#tween_reduce_health_bar.kill()
	var tween_reset_health_bar = get_tree().create_tween()
	tween_reset_health_bar.tween_property(health_bar, "scale:x", 0, 0.2)
	tween_reset_health_bar.tween_property(health_bar, "scale:x", 1, 0.01).set_delay(0.5)
	
	
	
