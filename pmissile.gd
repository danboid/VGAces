extends Area2D

func _on_pmissile_area_entered(area):
	var nuke = get_name()
	var index = get_node("/root/Main/").pmissarray.find(nuke)
	get_node("/root/Main/"+str(nuke)).queue_free()
	get_node("/root/Main/").pmissarray.remove(index)