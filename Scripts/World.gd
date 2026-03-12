extends Node2D
class_name World

## World container that registers with WorldManager

@export var world_id: int = 0

func _ready() -> void:
	# Register this world with the WorldManager
	var wm = get_tree().root.get_node("WorldManager")
	if wm:
		wm.register_world(self, world_id)
		print("World ", world_id, " registered with WorldManager")
