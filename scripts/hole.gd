extends Node2D

func _on_hole_notifier_exit_screen():
	get_node("/root/main_scene/spawner").can_hole = true
	queue_free()

func _on_cheese_visibility_exit_screen():
	queue_free()
