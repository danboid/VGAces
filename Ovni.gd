extends Area2D

var ovnialph = 1

func _on_Ovni_area_entered(area):
	ovnialph = ovnialph - .1
	$AnimatedSprite.set("modulate",Color(1, 1, 1, ovnialph))
