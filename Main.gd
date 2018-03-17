# VGAces by Dan MacDonald

extends Node
export (PackedScene) var Pmissile

onready var player = preload("res://Player.tscn")
onready var p = player.instance()
onready var velon = preload("res://Velon.tscn")
onready var velons = get_node("Velons")
onready var ovni = preload("res://Ovni.tscn")

var velocity = Vector2()
var spacepressed = false
var speed = 200
var score = 0
var screensize = OS.get_window_size()
var pmisscount = 0
var pmissarray = []
var veloncount = 10
var highscore = 0
var ovnitimer = null

func _ready():
	randomize()
	spawn_player()
	spawn_velons(veloncount)
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
        $Player.position.x = clamp($Player.position.x, 0, screensize.x)
        $Player.position.y = clamp($Player.position.y, 0, screensize.y)
	
    var missid = 0
    for miss in pmissarray:
        # Move player missiles up the screen
        var pmisspos = get_node(miss).get_position()
        pmisspos.y = pmisspos.y -500 * delta
        get_node(miss).set_position(pmisspos)
		# Remove missiles that fly off screen
        if pmisspos.y < 0:
            get_node(miss).queue_free()
            pmissarray.remove(missid)
        missid = missid + 1
		
    
    if veloncount == 3:
        veloncount += 7
        spawn_velons(veloncount)

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
	screensize = OS.get_window_size()
	for i in range(num):
		var v = velon.instance()
		velons.add_child(v)
		v.connect("scoreup", self, "update_score")
		v.set_position(Vector2(rand_range(22, (screensize.x - 44)),rand_range(33, (screensize.y - 99))))

func spawn_player():
	screensize = OS.get_window_size()
	var p = player.instance()
	p.set_name("Player")
	add_child(p)
	p.set_position(Vector2(rand_range(22, (screensize.x - 22)),(screensize.y - 22)))
	
func spawn_ovni():
	screensize = OS.get_window_size()
	var o = ovni.instance()
	o.set_name("Ovni")
	add_child(o)
	o.connect("scoreup", self, "update_score")
	o.set_position(Vector2(-50,33))
	$Siren.play()