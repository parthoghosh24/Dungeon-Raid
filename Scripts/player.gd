extends CharacterBody3D


const JUMP_VELOCITY = 9
const ACCELERATION = 15
const RUN_SPEED = 6
const WALK_SPEED = 3

enum ANIM_STATES {
	IDLE,
	RUN,
	ATTACK
}

@onready var player_mesh = $Rogue
@onready var pivot = $CameraOrigin/CamH
@export var sensitivity = 0.5

@onready var animation_tree = $AnimationTree
@onready var attack_timer = $AttackTimer
@onready var is_attacking = false
var hp = 10


var direction
var movement_speed = 0
var vertical_velocity = Vector3()
var horizontal_velocity = Vector3()
var combo_counter = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	direction = Vector3.BACK.rotated(Vector3.UP, pivot.global_transform.basis.get_euler().y)
	movement_speed = 0
	animation_tree.set("parameters/idle_move/blend_amount", 0)
		

func _physics_process(delta):
		
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	# Add gravity	
	if !is_on_floor():
		vertical_velocity += Vector3.DOWN * gravity * 2 * delta
	else:
		vertical_velocity = Vector3.DOWN * gravity/10
		
	if Input.is_action_pressed("jump") and is_on_floor():
		animation_tree.set("parameters/move_jump/active", true)
		animation_tree.set("parameters/move_jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		vertical_velocity = Vector3.UP * JUMP_VELOCITY
	else:
		animation_tree.set("parameters/move_jump/active", false)

	var h_rot = pivot.global_transform.basis.get_euler().y
	
	# Get the input direction and handle the movement/deceleration.
	var action_pressed_check = Input.is_action_pressed("forward") || Input.is_action_pressed("back") || Input.is_action_pressed("left") || Input.is_action_pressed("right") 
	if action_pressed_check:
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"), 0,  Input.get_action_strength("forward") - Input.get_action_strength("back"))
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
		animation_tree.set("parameters/idle_move/blend_amount", 1)
		if Input.is_action_pressed("run"):
			movement_speed = RUN_SPEED
			animation_tree.set("parameters/walk_run/blend_amount", 1)
		else:
			movement_speed = WALK_SPEED
			animation_tree.set("parameters/walk_run/blend_amount", 0)
	else:
		movement_speed = 0
		animation_tree.set("parameters/idle_move/blend_amount", 0)
		
	
	# Attack combo system	
	if Input.is_action_just_pressed("attack") and combo_counter < 3:
		animation_tree.set("parameters/move_attack/blend_amount", 1)
		is_attacking = true
		match combo_counter:
			0:
				animation_tree.set("parameters/attacks/transition_request", "attack_chop")
			1:	
				animation_tree.set("parameters/attacks/transition_request", "attack_diag")
			2:
				animation_tree.set("parameters/attacks/transition_request", "attack_spin")
		combo_counter += 1
		attack_timer.start()
		
		
	player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta * ACCELERATION)	
	
	horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * movement_speed, ACCELERATION * delta)
			
	velocity.z = horizontal_velocity.z + vertical_velocity.z
	velocity.x = horizontal_velocity.x + vertical_velocity.x
	velocity.y = vertical_velocity.y

	move_and_slide()


func damage():
	hp -= 2
	print(hp)
	
	knockback(direction)
	
	if (hp <= 0):
		print("dead")

func knockback(dir):
	#knocback
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position - (dir / 1.5), 0.2)	
	
func _on_attack_timer_timeout():
	is_attacking = false
	combo_counter = 0
	animation_tree.set("parameters/move_attack/blend_amount", 0)


func _on_hit_box_body_entered(body):
	if body.is_in_group("monster") and is_attacking:
		body.damage()
