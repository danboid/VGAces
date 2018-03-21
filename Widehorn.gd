extends Area2D

onready var death = get_node("Death")
onready var sprite = get_node("Sprite")

var colr = 0.06

func _ready():
	$Sprite.set("modulate",Color(colr, colr, colr, 1))

func _on_Widehorn_area_entered(area):
	colr += .01
	if colr < 1:
		$Sprite.set("modulate",Color(colr, colr, colr, 1))
	else:
		$CollisionShape2D.disabled = true
		death.interpolate_property(sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		death.interpolate_property(sprite, "scale", Vector2(0.12, 0.12), Vector2(0, 0), 2.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
		death.start()

func _on_Death_tween_completed(object, key):
	queue_free()