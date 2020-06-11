extends KinematicBody2D

const gravity = Vector2(0, 40)
const walking_speed = 100
const jump_speed = [400, -600]
const drop_speed = 200
const jump_time = 0.2

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var direction
var jumping

var speed_vector

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = -1
	jumping = false
	speed_vector = Vector2()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !jumping and on_ground() :
		if direction == 1 :
			if near_right_wall() :
				if can_jump_right():
					jumping = true
					jump_timeout()
					speed_vector = Vector2(jump_speed[0], jump_speed[1])
				else:
					turn_around()
			elif near_right_cliff():
				if can_drop_right():
					jumping = true
					jump_timeout()
					speed_vector = Vector2(drop_speed, 0)
				else :
					turn_around()
			else:
				move_and_slide(Vector2(walking_speed, 5))
		else:
			if near_left_wall() :
				if can_jump_left():
					jumping = true
					jump_timeout()
					speed_vector = Vector2(-1*jump_speed[0], jump_speed[1])
				else:
					turn_around()
			elif near_left_cliff():
				if can_drop_left():
					jumping = true
					jump_timeout()
					speed_vector = Vector2(-1*drop_speed, 0)
				else :
					turn_around()
			else:
				move_and_slide(Vector2(-1*walking_speed, 20))
	else :
		print("in air")
		speed_vector += gravity
		move_and_slide(speed_vector)

func turn_around():
	direction *= -1
	$SpriteRig/Sprite.flip_h = (direction == 1)
	
func jump_timeout():
	yield(get_tree().create_timer(jump_time),"timeout")
	jumping = false

func on_ground():
	var olb = $Node2D/GroundDetection.get_overlapping_bodies()
	for body in olb:
		if body.is_in_group("ground"):
			return true
	return false

func near_left_wall():
	var olb = $Node2D/LeftWallDetection.get_overlapping_bodies()
	for body in olb:
		if body.is_in_group("ground"):
			return true
	return false

func near_right_wall():
	var olb = $Node2D/RightWallDetection.get_overlapping_bodies()
	for body in olb:
		if body.is_in_group("ground"):
			return true
	return false

func near_left_cliff():
	var olb = $Node2D/LeftCliffDetection.get_overlapping_bodies()
	for body in olb:
		if body.is_in_group("ground"):
			return false
	return true

func near_right_cliff():
	var olb = $Node2D/RightCliffDetection.get_overlapping_bodies()
	for body in olb:
		if body.is_in_group("ground"):
			return false
	return true

func can_jump_left():
	var olb = $Node2D/LeftJumpZone.get_overlapping_bodies()
	for body in olb:
		if body.is_in_group("ground"):
			return false
	return true

func can_jump_right():
	var olb = $Node2D/RightJumpZone.get_overlapping_bodies()
	for body in olb:
		if body.is_in_group("ground"):
			return false
	return true
	
func can_drop_left():
	var olb = $Node2D/LeftDropDetection.get_overlapping_bodies()
	for body in olb:
		if body.is_in_group("ground"):
			return true
	return false

func can_drop_right():
	var olb = $Node2D/RightDropDetection.get_overlapping_bodies()
	for body in olb:
		if body.is_in_group("ground"):
			return true
	return false
