extends Node2D

onready var hook = $FishHook
onready var timed_event: PackedScene = preload("res://TimedEvent.tscn")

func _ready():
	hook.connect("hooked", self, "hook_detected")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func hook_detected():
	print ("Ai! Hook detected")
	var event_instance = timed_event.instance()
	add_child(event_instance)
	event_instance.connect("catched", self, "fish_got_catched")
	event_instance.connect("failed", self, "fish_got_away")

func fish_got_catched():
	print("Catched fish")
	hook._enable_movement()
	hook._enable_click()
	
func fish_got_away():
	print("Failed to catch fish")
	hook._enable_movement()
	hook._enable_click()
