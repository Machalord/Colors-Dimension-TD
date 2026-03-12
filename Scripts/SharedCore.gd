extends Area2D
class_name SharedCore

## Shared core that damages the global core health when enemies reach it

@export var world_id: int = 0
@export var damage_per_enemy: int = 10

func _on_body_entered(body: Node2D) -> void:
	# Check if it's an enemy
	if body.is_in_group("Enemy"):
        
		var wm = get_tree().root.get_node("WorldManager")
		if wm:
			wm.damage_shared_core(damage_per_enemy)
		
		# Remove the enemy
		body.queue_free()
		print("Enemy reached core! World ", world_id, " dealt ", damage_per_enemy, " damage")
