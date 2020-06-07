extends KinematicBody2D

#CONSTANTES et VARIABLES CLEFS
const base_speed = 700
var speed = base_speed
const jump_time = 0.4 
const attack_stop_time = 0.6
const jump_speed = -930 #vitesse initial du saut
const flight_angle = 0.08 #08
const friction = 0.982 #0.99 (<1) 1 = vitesse élevé, 0 = vitesse nulle

const weak_gravity = Vector2(0, 5)
const strong_gravity = Vector2(0, 40)

#A AMILORATIER: COLLISION!, saut(plus faible au départ, fort à la fin), near ground/near celling à callibrer


#DATA (var that are use by the scripts but doesnt impact it)
var direction = 1
var last_direction = 1
var y_velo = 0

#BOOL
var can_move_h = true
var grounded = false
var cellinged = false
var can_jump = false
var jumping = false
var flying = false
var near_celling = false
var near_ground = false

var speed_vector = Vector2(0, 0)



func _ready():
	pass
	

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _physics_process(delta):
	global.player_pos = position
	global.player_global_pos = global_position
	# <--------------------------------------------------- HORIZONtAl MOVEMENT
	if can_move_h:
		if Input.is_action_pressed("move_left"):
			direction = -1
			last_direction = -1
			if !global.attacking:
				$SpriteRig/Sprite.flip_h = true
				$Sword.scale.x = -1
		if Input.is_action_pressed("move_right"):
			direction = 1
			last_direction = 1
			if !global.attacking:
				$SpriteRig/Sprite.flip_h = false
				$Sword.scale.x = 1
		
		if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right") :
			direction = 0

	# <------------------------------------------------------ VERTICAL MOVEMENT
	if Input.is_action_just_pressed("jump") and can_jump:
		jumping = true
		flying = false
		can_jump = false
		speed_vector = Vector2(0, jump_speed)
		max_jump()
	
	if Input.is_action_just_pressed("jump") and !jumping:
		flying = true
	
	if Input.is_action_just_released("jump"):
		jumping = false
		flying = false
	
	if flying :
		if last_direction==1:
			$SpriteRig.rotation_degrees = 90
		else:
			$SpriteRig.rotation_degrees = -90
		$CollisionShape2D.rotation_degrees =90
		$CollisionShape2D.position.y = 0
		
		if last_direction == 1 :
			if speed_vector.angle() < PI or speed_vector.angle() > 1.5*PI :
				speed_vector = speed_vector.rotated(-flight_angle)
		else :
			if speed_vector.angle() < 1.5*PI :
				speed_vector = speed_vector.rotated(flight_angle)
		
		if near_ground:
			if last_direction == 1 :
				speed_vector = speed_vector.rotated(-flight_angle)
			else :
				speed_vector = speed_vector.rotated(flight_angle)
		if near_celling:
			if last_direction == 1 :
				speed_vector = speed_vector.rotated(flight_angle)
			else :
				speed_vector = speed_vector.rotated(-flight_angle)
	else:
		$SpriteRig.rotation_degrees = 0
		$CollisionShape2D.rotation_degrees = 0
		$CollisionShape2D.position.y = 27
		
	
	if(jumping):
		speed_vector += weak_gravity
	else:
		speed_vector += strong_gravity
	
	speed_vector = speed_vector * friction
	#
	if grounded and !jumping:
		can_jump = true
		flying = false
		speed_vector = Vector2(0, 0)
		move_and_slide(Vector2(direction * speed , y_velo))
	else:
		can_jump = false
		var final_vector = speed_vector + Vector2(direction * speed, 0)
		var collision = move_and_collide(final_vector * delta)
		if collision:
			speed_vector = Vector2(0, 0)
	
	
#	if cellinged:
#		y_velo += 150
	

func max_jump():
	yield(get_tree().create_timer(jump_time),"timeout")
	jumping = false


func zoom(x):
	if x:
		$CameraRig/Camera2D.zoom = Vector2(1.5,1.5)
	else:
		$CameraRig/Camera2D.zoom = Vector2(2,2)



func _on_GroundDetection_body_entered(body):
	if body.is_in_group("ground")and !body.is_in_group("half_ground"):
		grounded = true

	
	
	
func _on_GroundDetection_body_exited(body):
	if body.is_in_group("ground"):
		grounded = false
	if body.is_in_group("half_ground"):
		#$CollisionShape2D.position = Vector2 (0,0)
		pass
		
func _on_CellingDetection_body_entered(body):
	if body.is_in_group("ground") and !body.is_in_group("half_ground"):
		cellinged = true
	elif body.is_in_group("ground") and body.is_in_group("half_ground"):
		#$CollisionShape2D.position = Vector2 (0,10000)
		pass
		
		


func _on_CellingDetection_body_exited(body):
	if body.is_in_group("ground"):
		cellinged = false
	if body.is_in_group("half_ground"):
		y_velo -= 250


func _on_Top_body_entered(body):
	if body.is_in_group("ground"):
		near_celling = true
func _on_Top_body_exited(body):
	if body.is_in_group("ground"):
		near_celling = false


func _on_Bottom_body_entered(body):
	if body.is_in_group("ground"):
		near_ground = true
func _on_Bottom_body_exited(body):
	if body.is_in_group("ground"):
		near_ground = false

func _on_Hitbox_area_entered(area):
	if area.is_in_group("pnj"):
		zoom(true)
func _on_Hitbox_area_exited(area):
	if area.is_in_group("pnj"):
		zoom(false)















