extends Area2D

onready var blast = get_node("Blast")
onready var contract = get_node("Contract")

var blastsize = 0

func _ready():
	blastsize = rand_range(1.0, 2.0)
	blast.interpolate_property(self, "scale", Vector2(0, 0), Vector2(blastsize, blastsize), 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	blast.start()
	
func _on_Blast_tween_completed(object, key):
	contract.interpolate_property(self, "scale", Vector2(blastsize, blastsize), Vector2(0, 0), 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	contract.start()

func _on_Contract_tween_completed(object, key):
	queue_free()
