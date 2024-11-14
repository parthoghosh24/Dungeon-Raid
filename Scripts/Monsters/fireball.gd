extends Area3D

var direction = Vector3.ZERO
var damage = 1
var speed =  1

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		self.queue_free()
			
