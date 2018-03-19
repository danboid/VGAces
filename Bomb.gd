extends Area2D

func _process(delta):
	var bombpos = get_position()
	var screensize = OS.get_window_size()
	bombpos.y = bombpos.y + 200 * delta
	set_position(bombpos)
	if bombpos.y > screensize.y:
		queue_free()
