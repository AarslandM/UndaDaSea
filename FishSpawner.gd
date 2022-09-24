extends Node

onready var fishes : Array = [
	preload("res://fish/Fish.tscn"), 
	preload("res://fish/Fish2.tscn"),
	preload("res://fish/Fish3.tscn"),
	preload("res://fish/Fish4.tscn"),
	preload("res://fish/Fish5.tscn"),
	preload("res://fish/Fish6.tscn"),
	preload("res://fish/Fish7.tscn"),
	preload("res://fish/Fish8.tscn"),]

func _spawn_fish():
	var index = randi() % fishes.size()
	var fish = fishes[index].instance()
	add_child(fish)
