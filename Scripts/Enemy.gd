extends PathFollow2D

@export var speed:=60
@export var world_id: int = 0  # Which world this enemy belongs to

var life:int = 100
var isDeath: bool = false

func _ready() -> void:
	# Listen for world changes to update visibility
	var wm = get_tree().root.get_node_or_null("WorldManager")
	if wm:
		wm.world_changed.connect(_on_world_changed)
		# Set initial visibility based on current world
		visible = (wm.current_world_id == world_id)

func _on_world_changed(from_id: int, to_id: int) -> void:
	# Only show enemy if it's in the active world
	visible = (to_id == world_id)

func _physics_process(delta: float) -> void:
	# Only move if enemy is in the active world
	var wm = get_tree().root.get_node_or_null("WorldManager")
	if wm and wm.current_world_id != world_id:
		return
	
	progress= progress + (speed * delta)
	
	if(progress_ratio>=0.99):
		# Enemy reached the core - damage shared core
		var world_manager = get_tree().root.get_node("WorldManager")
		if world_manager:
			world_manager.damage_shared_core(10)
		queue_free()
		
func Hit(amount:int)->void:
	life-=amount
	
	print("life: ",life)
	
	if life<=0:
		isDeath=true
		queue_free()		
