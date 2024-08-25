extends Node3D

var cam_h = 0
var cam_v = 0


@export var cam_v_max = 75
@export var cam_v_min = -55


var h_sensitivity = 0.01
var v_sensitivity = 0.01

var h_acceleration = 10.0
var v_acceleration = 10.0


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _input(event):
	if event is InputEventMouseMotion:
		cam_h += -event.relative.x * h_sensitivity
		cam_v += event.relative.y * v_sensitivity
			
		
func _process(delta):
	# Handling mouse
	cam_v = clamp(cam_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
	$CamH.rotation.y = lerpf($CamH.rotation.y, cam_h, delta * h_acceleration)
	$CamH/CamV.rotation.x = lerpf($CamH/CamV.rotation.x, cam_v, delta * v_acceleration)	
	
	# Handling Joypad
	if Input.is_action_pressed("cam_rot_left"):
		rotation.y += 1.0 * delta
	if Input.is_action_pressed("cam_rot_right"):
		rotation.y -= 1.0 * delta
	if Input.is_action_pressed("cam_rot_up"):
		rotation.x -= 0.5 * delta
		
	if Input.is_action_pressed("cam_rot_down"):
		rotation.x += 0.5 * delta
	
