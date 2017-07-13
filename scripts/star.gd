
extends Node2D

onready var scale = get_node("star_scale")

func _ready():
	scale.set_speed(int(rand_range(1,3)))
