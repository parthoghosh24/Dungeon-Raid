extends Node3D

@onready var player_detected: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	print("i am called")
	player_detected = false
	Global.set_level(1)
	Global.save_game(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
