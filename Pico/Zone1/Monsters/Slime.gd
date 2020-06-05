extends KinematicBody2D

onready var anim = $AnimationPlayer

var speed = 20
var hp = 6


var invinsibility = false
var can_move = false



#MONSTERS
func _ready():
	global.local_enemy += 1
	yield(get_tree().create_timer(global.time_before_activation),"timeout")
	can_move = true

func follown():
	#if global_position.distance_to(what.global_position)
	var distance : Vector2 = (global.player_position - global_position)
	move_and_slide(speed * distance.normalized())
	
func _process(delta):
	if can_move:
		follown()
		global.last_enemy_pos = position

func hit(damage):
	if !invinsibility:
		hp -= damage
		anim.play("hit")
	if hp <=0:
		dead()

func recovery(time):
	invinsibility = true
	yield(get_tree().create_timer(time),"timeout")
	invinsibility = false

func dead():
	global.local_enemy -= 2
	queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("mele_attack"):
		hit(global.mele_damage)
		recovery(global.mele_attack_rate/2)
	if area.is_in_group("bullet"):
		hit(global.bullet_damage)
	if area.is_in_group("dash"):
		hit(global.dash_damage)


