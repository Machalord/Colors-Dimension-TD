extends Node

## Global manager for multi-world tower defense
## Handles world switching, shared core health, and game state

# World configuration
var world_count: int = 2
var current_world_id: int = 0

# Shared core health
var max_core_health: int = 100
var current_core_health: int = 100

# Game state
var is_game_over: bool = false

# World references (populated by game scene)
var worlds: Array[Node2D] = []

# Signals
signal world_changed(from_id: int, to_id: int)
signal core_health_changed(current: int, max: int)
signal game_over()

func _ready() -> void:
	# Initialize core health
	current_core_health = max_core_health

func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	# Specifically check for TAB key
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_TAB:
			switch_world()

func switch_world() -> void:
	if is_game_over:
		return
	
	var from_id = current_world_id
	current_world_id = (current_world_id + 1) % world_count
	
	# Update world visibility
	_update_world_visibility()
	
	# Emit signal
	world_changed.emit(from_id, current_world_id)
	
	print("World switched: ", from_id, " -> ", current_world_id)

func _update_world_visibility() -> void:
	for i in range(worlds.size()):
		if worlds[i] != null:
			worlds[i].visible = (i == current_world_id)
			# Also update camera target if the world has a camera
			var camera = worlds[i].get_node_or_null("Camera2D")
			if camera and i == current_world_id:
				camera.make_current()

func register_world(world: Node2D, world_id: int) -> void:
	# Ensure array is large enough
	while worlds.size() <= world_id:
		worlds.append(null)
	
	worlds[world_id] = world
	world.visible = (world_id == current_world_id)
	
	print("World registered: ID=", world_id)

func damage_shared_core(amount: int) -> void:
	if is_game_over:
		return
	
	current_core_health -= amount
	current_core_health = max(0, current_core_health)
	
	core_health_changed.emit(current_core_health, max_core_health)
	
	print("Core damaged! Health: ", current_core_health, "/", max_core_health)
	
	if current_core_health <= 0:
		trigger_game_over()

func heal_shared_core(amount: int) -> void:
	if is_game_over:
		return
	
	current_core_health += amount
	current_core_health = min(max_core_health, current_core_health)
	
	core_health_changed.emit(current_core_health, max_core_health)

func trigger_game_over() -> void:
	is_game_over = true
	game_over.emit()
	print("GAME OVER!")

func restart_game() -> void:
	is_game_over = false
	current_core_health = max_core_health
	current_world_id = 0
	
	core_health_changed.emit(current_core_health, max_core_health)
	_update_world_visibility()
	
	print("Game restarted!")

func get_current_world() -> Node2D:
	if current_world_id < worlds.size():
		return worlds[current_world_id]
	return null

func is_world_active(world_id: int) -> bool:
	return world_id == current_world_id
