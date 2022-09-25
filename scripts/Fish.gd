extends Area2D
class_name Fish

signal escaped

const SPAWN_OFFSET : int = 50

export var speed : float = 200
export var flee_speed : float = 200
export var flee_duration : float = 1

var movement_direction : Vector2
var spawn_position : Vector2
var velocity : Vector2
var flee_direction : Vector2

var is_fleeing : bool = false
var can_move : bool = true

func _ready():
	var visibility_notifier = VisibilityNotifier2D.new()
	visibility_notifier.connect("screen_exited", self, "remove_fish")
	add_child(visibility_notifier)
	set_movement_and_spawn()
	
func remove_fish():
	if position.x < get_viewport().size.x + SPAWN_OFFSET && position.x > SPAWN_OFFSET:
		return
	emit_signal("escaped")
	queue_free()
	
func _physics_process(delta):
	if !can_move: return
	velocity = movement_direction * (speed + Global.speed)
	if is_fleeing:
		velocity += flee_direction * flee_speed
		
	position += velocity * delta
	
	var viewport = get_viewport().size
	position = Vector2 (
		clamp(position.x, -SPAWN_OFFSET * 2, viewport.x + SPAWN_OFFSET*2),
		clamp(position.y, SPAWN_OFFSET, viewport.y - SPAWN_OFFSET)
	)
	
func flee():
	randomize()
	var flipped = randi() % 2 == 0
	flee_direction = movement_direction.tangent()
	if flipped:
		flee_direction *= -1
	is_fleeing = true
	get_tree().create_timer(flee_duration).connect("timeout", self, "stop_fleeing")
	
func stop_fleeing():
	is_fleeing = false

func set_movement_and_spawn():
	randomize()
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
	

func stop():
	set_physics_process(false)
