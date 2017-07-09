extends HBoxContainer

var name = 'Name'
var points = 'Points'

func _ready():
	update_labels()

func set_data(name_, points_, update_=true):
	name = name_
	points = str(points_)
	if update_:
		update_labels()

func update_labels():
	get_node("name").set_text(name)
	get_node("points").set_text(points)
