extends Control

signal died

var high_scores : Array = []

onready var health = $Health/Value
onready var score = $Score/Value
onready var high_score = preload("res://high_score.tres")
onready var bomb = $Bomb

var cur_score : int = 0
var cur_health : int = 1

func _ready():
	rect_position = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	bomb.visible = false
	health.text = str(cur_health)
	
func add_to_score(value):
	cur_score += value
	score.text = str(cur_score)
	
func bomb_visible(is_visible):
	bomb.visible = is_visible

func remove_health():
	cur_health -= 1
	health.text = str(cur_health)
	if cur_health <= 0:
		emit_signal("died")
		save_score()

func save_score():
	high_score.add_score(cur_score)
	ResourceSaver.save("res://high_score.tres", high_score)
