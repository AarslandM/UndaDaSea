extends Node2D

signal finished_interact(success)

enum STATES {Idle, Hooking, Interacting}

const CAMERA_SHAKE_AMOUNT : float = 0.5

onready var hook = $FishHook
onready var timed_event = $TimedEvent
onready var camera = $Camera
onready var ui = $Camera/Interface
onready var fish_spawner = $FishSpawner

var current_state : int = STATES.Idle
var current_fish : Fish = null

var next_bomb : int = Global.required_fish_for_bomb
var current_bomb_progress : int = 0
var has_bomb : bool = false # Fix bug where next bomb is getting updated even when player has bomb.
 
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
		current_bomb_progress = 0
		has_bomb = false
		ui.bomb_progress(current_bomb_progress)
		ui.bomb_visible(has_bomb)
		

func catch_successful():
	current_fish.queue_free()
	ui.add_to_score(1)
	current_state = STATES.Hooking
	hook.can_move = true
	current_bomb_progress += 1
	
	if current_bomb_progress < next_bomb:
		ui.bomb_progress(current_bomb_progress)
	elif current_bomb_progress == next_bomb:
		has_bomb = true
		ui.bomb_progress(current_bomb_progress)
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
	pass

func _on_Interface_died():
	fish_spawner.stop()
	hook.stop()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
