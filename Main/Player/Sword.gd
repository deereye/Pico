extends Position2D
onready var sprites = $AnimatedSprite

var in_combo = false
var combo = 0
var can_attack = true
var time_btw_attack = 0.25

func _ready():
	$AnimatedSprite.visible = false
	$AnimatedSprite.frame = 0
	$Area2D/CollisionShape2D.disabled = true

func _input(event):
	if Input.is_action_just_pressed("attack") and can_attack and !global.flying:
		attack()
		can_attack = false

func attack():
	global.attacking = true
	$AnimatedSprite.visible = true
	$Area2D/CollisionShape2D.disabled = false
	$AnimatedSprite.frame = 0
	sprites.play("attack1")
	yield(get_tree().create_timer(0.1),"timeout")
	$Area2D/CollisionShape2D.disabled = true
	wait()

func wait():
	yield(get_tree().create_timer(time_btw_attack),"timeout")
	can_attack = true
	global.attacking = false
	$AnimatedSprite.visible = false
	$AnimatedSprite.frame = 0
	$Area2D/CollisionShape2D.disabled = true
