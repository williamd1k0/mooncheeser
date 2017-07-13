
extends StaticBody2D

onready var sprite = get_node("moon_sprite")
onready var animator = get_node("moon_animator")

var dificulty = 1.0

func _ready():
	pass

func _on_moon_timer_timeout():
	dificulty += 0.2
	animator.set_speed(dificulty)
