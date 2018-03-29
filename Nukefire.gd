extends Sprite

func _process(delta):
	var nukepos = get_position()
	nukepos.y = nukepos.y -200 * delta
	set_position(nukepos)
	if nukepos.y < 0:
		queue_free()
		
