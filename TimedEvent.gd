extends Node2D

signal catched
signal failed

var can_interact: bool = false
var catch_started: bool = false

func set_input(value):
	can_interact = value
	
func start_catch():
	catch_started = true

func _unhandled_input(event):
	if event.is_action_pressed("interact") && catch_started: 
		if can_interact:
			emit_signal("catched")
		else:
			emit_signal("failed")
		catch_started = false
