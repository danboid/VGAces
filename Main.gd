# VGAces by Dan MacDonald

extends Node
export (PackedScene) var Pmissile

onready var player = preload("res://Player.tscn")
onready var p = player.instance()
onready var velon = preload("res://Velon.tscn")
onready var velons = get_node("Velons")
onready var ovni = preload("res://Ovni.tscn")
onready var widehorn = preload("res://Widehorn.tscn")
onready var nukefire = preload("res://Nukefire.tscn")
onready var nukeblast = preload("res://Nukeblast.tscn")

var velocity = Vector2()
var spacepressed = false
var ctrlpressed = false
var speed = 200
var score = 0
var pmisscount = 0
var pmissarray = []
var veloncount = 0
var highscore = 0
var ovnitimer = null
var widehorns = 0
var bardo = false
var havenuke = false
var nukedest = Vector2()
var swipe_start = null
var minimum_drag = 100

func _ready():
	randomize()
	spawn_player()
	ovnitimer = Timer.new()
	ovnitimer.set_name("ovnitimer")
	ovnitimer.set_one_shot(true)
	ovnitimer.set_wait_time(10)
	ovnitimer.connect("timeout", self, "spawn_ovni")
	add_child(ovnitimer)
	ovnitimer.start()

func _process(delta):
	velocity = Vector2()
	if Input.is_action_pressed("fire_nuke") and havenuke:
		if ctrlpressed == false:
			nukefire()
			ctrlpressed = true
	else:
		ctrlpressed = false
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_select") or Input.is_mouse_button_pressed(BUTTON_LEFT):
		if spacepressed == false and bardo == false:
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
		var newvelons = rand_range(4, 10)
		spawn_velons(newvelons)
		veloncount += newvelons
		
	if widehorns == 0:
		spawn_widehorns()
		
func _input(event):
	if event is InputEventMouseMotion:
		$Player.position.x = event.position.x
	if event is InputEventMouseButton:
		if (event.pressed and event.button_index == BUTTON_RIGHT and havenuke):
			nukefire()
	if event.is_action_pressed("click"):
		swipe_start = event.position
	if event.is_action_released("click"):
		calculate_swipe(event.position)

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
	if has_node("Player") == false:
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
	lw.set_name("LWH")
	
	var mw = widehorn.instance()
	add_child(mw)
	mw.set_position(Vector2(323,393))
	mw.set_name("MWH")
	
	var rw = widehorn.instance()
	add_child(rw)
	rw.set_position(Vector2(569,393))
	rw.set_name("RWH")
	
	widehorns = 3
	
func nukefire():
	var nukepos = $Player.get_position()
	nukedest = Vector2(nukepos.x, (nukepos.y - 250))
	var n = nukefire.instance()
	add_child(n)
	n.set_position(nukepos)
	n.set_name("nuke")
	n.connect("gonuke", self, "nukeblast")
	havenuke = false
	$HUD/nuke.hide()
	$Launch.play()
	
func nukeblast():
	var nb = nukeblast.instance()
	add_child(nb)
	nb.set_position(nukedest)
	$Nuke.play()
	    
func calculate_swipe(swipe_end):
	if swipe_start == null:
		return
	var swipe = swipe_end - swipe_start
	if abs(swipe.y) > minimum_drag:
		if swipe.y < -100 and havenuke:
			nukefire()