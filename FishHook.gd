extends Area2D

signal hooked(fish)

var targets : Array = []

var can_move : bool = true

func _physics_process(_delta):
	if can_move:
		position = get_global_mouse_position()

func try_hook():
	if targets.size() != 0:
		if targets[0].get_overlapping_areas().find(self) != -1:
			emit_signal("hooked", targets[0])
			
func fail_event():
	pass
		
func _on_FishHook_area_entered(area):
	targets.append(area)

func _on_FishHook_area_exited(area):
	if targets.find(area) != -1:
		targets.remove(targets.find(area))
