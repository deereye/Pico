extends KinematicBody2D

const GRAVITY = 18
const SPEED = 0
const FLOOR = Vector2(0, -1)

onready var anim = $Sprite
onready var ray = $RayCast2D

var velocity = Vector2()
var direction = 1


func _physics_process(delta):
	velocity.x = SPEED * direction
	if direction ==1:
		anim.flip_h = false #fait deja face à la droite
	else: anim.flip_h = true
	
	#anim.play("walk")
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
	

	if is_on_wall():
		direction *= -1
		ray.position.x *= -1

	if ray.is_colliding() == false:
		direction *= -1
		ray.position.x *= -1
	




