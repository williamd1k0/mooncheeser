extends Node

var f = File.new()
var path = "user://high_score"

var high_score = 0
var current_high = 0
var new_score = 0
var unlock = false

var can_write = false
var can_read = false

func _ready():
	if f.file_exists(path):
		f.open(path, File.READ)
		current_high = f.get_var()
		high_score = current_high
		if current_high >= 15:
			unlock = true
			f.close()
		else:
			f.close()
	else:
		f.open(path, File.WRITE)
		f.store_var(high_score)
		f.close()

func _process(delta):
	if can_write:
		write(new_score)
	if can_read:
		read()
	
func write(score):
	if score > current_high:
		high_score = score
		f.open(path, File.WRITE)
		f.store_var(high_score)
		f.close()
		can_write = false
	else:
		can_write = false

func read():
	f.open(path, File.READ)
	current_high = f.get_var()
	if current_high > 15:
		unlock = true
		f.close()
	else:
		f.close()
	can_read = false