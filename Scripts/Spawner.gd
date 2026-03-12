extends Node2D
class_name Spawner

## Enemy Spawner with wave-based system and difficulty scaling

@export var enemy_scene: PackedScene
@export var path_2d: Path2D
@export var world_id: int = 0  # Which world this spawner belongs to

## Wave configuration
@export var total_waves: int = 5
@export var enemies_per_wave: int = 5
@export var base_enemy_health: int = 100
@export var auto_start: bool = true

## Timing configuration (in seconds)
@export var time_between_waves: float = 10.0
@export var spawn_interval: float = 2.0

## Difficulty scaling
@export var health_multiplier_per_wave: float = 1.2
@export var speed_increase_per_wave: float = 5.0

## State
var current_wave: int = 0
var enemies_spawned_in_wave: int = 0
var is_spawning: bool = false
var spawn_timer: float = 0.0

## Signals
signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal all_waves_completed()
signal enemy_spawned(enemy: Node2D)

func _ready() -> void:
	if not enemy_scene:
		push_warning("Spawner: No enemy_scene assigned!")
	if not path_2d:
		push_warning("Spawner: No Path2D assigned!")
	if auto_start:
		await get_tree().create_timer(1.0).timeout  # Small delay to ensure scene is ready
		start_spawning()

func _process(delta: float) -> void:
	if is_spawning:
		spawn_timer -= delta
		if spawn_timer <= 0:
			_spawn_enemy()
			spawn_timer = spawn_interval

func start_spawning() -> void:
	if not path_2d or not enemy_scene:
		push_error("Spawner: Cannot start - missing path_2d or enemy_scene")
		return
	
	current_wave = 1
	enemies_spawned_in_wave = 0
	_start_wave()

func _start_wave() -> void:
	is_spawning = true
	enemies_spawned_in_wave = 0
	wave_started.emit(current_wave)
	print("Wave ", current_wave, " started!")

func _spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	
	# Set world_id for this enemy
	enemy.world_id = world_id
	
	# Apply difficulty scaling
	var health_bonus = int(base_enemy_health * (health_multiplier_per_wave - 1.0) * (current_wave - 1))
	enemy.life = base_enemy_health + health_bonus
	
	var speed_bonus = speed_increase_per_wave * (current_wave - 1)
	enemy.speed += speed_bonus
	
	# Add to path
	path_2d.add_child(enemy)
	enemy.position = path_2d.curve.get_point_position(0)
	
	enemies_spawned_in_wave += 1
	enemy_spawned.emit(enemy)
	
	print("Spawned enemy ", enemies_spawned_in_wave, "/", enemies_per_wave, " (Wave ", current_wave, ") - Health: ", enemy.life, " Speed: ", enemy.speed)
	
	# Check if wave is complete
	if enemies_spawned_in_wave >= enemies_per_wave:
		_complete_wave()

func _complete_wave() -> void:
	is_spawning = false
	wave_completed.emit(current_wave)
	print("Wave ", current_wave, " completed!")
	
	if current_wave >= total_waves:
		all_waves_completed.emit()
		print("All waves completed!")
	else:
		current_wave += 1
		# Wait before starting next wave
		await get_tree().create_timer(time_between_waves).timeout
		_start_wave()

func stop_spawning() -> void:
	is_spawning = false

func get_current_wave() -> int:
	return current_wave

func get_total_waves() -> int:
	return total_waves

func is_wave_active() -> bool:
	return is_spawning
