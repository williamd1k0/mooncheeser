
extends Control

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/main_scene.scn")

func _on_credits_pressed():
	get_tree().change_scene("res://scenes/credits.scn")


func _on_quit_pressed():
	get_tree().set_pause(true)
	get_tree().quit()
