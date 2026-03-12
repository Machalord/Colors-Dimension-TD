extends Area2D

@export var damage:int =10
@export var speed:int =10
@export var world_id: int = 0  # Which world this bullet belongs to

var direction:Vector2 = Vector2.RIGHT

func _ready() -> void:
	var wm = get_tree().root.get_node_or_null("WorldManager")
	if wm:
		wm.world_changed.connect(_on_world_changed)
		visible = (wm.current_world_id == world_id)

func _on_world_changed(from_id: int, to_id: int) -> void:
	visible = (to_id == world_id)

func _process(delta: float) -> void:
	var wm = get_tree().root.get_node_or_null("WorldManager")
	if wm and wm.current_world_id != world_id:
		return
	
	position+=direction*speed*delta

func _on_body_entered(body: Node2D) -> void: 
	if body.owner and body.owner.is_in_group("Enemy"):
		if body.owner.world_id != world_id:
			return
		
		if body.owner.has_method("Hit"):
			body.owner.Hit(damage)
		queue_free()		

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
