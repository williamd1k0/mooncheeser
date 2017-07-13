
extends Control


func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("mouse_press"):
		get_tree().change_scene("res://scenes/main_menu.tscn")
