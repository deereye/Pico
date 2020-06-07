extends KinematicBody2D

const GRAVITY = 18
const SPEED = 30
const FLOOR = Vector2(0, -1)

onready var anim = $AnimatedSprite
onready var ray = $RayCast2D

var velocity = Vector2()
var direction = 1
var isDead = false
var hp = 10

signal enemyHit

func _physics_process(delta):
	if isDead == false:
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
	
		#if ray.is_colliding() == false:
		#	direction *= -1
		#	ray.position.x *= -1
		
func hit():
	hp -= 1
	if hp <=0:
		dead()
	

func dead():
	isDead = true
	$CollisionShape2D.disabled = true
	velocity = Vector2(0,0)
	#anim.play("dead")
	queue_free()


