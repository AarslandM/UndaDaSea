extends Area2D
class_name Fish

const SPAWN_OFFSET : int = 50

export var speed : float = 50

var movement_direction : Vector2
var spawn_position : Vector2
var velocity : Vector2

func _ready():
	randomize()
	set_movement_and_spawn()
	
func _physics_process(delta):
	velocity = movement_direction * (speed + Global.speed) 
	position += velocity * delta
	
func set_movement_and_spawn():
	var is_moving_left : bool = randi() % 2 == 0
	var viewport = get_viewport().size
	if is_moving_left:
		$Sprite.flip_h = true
		movement_direction = Vector2.LEFT
		spawn_position = Vector2(
			viewport.x + SPAWN_OFFSET,
			clamp(randi() % int(viewport.y), SPAWN_OFFSET, viewport.y - SPAWN_OFFSET)
		)
	else:
		movement_direction = Vector2.RIGHT
		spawn_position = Vector2(
			-SPAWN_OFFSET,
			clamp(randi() % int(viewport.y), SPAWN_OFFSET, viewport.y - SPAWN_OFFSET)
		)
		
	global_position = spawn_position
	
