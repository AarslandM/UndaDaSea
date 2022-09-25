extends Node2D

signal finished_interact(success)

enum STATES {Idle, Hooking, Interacting}

const CAMERA_SHAKE_AMOUNT : float = 0.5
const BOMB_SCORE_AMOUNT : int = 5

onready var hook = $FishHook
onready var timed_event = $TimedEvent
onready var camera = $Camera
onready var ui = $UI
onready var fish_spawner = $FishSpawner

var current_state : int = STATES.Idle
var current_fish : Fish = null

var next_bomb : int = BOMB_SCORE_AMOUNT
var has_bomb : bool = false
 
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	current_state = STATES.Hooking
	
func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if current_state == STATES.Hooking:
			hook.try_hook()
		elif current_state == STATES.Interacting:
			var successful_catch = timed_event.interact()
			emit_signal("finished_interact", successful_catch)
			if successful_catch:
				catch_successful()
			else:
				catch_failed()
	elif event.is_action_pressed("explode") && has_bomb && current_state == STATES.Hooking:
		hook.explode()
		camera.add_trauma(CAMERA_SHAKE_AMOUNT)
		has_bomb = false
		ui.bomb_visible(has_bomb)
		

func catch_successful():
	current_fish.queue_free()
	next_bomb -= 1
	ui.add_to_score(1)
	current_state = STATES.Hooking
	hook.can_move = true
	if (next_bomb <= 0):
		has_bomb = true
		next_bomb = BOMB_SCORE_AMOUNT
		ui.bomb_visible(has_bomb)

func catch_failed():
	current_fish.can_move = true
	camera.add_trauma(CAMERA_SHAKE_AMOUNT)
	hook.fail_event()
	hook.can_move = true
	current_state = STATES.Hooking
	
func fish_escaped():
	ui.remove_health()

func _on_FishHook_hooked(fish):
	current_state = STATES.Interacting
	fish.can_move = false
	timed_event.start()
	hook.can_move = false
	current_fish = fish

func _on_TimedEvent_event_failed():
	catch_failed()
	timed_event.hide()

func _on_FishHook_exploded(amount_of_fish):
	ui.add_to_score(amount_of_fish)

func _game_over():
	# Pause game
	fish_spawner.stop()
	hook.stop()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Show game over screen
	pass # Replace with function body.
