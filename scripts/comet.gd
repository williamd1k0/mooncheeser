
extends Node2D

onready var outer = get_node("comet_body/comet_sprite/comet_outer/outer_animator")
onready var core = get_node("core_animator")
onready var body = get_node("comet_body")

const comet_velocity = 400
func _ready():
	randomize()
	outer.set_speed(int(rand_range(1,3)))
	core.set_speed(int(rand_range(1,3)))
	#comet_velocity = rand_range(100, 300)
	set_process(true)
	pass

func _process(delta):
	body.set_linear_velocity(Vector2 (-comet_velocity, 0))
	pass
func _on_outer_animator_finished():
	outer.play("outer_animation")
	pass


func _on_core_animator_finished():
	core.play("core_animation")
	pass




func _on_VisibilityNotifier2D_exit_screen():
	var spawner = get_node("/root/main_scene/spawner")
	spawner.can_comet_spawn = true
	queue_free()