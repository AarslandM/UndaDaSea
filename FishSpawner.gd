extends Node

onready var fishes : Array = [preload("res://Fish.tscn")]

func _spawn_fish():
	var index = randi() % fishes.size()
	var fish = fishes[index].instance()
	add_child(fish)
