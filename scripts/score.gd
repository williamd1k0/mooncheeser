
extends Node2D

onready var text = get_node("score_text")
var score = 0

func _ready():
	set_process(true)
	pass
func _process(delta):
	text.set_text("Score: " + str(score))
