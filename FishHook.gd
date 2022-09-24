extends Area2D

signal hooked

var can_click: bool = false
var can_move_hook: bool = true

func _physics_process(_delta):
	if can_move_hook:
		position = get_global_mouse_position()

func _on_FishHook_area_entered(area):
	can_click = true
	
func _enable_movement():
	can_move_hook = true

func _on_FishHook_area_exited(area):
	can_click = false

func _unhandled_input(event):
	if event.is_action_pressed("interact") and can_click:
		can_move_hook = false
		emit_signal("hooked")
#		print ("Oh weee!")
