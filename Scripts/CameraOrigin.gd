extends Node3D

var cam_h: float = 0
var cam_v: float = 0


@export var cam_v_max: int = 75
@export var cam_v_min: int = -55


var h_sensitivity: float = 0.01
var v_sensitivity: float = 0.01

var h_acceleration: float = 10.0
var v_acceleration: float = 10.0


# Called when the node enters the scene tree for the first time.

func _input(event: InputEvent) -> void:
	if Global.INPUT_SCHEME == Global.INPUT_SCHEMES.MOUSE_AND_KEYBOARD and event is InputEventMouseMotion:
		cam_h += -event.relative.x * h_sensitivity
		cam_v += event.relative.y * v_sensitivity
			
		
func _process(delta: float) -> void:
	# Handling mouse
	if Global.INPUT_SCHEME == Global.INPUT_SCHEMES.MOUSE_AND_KEYBOARD:
		cam_v = clamp(cam_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
		$CamH.rotation.y = lerpf($CamH.rotation.y, cam_h, delta * h_acceleration)
		$CamH/CamV.rotation.x = lerpf($CamH/CamV.rotation.x, cam_v, delta * v_acceleration)
	
	# Handling Joypad
	if Global.INPUT_SCHEME == Global.INPUT_SCHEMES.GAMEPAD:
		if Input.is_action_pressed("cam_rot_left"):
			rotation.y += 1.5 * delta
		if Input.is_action_pressed("cam_rot_right"):
			rotation.y -= 1.5 * delta
		if Input.is_action_pressed("cam_rot_up"):
			rotation.x -= 0.5 * delta
			
		if Input.is_action_pressed("cam_rot_down"):
			rotation.x += 0.5 * delta
	
