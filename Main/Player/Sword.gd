extends Position2D
onready var sprites = $AnimatedSprite

var in_combo = false
var combo = 0
var can_attack = true
var time_btw_attack = 1

func _input(event):
	if Input.is_action_just_pressed("attack") and can_attack:
		attack()
		can_attack = false

func attack():
	global.attacking = true
	$AnimatedSprite.visible = true
	$Area2D/CollisionShape2D.disabled = false
	sprites.play("attack1")
	$AnimatedSprite.visible = true

func _on_AnimationPlayer_animation_finished(anim_name):
	can_attack = true
	global.attacking = false
	$AnimatedSprite.visible = false
	$Area2D/CollisionShape2D.disabled = true
