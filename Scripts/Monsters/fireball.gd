extends Area3D

var direction = Vector3.ZERO
var damage = 1
var speed =  1
@onready var fireball_sfx = $FireballSFX

func _init():
	collision_layer = 3
	collision_mask = 0
	

func _ready():
	scale *= 2
	global_position += Vector3(0,6,0)
	fireball_sfx.play()

func _physics_process(delta):
	global_position += direction * speed * delta
			


func _on_body_entered(body):
	queue_free()
