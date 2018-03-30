extends Area2D

export (PackedScene) var Bomb

onready var birth = get_node("Birth")
onready var death = get_node("Death")
onready var sprite = get_node("Sprite")

var alph = 1
var born = false
var timer = null
var bombpos = Vector2()
var bdelay = rand_range(1, 5)
var dist = rand_range(50, 100)
var right = Vector2()
var left = Vector2()
var startpos = Vector2()
var direction = true
var speed = rand_range(50, 150)

signal scoreup

func _ready():
	birth.interpolate_property(sprite, "scale", Vector2(0, 0), Vector2(0.33, 0.33), 1.0, Tween.TRANS_QUAD, Tween.EASE_IN)
	birth.start()

func _process(delta):
	if born == true:
		var velpos = get_position()
		if direction == true:
			if velpos.x < right.x:
				velpos.x = velpos.x + speed * delta
				set_position(velpos)
			else:
				direction = false
		else:
			if velpos.x > left.x:
				velpos.x = velpos.x - speed * delta
				set_position(velpos)
			else:
				direction = true

func _on_Birth_tween_completed(object, key):
	born = true
	startpos = get_position()
	right = Vector2(startpos.x + dist, startpos.y)
	left =  Vector2(startpos.x - dist, startpos.y)
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(bdelay)
	timer.connect("timeout", self, "bomb")
	add_child(timer)
	timer.start()

func bomb():
	var bomb = Bomb.instance()
	var velpos = get_position()
	bomb.set_name("bomb")
	bombpos.y = velpos.y + 25
	bombpos.x = velpos.x
	bomb.set_position(bombpos)
	get_node("/root/Main").add_child(bomb)
	get_node("/root/Main/VelonFire").play()
	bdelay = rand_range(3, 5)
	timer.set_wait_time(bdelay)
	timer.start()

func _on_Velon_area_entered(area):
	alph -= .1
	if (area.get_name() == "Blast"):
		print("Blast")
		die()
	elif alph > .2:
		$Sprite.set("modulate",Color(1, 1, 1, alph))
	else:
		die()

func _on_Death_tween_completed(object, key):
	queue_free()

func die():
	get_node("/root/Main").score += 1
	emit_signal("scoreup")
	get_node("/root/Main/Explosion").play()
	get_node("/root/Main").veloncount -= 1
	$CollisionShape2D.disabled = true
	death.interpolate_property(sprite, "rotation_degrees", 0, 720, 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	death.interpolate_property(sprite, "scale", Vector2(0.33, 0.33), Vector2(0, 0), 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	death.start()
