extends Control

var teste = "testando sistema de save/load"
var f = File.new()
var save = "res://teste_dados"
onready var highscore_node = get_node("/root/highscore")
onready var high_score_text = get_node("score_board/high_score")
onready var score_text = get_node("score_board/score")
onready var achiev = get_node("unlock")
onready var score_button = get_node("online")
onready var score_name = get_node("online/LineEdit")

func _ready():
	var score = highscore_node.new_score
	if highscore_node.unlock == true and score >= 15:
		achiev.show()
	highscore_node.can_read = true
	var high_score = highscore_node.high_score
	high_score_text.set_text("High Score: " + str(high_score))
	score_text.set_text("Your Score: " + str(score))
	if score > high_score:
		highscore_node.write(score)
		get_node("online").show()
	
func _on_retry_button_pressed():
	get_tree().change_scene("res://scenes/main_scene.scn")


func _on_quit_button_pressed():
	get_tree().change_scene("res://scenes/main_menu.scn")

func _on_online_pressed():
	if score_name.get_text().strip_edges():
		score_button.hide()
		var data = {
			'name': score_name.get_text().strip_edges(),
			'points': highscore_node.high_score
		}
		ScoreServer.request_post('/new/', data)
		ScoreServer.connect('status_200', self, '_on_request_complete')

func _on_request_complete(data):
	print('SCORE SAVED')
	get_node("score_saved").show()
