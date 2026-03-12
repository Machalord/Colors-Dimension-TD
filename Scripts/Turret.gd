extends Area2D

@export var shootColdown: float = 0.2
@export var bullet_prefab: PackedScene = preload("res://Prefabs/bullet.tscn")
@export var world_id: int = 0  # Which world this turret belongs to

var currentTarget: PathFollow2D

var targetsOnRange:Array=[]

func _ready() -> void:
	$ShootTimer.wait_time=shootColdown
	
	# Listen for world changes to update visibility
	var wm = get_tree().root.get_node_or_null("WorldManager")
	if wm:
		wm.world_changed.connect(_on_world_changed)
		visible = (wm.current_world_id == world_id)

func _on_world_changed(from_id: int, to_id: int) -> void:
	visible = (to_id == world_id)

func _process(delta: float) -> void:
	if is_instance_valid(currentTarget):
		look_at(currentTarget.global_position)
	else:
		SelectNewTarget()		

func Shoot()->void:
	var newBullet = bullet_prefab.instantiate()
	
	newBullet.global_position=$BulletSpawnPoint.global_position
	
	var direction= (currentTarget.global_position-$BulletSpawnPoint.global_position).normalized()
	
	newBullet.direction=direction
	newBullet.world_id = world_id
	
	# Add bullet to the correct world
	var wm = get_tree().root.get_node("WorldManager")
	if wm:
		var current_world = wm.get_current_world()
		if current_world:
			current_world.add_child(newBullet)
		else:
			get_tree().root.add_child(newBullet)
	else:
		get_tree().root.add_child(newBullet)

func _on_body_entered(body: Node2D) -> void:
	if body.owner and body.owner is PathFollow2D:
		if body.owner.world_id != world_id:
			return
		
		if !currentTarget:
			currentTarget=body.owner
			print(currentTarget.name)
		
		targetsOnRange.append(body.owner)
		if body.owner.progress_ratio >currentTarget.progress_ratio:
			currentTarget=body.owner

func _on_body_exited(body: Node2D) -> void:
	if body.owner in targetsOnRange:
		targetsOnRange.erase(body.owner)
		
	if currentTarget==body.owner:
		currentTarget=null
		SelectNewTarget()	
		
func SelectNewTarget()->void:
	var i=targetsOnRange.size()-1	
	
	while i>=0:
		if not is_instance_valid(targetsOnRange[i]):
				targetsOnRange.remove_at(i)
		i-=1			
	
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
