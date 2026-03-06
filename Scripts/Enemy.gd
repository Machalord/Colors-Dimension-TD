extends PathFollow2D

@export var  speed:=60


var life:int = 100

var isDeath: bool = false


func _physics_process(delta: float) -> void:
	
	progress= progress + (speed * delta)
	
	if(progress_ratio>=0.99):
		queue_free()
		
func Hit(amount:int)->void:
	life-=amount
	
	print("life: ",life)
	
	if life<=0:
		isDeath=true
		queue_free()		
