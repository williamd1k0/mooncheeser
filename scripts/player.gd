extends Node2D

onready var moon = get_node("/root/main_scene/moon")
onready var body = get_node("player_body")
onready var score = get_node("/root/main_scene/score_position/score_text")
onready var animator = get_node("mouse_animator")
onready var highscore_node = get_node("/root/highscore")
onready var sample_player = get_node("player_body/mouse_player")
onready var sample_player_steps = get_node("player_body/mouse_player_steps")

var dead = false
var jumping = false
var points = 0
var prev_mouse = false

var jump_force = 300.0

func _ready():
	if highscore_node.unlock == true:
		var texture = load("res://sprites/mouse_full_astro.png")
		if texture != null:
			get_node("player_body/player_sprite").set_texture(texture)
	sample_player_steps.play("steps")
	set_fixed_process(true)
	score.set_text("Score: " + str(points))
	pass

func jump(time):
	if not jumping:
		body.set_linear_velocity(Vector2 (0.0, -jump_force * (time * 100.0)))
		animator.play("new_jump")
		if not dead:
			sample_player.play("jump_1")
			sample_player_steps.stop_all()
		jumping = true


func _fixed_process(delta):
	var mouse_down = Input.is_action_pressed("mouse_press")
	if (mouse_down) and not (prev_mouse):
		jump(delta)
	#prev_mouse = mouse_down
	if animator.get_current_animation() == 'new_jump':
		var velocity = body.get_linear_velocity()
		if velocity.y >= 0.0:
			animator.set_speed(4.0)
		else:
			animator.set_speed(0.0)
	prev_mouse = Input.is_action_pressed("mouse_press")
#Signal from rigidbody
func _on_player_body_body_enter( body ):

	var fade = get_node("dead_fade")
	if body == moon and not dead:
		jumping = false
		animator.play("new_walk")
		sample_player_steps.play("steps")
	elif "hole" in body.get_name() and not dead:
		set_hidden(true)
		dead = true
		fade.start()
		sample_player_steps.stop_all()
		sample_player.play("dead_1")
		highscore_node.can_write = true
		highscore.new_score = points
	elif "comet" in body.get_name() and not dead:
		set_hidden(true)
		dead = true
		fade.start()
		sample_player_steps.stop_all()
		sample_player.play("dead_1")
		#Send the current score and compare
		#to know if there is a new highscore
		highscore_node.new_score = points
		highscore_node.can_write = true
	elif "cheese" in body.get_name() and not dead:
		body.queue_free()
		points += 1
		score.set_text("Score: " + str(points))
		sample_player.play("cheese")
	pass

func _on_dead_fade_timeout():
	get_tree().change_scene("res://scenes/game_over.tscn")