extends CanvasLayer

func update_score(score):
	var highscore = get_node("/root/Main").highscore
	$Score.text = str(score)
	$Highscore.text = str(highscore)