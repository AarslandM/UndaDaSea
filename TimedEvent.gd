extends Node2D

signal event_failed

const VERTICAL_OFFSET = 40

var is_inside_inner : bool
onready var animator = $AnimationPlayer 

func start():
	show()	
	animator.play("Shrink")
	global_position = get_global_mouse_position()
	global_position.y -= VERTICAL_OFFSET
	
	var viewport = get_viewport().size
	
	global_position = Vector2(
		clamp(global_position.x, 20, viewport.x - 20),
		clamp(global_position.y, 20, viewport.y + 20)
	)
	
	is_inside_inner = false

func is_finished():
	emit_signal("event_failed")

func inside_inner():
	is_inside_inner = true

func interact() -> bool:
	hide()
	return is_inside_inner
