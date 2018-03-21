extends Area2D

var colr = 0.1

func _on_Widehorn_area_entered(area):
	colr += .01
	if colr < 1:
		$Sprite.set("modulate",Color(colr, colr, colr, 1))
	else:
		queue_free()
