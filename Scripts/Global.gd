extends Node


# Called when the node enters the scene tree for the first time.

enum INPUT_SCHEMES { MOUSE_AND_KEYBOARD, GAMEPAD }
static var INPUT_SCHEME: INPUT_SCHEMES = INPUT_SCHEMES.MOUSE_AND_KEYBOARD


func _input(event):
	if event is InputEventJoypadMotion or event is InputEventJoypadButton and INPUT_SCHEME != INPUT_SCHEMES.GAMEPAD:
		return
	
	if event is InputEventMouseMotion or event is InputEventMouseButton and INPUT_SCHEME != INPUT_SCHEMES.MOUSE_AND_KEYBOARD:
		return	
		
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func knockback(mesh_global_position, direction):
	var tween = create_tween()
	tween.tween_property(self, "global_position", mesh_global_position - (direction / 1.5), 0.2)
	
