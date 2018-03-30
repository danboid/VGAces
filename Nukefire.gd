extends Sprite

signal gonuke

func _process(delta):
	var nukepos = get_position()
	if nukepos.y > get_node("/root/Main/").nukedest.y:
		nukepos.y = nukepos.y -200 * delta
		set_position(nukepos)
	else:
		emit_signal("gonuke")
		queue_free()
		
		
