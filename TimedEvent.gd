extends Node2D

signal catched
signal failed

var is_within_inner: bool = false

func _ready():
	$AnimationPlayer.play("Shrink")

func set_within(value):
	is_within_inner = value

func _input(event):
	if event.is_action_pressed("interact"): 
		if is_within_inner:
			emit_signal("catched")
		else:
			emit_signal("failed")
		queue_free()

func catch_failed():
	emit_signal("failed")
	queue_free()
