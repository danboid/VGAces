extends Area2D

func _ready():
	pass

func _process(delta):
	var bombpos = get_position()
	var screensize = OS.get_window_size()
	bombpos.y = bombpos.y + 200 * delta
	set_position(bombpos)
	if bombpos.y > screensize.y:
		queue_free()
		var bdelay = rand_range(1, 5)
		get_parent().timer.set_wait_time(bdelay)
		get_parent().timer.start()
