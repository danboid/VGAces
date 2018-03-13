extends Area2D

export (PackedScene) var Bomb

var alph = 1
#var timer = null

signal scoreinc

onready var mainnode = get_node("/root/Main")

func _ready():
	bomb()
#	var bdelay = rand_range(1, 5)
#	timer = Timer.new()
#	timer.set_one_shot(true)
#	timer.set_wait_time(bdelay)
#	timer.connect("timeout", self, "bomb")
#	add_child(timer)
#	timer.start()

func _process(delta):
	if has_node("bomb"):
		var bombpos = get_node("bomb").get_position()
		bombpos.y = bombpos.y + 200 * delta
		get_node("bomb").set_position(bombpos)
		if bombpos.y > 480:
			get_node("bomb").queue_free()

func bomb():
    var bomb = Bomb.instance()
    bomb.set_name("bomb")
    add_child(bomb)
    var bombpos = Vector2()
    var nmepos = get_position()
    bombpos.y = nmepos.y + 25
    bombpos.x = nmepos.x
    get_node("bomb").set_position(bombpos)

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
