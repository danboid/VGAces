extends Area2D

func _on_Player_area_entered(area):
	get_node("/root/Main").score = 0
	get_node("/root/Main").update_score()
	set_name("DeadPlayer")
	queue_free()
	get_node("/root/Main").spawn_player()