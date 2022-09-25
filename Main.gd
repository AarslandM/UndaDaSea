extends Node2D

signal finished_interact(success)

enum STATES {Idle, Hooking, Interacting}

onready var hook = $FishHook
onready var timed_event = $TimedEvent

var current_state : int = STATES.Idle

var current_fish : Fish = null
 
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
				current_fish.queue_free()
			else:
				hook.fail_event()
			current_state = STATES.Hooking
			hook.can_move = true

func _on_FishHook_hooked(fish):
	current_state = STATES.Interacting
	timed_event.start()
	hook.can_move = false
	current_fish = fish

func _on_TimedEvent_event_failed():
	hook.fail_event()
	hook.can_move = true
	current_state = STATES.Hooking
	timed_event.hide()
