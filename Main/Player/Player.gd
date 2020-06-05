extends KinematicBody2D

#CONSTANTES et VARIABLES CLEFS
const gravity = 45
const base_speed = 700
var speed = base_speed
const jump_force = 700
const jump_time = 0.235
const max_fall_speed = 1200 
const flying_factor = 2.9  #DIVISE 
const attack_stop_time = 0.6


#DATA (var that are use by the scripts but doesnt impact it)
var direction = 1
var y_velo = 0
var current_jump_force = 0

#BOOL
var can_move_h = true
var grounded = false
var cellinged = false
var can_jump = false
var jumping = false
var flying = false



func _ready():
	pass
	

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta):
	global.player_pos = position
	global.player_global_pos = global_position
	# <--------------------------------------------------- HORIZONtAl MOVEMENT
	if can_move_h:
		if Input.is_action_pressed("move_left"):
			direction = -1
			$Sprite.flip_h = true
		if Input.is_action_pressed("move_right"):
			direction = 1
			$Sprite.flip_h = false
		
		if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right") :
			direction = 0

	# <------------------------------------------------------ VERTICAL MOVEMENT
	if Input.is_action_just_pressed("jump") and can_jump:
		jumping = true
		can_jump = false
		max_jump()
	if Input.is_action_just_released("jump"):
		jumping = false
	
	if !grounded:
		if Input.is_action_just_pressed("jump"):
			flying = true
			jumping = false
			
		if Input.is_action_just_released("jump") and flying:
			flying = false
			y_velo= 5
			
	
	# <------------------------------------------------------------------- SAUT
	if jumping:
		y_velo = -current_jump_force 
		current_jump_force += 13.5
	else:
		current_jump_force = jump_force
	
	# <-------------------------------------------------------------------- VOLE
	if flying :
		speed = 860
		if direction==1:
			$Sprite.rotation_degrees = 90
		else :
			$Sprite.rotation_degrees = -90
		if direction == 0 :
			y_velo /= flying_factor
			y_velo *= 3
		elif is_on_wall():
			y_velo /= flying_factor
			y_velo *= 3
		else:
			y_velo /= flying_factor
	else:
		$Sprite.rotation_degrees = 0
		speed = base_speed
		
	#
	if grounded:
		can_jump = true
		flying = false
		if !jumping:
			y_velo = 5
	else:
		y_velo += gravity
		if y_velo >= max_fall_speed:
			y_velo = max_fall_speed
	
	
			

	
	if cellinged:
		y_velo += 150
	
	move_and_slide(Vector2(direction * speed , y_velo), Vector2(0,1))


func max_jump():
	yield(get_tree().create_timer(jump_time),"timeout")
	jumping = false


func _on_GroundDetection_body_entered(body):
	if body.is_in_group("ground"):
		grounded = true


func _on_GroundDetection_body_exited(body):
	if body.is_in_group("ground"):
		grounded = false


func _on_CellingDetection_body_entered(body):
	if body.is_in_group("ground"):
		cellinged = true


func _on_CellingDetection_body_exited(body):
	if body.is_in_group("ground"):
		cellinged = false
