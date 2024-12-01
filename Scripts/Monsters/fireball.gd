extends Area3D

var direction: Vector3 = Vector3.ZERO
var damage: int = 1
var speed: int =  1
@onready var fireball_sfx: AudioStreamPlayer3D= $FireballSFX
@onready var collision_shape: CollisionShape3D =$CollisionShape3D

func _init() -> void:
	collision_layer = 3
	collision_mask = 0
	

func _ready() -> void:
	name = "Fireball"
	collision_layer = 3
	collision_mask = 0
	scale /= 2
	global_position += Vector3(0,6,0)
	fireball_sfx.play()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

				
