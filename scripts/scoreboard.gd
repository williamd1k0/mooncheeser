extends Control

onready var score_board = get_node('score_board')
const entry_header = preload('res://scenes/entry_header.tscn')
const DEBUG = false
const TEST_ENTRIES = [
	{
		'name': 'Tumeo',
		'points': '100',
	},
	{
		'name': 'Henrique',
		'points': '520'
	}
]

func _ready():
	if DEBUG:
		debug_entries()
	else:
		process_score_server()
		add_score_entries([])
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("mouse_press"):
		get_tree().change_scene("res://scenes/main_menu.scn")

func debug_entries():
	add_score_entries(TEST_ENTRIES)

func add_score_entry(name, points):
	var entry = entry_header.instance()
	entry.set_data(name, points)
	score_board.add_child(entry)

func add_score_entries(entries):
	for entry in entries:
		add_score_entry(entry['name'], entry['points'])

func process_score_server():
	ScoreServer.request_get('/list/')
	ScoreServer.connect('status_200', self, '_on_score_server_complete')
	ScoreServer.connect('request_error', self, '_on_score_server_error')

func _on_score_server_complete(data):
	get_node("moon_sprite/moon_credit_animation").play("moon_credit")
	get_node("score_board/entry_header").show()
	add_score_entries(data['score_list'])


func _on_score_server_error(data, status):
	get_node("Error").show()
	get_node("moon_sprite/AnimationPlayer").play("failed")
