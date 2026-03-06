extends Area2D


@export var damage:int =10

@export var speed:int =10

var direction:Vector2 = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	position+=direction*speed*delta
	pass


func _on_body_entered(body: Node2D) -> void: 
	if body.owner.is_in_group("Enemy"):
		if body.owner.has_method("Hit"):
			body.owner.Hit(damage)
		queue_free()	
			
		
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()	
	pass # Replace with function body.
