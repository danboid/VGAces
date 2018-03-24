extends Area2D

func _process(delta):
	var bombpos = get_position()
	bombpos.y = bombpos.y + 200 * delta
	set_position(bombpos)
	if bombpos.y > 480:
		queue_free()

func _on_Bomb_area_entered(area):
	# Should probably do this using collision masks instead
	if (area.get_name() == "LWH"):
		queue_free()
	elif (area.get_name() == "MWH"):
		queue_free()
	elif (area.get_name() == "RWH"):
		queue_free()
