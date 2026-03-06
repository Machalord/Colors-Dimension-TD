extends Area2D

@export var shootColdown: float = 0.2
@export var bullet_prefab: PackedScene = preload("res://Prefabs/bullet.tscn")

var currentTarget: PathFollow2D

var targetsOnRange:Array=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ShootTimer.wait_time=shootColdown
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
		
		print(currentTarget.name)
	
	if body.owner and body.owner is PathFollow2D:
		targetsOnRange.append(body.owner)
		if body.owner.progress_ratio >currentTarget.progress_ratio:
			currentTarget=body.owner
	
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body.owner in targetsOnRange:
		targetsOnRange.erase(body.owner)
		
	if currentTarget==body.owner:
		currentTarget=null
		SelectNewTarget()	
	
	
	pass # Replace with function body.
	
func SelectNewTarget()->void:
	
	if targetsOnRange.is_empty():
		currentTarget=null
		return
		
	var bestTarget=targetsOnRange[0]
	
	for target in targetsOnRange:
			if target.progress_ratio>bestTarget.progress_ratio:
				bestTarget=target	
		
	currentTarget=bestTarget
		


func _on_shoot_timer_timeout() -> void:
	if currentTarget:
		Shoot()
	pass # Replace with function body.
