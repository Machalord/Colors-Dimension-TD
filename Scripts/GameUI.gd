extends CanvasLayer
class_name GameUI

## UI for displaying world indicator and core health

@onready var world_label: Label = $WorldIndicator/Label
@onready var core_health_bar: ProgressBar = $CoreHealth/ProgressBar

func _ready() -> void:
	# Connect to WorldManager signals
	var wm = get_tree().root.get_node("WorldManager")
	if wm:
		wm.world_changed.connect(_on_world_changed)
		wm.core_health_changed.connect(_on_core_health_changed)
		wm.game_over.connect(_on_game_over)
		
		# Initial update
		_update_world_indicator(wm.current_world_id)
		_update_core_health(wm.current_core_health, wm.max_core_health)

func _on_world_changed(from_id: int, to_id: int) -> void:
	_update_world_indicator(to_id)

func _on_core_health_changed(current: int, max: int) -> void:
	_update_core_health(current, max)

func _on_game_over() -> void:
	world_label.text = "GAME OVER"

func _update_world_indicator(world_id: int) -> void:
	world_label.text = "World " + str(world_id + 1)

func _update_core_health(current: int, max: int) -> void:
	core_health_bar.max_value = max
	core_health_bar.value = current
