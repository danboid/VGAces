# VGAces by Dan MacDonald

extends Node
export (PackedScene) var Pmissile

onready var player = preload("res://Player.tscn")
onready var p = player.instance()
onready var velon = preload("res://Velon.tscn")
onready var velons = get_node("Velons")
onready var ovni = preload("res://Ovni.tscn")
onready var widehorn = preload("res://Widehorn.tscn")

var velocity = Vector2()
var spacepressed = false
var speed = 200
var score = 0
var pmisscount = 0
var pmissarray = []
var veloncount = 10
var highscore = 0
var ovnitimer = null
var widehorns = 0

func _ready():
	randomize()
	spawn_player()
	spawn_velons(veloncount)
	spawn_widehorns()
	ovnitimer = Timer.new()
	ovnitimer.set_name("ovnitimer")
	ovnitimer.set_one_shot(true)
	ovnitimer.set_wait_time(20)
	ovnitimer.connect("timeout", self, "spawn_ovni")
	add_child(ovnitimer)
	ovnitimer.start()

func _process(delta):
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_select"):
		if spacepressed == false:
			fire()
			spacepressed = true
	else:
		spacepressed = false
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	if has_node("Player"):
		$Player.position += velocity * delta
		$Player.position.x = clamp($Player.position.x, 0, 640)
		$Player.position.y = clamp($Player.position.y, 0, 480)
	
	var missid = 0
	for miss in pmissarray:
		var pmisspos = get_node(miss).get_position()
		pmisspos.y = pmisspos.y -500 * delta
		get_node(miss).set_position(pmisspos)
		if pmisspos.y < 0:
			get_node(miss).queue_free()
			pmissarray.remove(missid)
		missid = missid + 1
		
	if veloncount < 4:
		veloncount += 7
		spawn_velons(veloncount)
		
	if widehorns == 0:
		spawn_widehorns()

func fire():
	if has_node("Player"):
		pmisscount = pmisscount + 1
		var pmissile = Pmissile.instance()
		pmissile.set_name("pmissile"+str(pmisscount))
		add_child(pmissile)
		var pmisspos = Vector2()
		var playerpos = $Player.get_position()
		pmisspos.y = playerpos.y - 35
		pmisspos.x = playerpos.x
		get_node("pmissile"+str(pmisscount)).set_position(pmisspos)
		pmissarray.push_back("pmissile"+str(pmisscount))
		$PlayerZzap.play()
	
func update_score():
	$HUD.update_score(score)
	
func spawn_velons(num):
	for i in range(num):
		var v = velon.instance()
		velons.add_child(v)
		v.connect("scoreup", self, "update_score")
		v.set_position(Vector2(rand_range(22, 596),rand_range(33, 347)))

func spawn_player():
	var p = player.instance()
	p.set_name("Player")
	add_child(p)
	p.set_position(Vector2(rand_range(22, 640), 458))
	
func spawn_ovni():
	var o = ovni.instance()
	o.set_name("Ovni")
	add_child(o)
	o.connect("scoreup", self, "update_score")
	o.set_position(Vector2(-50,33))
	$Siren.play()
	
func spawn_widehorns():
	var lw = widehorn.instance()
	add_child(lw)
	lw.set_position(Vector2(63,393))
	
	var mw = widehorn.instance()
	add_child(mw)
	mw.set_position(Vector2(323,393))
	
	var rw = widehorn.instance()
	add_child(rw)
	rw.set_position(Vector2(569,393))
	
	widehorns = 3