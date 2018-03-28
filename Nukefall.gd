extends Area2D

onready var fade = get_node("Fade")
onready var sprite = get_node("Sprite")
onready var faderange = [0, 1]

func _ready():
	_start_tween()

func _start_tween():
	fade.interpolate_property(sprite, "modulate", Color(1, 1, 1, faderange[0]), Color(1, 1, 1, faderange[1]), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	fade.start()

func _on_Fade_tween_completed(object, key):
	faderange.invert()
	_start_tween()
	
func _process(delta):
	var nukepos = get_position()
	nukepos.y = nukepos.y + 150 * delta
	set_position(nukepos)
	if nukepos.y > 480:
		queue_free()
