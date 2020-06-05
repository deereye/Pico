extends RigidBody2D
export(int) var hp = 10

var hit = false


func _process(delta):
	if hit:
		hp -= 1
		if hp>0:
			$AnimationPlayer.play("Hit")
			hit = false
		elif hp <=0:
			$AnimationPlayer.play("Death")




func _on_Hitbox_area_entered(area):
	if area.is_in_group("sword"):
		hit = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		queue_free()
