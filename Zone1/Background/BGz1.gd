extends KinematicBody2D
export var follow_speed = 500
var speed = 0.5
var speed2 = 0.25
var dir1 = 1
var dir2 = -1
var already_changed = false

func _process(delta):
	if $cloud1.position.x == -1960:
		dir1 = 1
	if $cloud1.position.x == 140:
		dir1 = -1
	
	if $cloud2.position.x == -1960:
		dir2 = 1
	if $cloud2.position.x == 140:
		dir2= -1
	
	

	
	
	$cloud1.position.x += speed2 * dir1
	$cloud2.position.x += speed * dir2


func follow():
	if position.distance_to(global.player_pos) != 0:
		var distance : Vector2 = (global.player_pos - position)
		move_and_slide(follow_speed * distance.normalized())

