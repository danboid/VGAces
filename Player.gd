extends Area2D

onready var birth = get_node("Birth")
onready var death = get_node("Death")
onready var sprite = get_node("Sprite")

func _ready():
	birth.interpolate_property(sprite, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	birth.start()


func _on_Player_area_entered(area):
	$CollisionShape2D.disabled = true
	get_node("/root/Main").bardo = true
	var score = get_node("/root/Main").score
	var highscore = get_node("/root/Main").highscore
	if score > highscore:
		get_node("/root/Main").highscore = score
	get_node("/root/Main").score = 0
	get_node("/root/Main").update_score()
	get_node("/root/Main/Death").play()
	death.interpolate_property(sprite, "scale", Vector2(1.0, 1.0), Vector2(0, 0), 1.0, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	death.start()

func _on_Death_tween_completed(object, key):
	set_name("DeadPlayer")
	queue_free()
	get_node("/root/Main").spawn_player()


func _on_Birth_tween_completed(object, key):
	get_node("/root/Main").bardo = false
