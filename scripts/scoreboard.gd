
extends Control


func _ready():
	set_process(true)
	pass
func _process(delta):
	if Input.is_action_pressed("mouse_press"):
		get_tree().change_scene("res://scenes/main_menu.scn")