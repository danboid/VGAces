extends Area2D

var screensize = OS.get_window_size()

func _on_Player_area_entered(area):
	get_node("/root/Main").score = 0
	get_node("/root/Main").update_score()
	self.set_position(Vector2(rand_range(22, (screensize.x - 22)),(screensize.y - 44)))
