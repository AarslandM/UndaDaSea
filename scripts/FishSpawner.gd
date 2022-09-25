extends Node

const FINAL_SPAWN_DELAY = 0.2
const SPAWN_REDUCTION = 0.01

var spawn_delay = 1.2

onready var timer = $SpawnTimer

onready var fishes : Array = [
	preload("res://fish/Fish.tscn"), 
	preload("res://fish/Fish2.tscn"),
	preload("res://fish/Fish3.tscn"),
	preload("res://fish/Fish4.tscn"),
	preload("res://fish/Fish5.tscn"),
	preload("res://fish/Fish6.tscn"),
	preload("res://fish/Fish7.tscn"),
	preload("res://fish/Fish8.tscn")]

func _spawn_fish():
	var index = randi() % fishes.size()
	var fish = fishes[index].instance()
	add_child(fish)
	fish.connect("escaped", owner, "fish_escaped")
	if spawn_delay > FINAL_SPAWN_DELAY:
		spawn_delay -= SPAWN_REDUCTION
	timer.wait_time = spawn_delay

func stop():
	timer.stop()
	for fish in get_children():
		fish.stop()
