extends Area2D

var alph = 1

signal scoreup

onready var mainnode = get_node("/root/Main")
onready var screensize = get_viewport_rect().size

func _on_Ovni_area_entered(area):
	alph -= .1
	if alph > .2:
		$AnimatedSprite.set("modulate",Color(1, 1, 1, alph))
	else:
		get_node("/root/Main").score += 10
		emit_signal("scoreup")
		get_node("/root/Main/Explosion").play()
		queue_free()
		get_node("/root/Main/ovnitimer").start()
		
func _process(delta):
	var ovnipos = get_position()
	ovnipos.x = ovnipos.x + 150 * delta
	set_position(ovnipos)
	
	if ovnipos.x > (screensize.x + 100):
		queue_free()
		get_node("/root/Main/ovnitimer").start()