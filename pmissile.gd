extends Area2D

func _on_pmissile_area_entered(area):
	var nuke = self.get_name()
	get_parent().get_node(nuke).queue_free()
	get_node("/root/Main").pmissarray.remove(0)