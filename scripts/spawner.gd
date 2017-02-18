
extends Node2D

export var dificulty = 5

onready var reference_hole = get_node("spawner_hole")
onready var reference_cheese = get_node("spawner_cheese")
onready var reference_comet = get_node("spawner_comet")
onready var hole_clock = get_node("clock_holes")
onready var cheese_clock = get_node("clock_cheese")
onready var comet_clock = get_node("clock_comet")

onready var cheese = preload("res://scenes/cheese.scn")
onready var hole = preload("res://scenes/hole.scn")
onready var comet = preload("res://scenes/comet.scn")
onready var itens = [cheese, hole, comet]

var comet_dif = 5
var can_comet_spawn = true
var can_hole = true

func _ready():
	randomize()
	hole_clock.set_wait_time(rand_range(0, dificulty))
	comet_clock.set_wait_time(rand_range(0, comet_dif))
	pass
	
func spawn(self_pos, which, parent):
	var item = itens[which].instance()
	parent.add_child(item)
	item.set_global_transform(self_pos)
	pass
	
func _on_spawner_clock_timeout():
	var moon = get_node("/root/main_scene/moon/moon_sprite")
	var spawn_pos = reference_hole.get_global_transform()
	if can_hole:
		spawn(spawn_pos, 1, moon)
		hole_clock.set_wait_time(rand_range(0, dificulty))
		can_hole = false
	pass

func _on_clock_comet_timeout():
	var spawn_pos = reference_comet.get_global_transform()
	var main_scene = get_node("/root/main_scene")
	if can_comet_spawn == true:
		spawn(spawn_pos, 2, main_scene)
		comet_clock.set_wait_time(rand_range(0, dificulty))
		can_comet_spawn = false
		if comet_dif > 2:
			comet_dif -= 0.5


func _on_clock_cheese_timeout():
	var moon = get_node("/root/main_scene/moon/moon_sprite")
	var spawn_pos = reference_cheese.get_global_transform()
	spawn(spawn_pos, 0, moon)
	cheese_clock.set_wait_time(rand_range(0, 4))
	pass