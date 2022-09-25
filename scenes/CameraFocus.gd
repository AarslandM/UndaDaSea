extends Node2D

func _ready():
	center()
	get_tree().create_timer(1).connect("timeout", self, "center")

func center():
	position = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)
