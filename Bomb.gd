extends Area2D

func _process(delta):
	var bombpos = get_position()
	bombpos.y = bombpos.y + 200 * delta
	set_position(bombpos)
	if bombpos.y > 480:
		queue_free()

func _on_Bomb_area_entered(area):
	queue_free()
