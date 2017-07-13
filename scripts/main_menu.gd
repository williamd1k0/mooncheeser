extends Control

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/game_scene.tscn")

func _on_credits_pressed():
	get_tree().change_scene("res://scenes/credits.tscn")

func _on_score_pressed():
	get_tree().change_scene("res://scenes/score_board.tscn")

func _on_quit_pressed():
	get_tree().set_pause(true)
	get_tree().quit()
