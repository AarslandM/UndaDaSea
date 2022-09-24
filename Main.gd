extends Node2D

onready var hook = $FishHook
onready var timed_event = preload("res://TimedEvent.gd")

func _ready():
	hook.connect("hooked", self, "hook_detected")

func hook_detected():
	print ("Ai!")
	var event_instance = timed_event.instance()
	add_child(event_instance)
	event_instance.connect("catched", self, "fish_got_catched")
	event_instance.connect("failed", self, "fish_got_away")

func fish_got_catched():
	print("Catched fish")
	hook.can_move_hook()
	
func fish_got_away():
	print("Failed to catch fish")
	hook.can_move_hook()
