extends Resource
class_name HighScore

export var scores : Array

func add_score(score):
	scores.append(score)

func get_high_score():
	if scores.size() == 0: 
		return 0
	return scores.max()
