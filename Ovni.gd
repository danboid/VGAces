extends Area2D

var ovnialph = 1

signal scoreinc

onready var mainnode = get_node("/root/Main")

func _on_Ovni_area_entered(area):
	mainnode.connect("scoreinc", self, "score_increase")
	ovnialph = ovnialph - .1
	if ovnialph > .1:
		$AnimatedSprite.set("modulate",Color(1, 1, 1, ovnialph))
	else:
		emit_signal("scoreinc")
		get_node("/root/Main/Explosion").play()
		queue_free()