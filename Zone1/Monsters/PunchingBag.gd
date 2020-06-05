extends RigidBody2D
var hit = false
var force_applied = false

var hit_force = -500
var hit_duration = 0.5

func _process(delta):
	if hit:
		
		hit = false
		if !force_applied:
			force_applied = true
			if global.player_global_pos.x < global_position.x:
				applied_force = Vector2(-hit_force,hit_force)
				wait()
			else:
				applied_force = Vector2(hit_force,hit_force)
				wait()
		print(applied_force)

func wait():
	yield(get_tree().create_timer(hit_duration),"timeout")
	applied_force = Vector2()
	force_applied = false


func _on_Hitbox_area_entered(area):
	if area.is_in_group("sword"):
		hit = true
