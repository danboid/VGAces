# VGAces by Dan MacDonald

extends Node
export (PackedScene) var Pmissile

var velocity = Vector2()
var spacepressed = false
var speed = 200
var screensize
var pmisscount = 0
var pmissarray = []

func _ready():
    screensize = $Player.get_viewport_rect().size

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
    $Player.position += velocity * delta
    $Player.position.x = clamp($Player.position.x, 0, screensize.x)
    $Player.position.y = clamp($Player.position.y, 0, screensize.y)
	
    var missid = 0
    for miss in pmissarray:
        var pmisspos = get_node(miss).get_position()
        pmisspos.y = pmisspos.y -500 * delta
        get_node(miss).set_position(pmisspos)
        if pmisspos.y < 0:
            get_node(miss).free()
            pmissarray.remove(missid)
        missid = missid + 1
		
	
func fire():
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