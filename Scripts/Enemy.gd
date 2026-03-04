extends CharacterBody2D

const  speed:=60

@onready var enemy_path: PathFollow2D = get_parent()

var life:int = 100

var isDeath: bool = false


func _physics_process(delta: float) -> void:
	
	enemy_path.progress= enemy_path.progress + (speed * delta)
	
	if(enemy_path.progress_ratio>=0.99):
		queue_free()
		
func Hit(amount:int)->void:
	life-=amount
	
	if life<=0:
		isDeath=true		
