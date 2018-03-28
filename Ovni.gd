extends Area2D

var alph = 1

signal scoreup

onready var death = get_node("Death")
onready var sprite = get_node("Sprite")
onready var nukefall = preload("res://Nukefall.tscn")

func _on_Ovni_area_entered(area):
	alph -= .1
	if alph > .4:
		$Sprite.set("modulate",Color(1, 1, 1, alph))
	else:
		$CollisionShape2D.disabled = true
		get_node("/root/Main").score += 10
		emit_signal("scoreup")
		get_node("/root/Main/Explosion").play()
		get_node("/root/Main/Siren").stop()
		droppowr()
		death.interpolate_property(sprite, "rotation_degrees", 0, -360, 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
		death.interpolate_property(sprite, "scale", Vector2(0.25, 0.25), Vector2(0, 0), 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
		death.start()
		
func _process(delta):
	var ovnipos = get_position()
	ovnipos.x = ovnipos.x + 140 * delta
	set_position(ovnipos)
	
	if ovnipos.x > 740:
		queue_free()
		get_node("/root/Main/Siren").stop()
		get_node("/root/Main/ovnitimer").start()

func _on_Death_tween_completed(object, key):
	queue_free()
	get_node("/root/Main/ovnitimer").start()
	
func droppowr():
	var nuke = nukefall.instance()
	var ovnipos = get_position()
	nuke.set_position(ovnipos)
	nuke.set_name("nuke")
	get_node("/root/Main").add_child(nuke)
	
