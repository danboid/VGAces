extends Area2D

var alph = 1

signal scoreinc

onready var mainnode = get_node("/root/Main")

func _on_Velon_area_entered(area):
	mainnode.connect("scoreinc", self, "score_increase")
	alph -= .1
	if alph > .1:
		$AnimatedSprite.set("modulate",Color(1, 1, 1, alph))
	else:
		emit_signal("scoreinc")
		get_node("/root/Main/Explosion").play()
		get_node("/root/Main").veloncount -= 1
		queue_free()
