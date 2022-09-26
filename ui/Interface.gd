extends Control

signal died

onready var game_container = $Game
onready var game_over_container = $GameOver
onready var score = $Game/Score/Value
onready var game_over_score = $GameOver/Scores/ScoreBox/Value
onready var high_score_label = $GameOver/Scores/HighscoreBox/Value
onready var bomb_icon = $Game/BombSlot/Icon
onready var bomb_progress = $Game/BombProgress
onready var health_progress = $Game/Health
onready var high_score = preload("res://high_score.tres")

var cur_score : int = 0
var cur_health : int = 20
var dead : bool = false

func _ready():
	game_container.visible = true
	game_over_container.visible = false
	bomb_icon.visible = false
	health_progress.max_value = cur_health
	health_progress.value = cur_health
	bomb_progress.max_value = Global.required_fish_for_bomb
	game_over_container.find_node("NewGameButton").connect("button_up", self, "restart_game")

func add_to_score(value):
	cur_score += value
	score.text = str(cur_score)

func bomb_progress(value):
	bomb_progress.value = value

func bomb_visible(is_visible): 
	bomb_icon.visible = is_visible

func remove_health():
	if dead: return
	cur_health -= 1
	health_progress.value = cur_health
	if cur_health <= 0:
		emit_signal("died")
		dead = true
		game_container.visible = false
		game_over_container.visible = true
		save_score()
		game_over_score.text = str(cur_score)
		high_score_label.text = str(high_score.get_high_score())

func save_score():
	high_score.add_score(cur_score)
	ResourceSaver.save("res://high_score.tres", high_score)

func restart_game():
	get_tree().reload_current_scene()
