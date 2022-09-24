extends Node2D

const VERTICAL_OFFSET = 40

signal catched
signal failed

var is_within_inner: bool = false

func _ready():
	$AnimationPlayer.play("Shrink")
	global_position = get_global_mouse_position()
	global_position.y -= VERTICAL_OFFSET
	
	var viewport = get_viewport().size
	
	global_position = Vector2(
		clamp(global_position.x, 20, viewport.x - 20),
		clamp(global_position.y, 20, viewport.y + 20)
	)
	
func set_within(value):
	is_within_inner = value

func _input(event):
	if event.is_action_pressed("interact"): 
		if is_within_inner:
			emit_signal("catched")
		else:
			emit_signal("failed")
		queue_free()

func catch_failed():
	emit_signal("failed")
	queue_free()
