extends Area2D


@export var bullet_prefab: PackedScene = preload("res://Prefabs/bullet.tscn")

var currentTarget: PathFollow2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if currentTarget:
		look_at(currentTarget.global_position)
		
	pass
	
	
func Shoot()->void:
	var newBullet = bullet_prefab.instantiate()
	
	newBullet.global_position=$BulletSpawnPoint.global_position
	
	var direction= (currentTarget.global_position-$BulletSpawnPoint.global_position).normalized()
	
	newBullet.direction=direction
	
	get_tree().root.add_child(newBullet)


func _on_body_entered(body: Node2D) -> void:
	
	
	if !currentTarget:
		currentTarget=body.owner
	
	if body.owner and body.owner is PathFollow2D:
		if body.owner.progress_ratio >currentTarget.progress_ratio:
			currentTarget=body
	
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	currentTarget=null
	pass # Replace with function body.


func _on_shoot_timer_timeout() -> void:
	if currentTarget:
		Shoot()
	pass # Replace with function body.
