extends Control

onready var score = $Score/Value
onready var high_score 
onready var bomb = $Bomb

var cur_score : int = 0

func _ready():
	rect_position = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	bomb.visible = false
	
func add_to_score(value):
	cur_score += value
	score.text = str(cur_score)
	
func bomb_visible(is_visible):
	bomb.visible = is_visible
