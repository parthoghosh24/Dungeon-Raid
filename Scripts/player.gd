extends CharacterBody3D


const JUMP_VELOCITY: int = 9
const ACCELERATION: int = 15
const RUN_SPEED: int = 8
const WALK_SPEED: int = 3

enum ANIM_STATES {
	IDLE,
	RUN,
	ATTACK
}

@onready var player_mesh: Node3D = $Rogue
@onready var pivot: Node3D = $CameraOrigin/CamH
@export var sensitivity: float = 0.5

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var attack_timer: Timer = $AttackTimer
@onready var is_attacking: bool = false
@onready var hp_bar: TextureProgressBar = $PlayerHealthbar
@onready var death_timer: Timer = $DeathTimer
@onready var heal_audio: AudioStreamPlayer = $Sfx/HealAudio
@onready var interaction_ray: RayCast3D = $InteractionRay
@onready var interaction_prompt_scn: PackedScene = preload("res://Scenes/Menu/interaction_prompt.tscn")
var interaction_prompt: Node3D
var interactive_object: StaticBody3D


var direction: Vector3
var movement_speed: int = 0
var vertical_velocity: Vector3 = Vector3()
var horizontal_velocity: Vector3 = Vector3()
var combo_counter: int = 0

signal player_dead

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interaction_prompt =  interaction_prompt_scn.instantiate()
	direction = Vector3.BACK.rotated(Vector3.UP, pivot.global_transform.basis.get_euler().y)
	movement_speed = 0
	animation_tree.set("parameters/idle_move/blend_amount", 0)
	animation_tree.set("parameters/hit_death/blend_amount",0)
		

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		var pause_menu = preload("res://Scenes/Menu/pause_menu.tscn").instantiate()
		get_tree().paused = true
		get_tree().root.add_child(pause_menu)
	
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
		
	# Stealth attack
	if Input.is_action_pressed("stealth_attack"):
		animation_tree.set("parameters/Stealth_hit/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	# Use	
	if Input.is_action_just_pressed("use"):
		animation_tree.set("parameters/interact_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		interact()
		
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
	interaction_ray.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta * ACCELERATION)
	
	if interaction_ray.is_colliding():
		invoke_interaction(interaction_ray.get_collider())
	
		
	
	horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * movement_speed, ACCELERATION * delta)
			
	velocity.z = horizontal_velocity.z + vertical_velocity.z
	velocity.x = horizontal_velocity.x + vertical_velocity.x
	velocity.y = vertical_velocity.y

	move_and_slide()

func interact() -> void:
	if interactive_object:
		owner.update_interactions(interactive_object.name)
		if interactive_object.name == "MiniBossFightDoor":
			Global.play_level_cutscene()
			global_position = Vector3(-1.926, 10.092, 55.988)
			return
		if interactive_object.name == "BarbarianBed":
			Global.play_level_cutscene()
			return
		if interactive_object.name == "NextLevelDoor" and Global.get_player_inventory() == Global.PLAYER_INVENTORY_ITEMS.DOOR_KEY:
			owner.stop_level_timer()
			Global.switch_to_score_board()
			return
		if interactive_object.name == "KeyRingHanging":
			interactive_object.owner.show_interaction_mode(true)
		else:	
			interactive_object.owner.show_interaction_mode()
		

func invoke_interaction(collider) -> void:
	var colliders = ["ChestGoldArea",
					 "SwordShieldGold",
					 "TableLongBroken",
					 "KeyRingHanging",
					 "FoodTable",
					 "BarrelLarge",
					 "BedDecorated",
					 "NextLevelDoor",
					 "Tree",
					 "Chest",
					 "Axe",
					 "Stool",
					 "BarbarianBed",
					 "Spike",
					 "MiniBossFightDoor",
					]
	if collider and collider.name in colliders:
		interactive_object = collider
		interaction_prompt.global_position = self.global_position + Vector3(0, 2, 0)
		self.add_child(interaction_prompt)
	else:
		interactive_object = null
		if is_instance_valid(interaction_prompt):
			self.remove_child(interaction_prompt)
			
		
func damage(damage_value: int, knockback_override: int = 1) -> void:
	hp_bar.value -= damage_value
	Global.update_player_score(Global.HITS_TAKEN, -50)
	knockback(direction, knockback_override)
	animation_tree.set("parameters/attack_hit/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	if (hp_bar.value <= 0):
		animation_tree.set("parameters/hit_death/blend_amount",1)
		death_timer.start()
		
func heal_up(health_vial: Node3D, value: int) -> void:
	if hp_bar.value < hp_bar.max_value - 1:
		hp_bar.value += value
		if !heal_audio.is_playing():
			heal_audio.play()
		health_vial.queue_free()

func knockback(dir: Vector3,knockback_override: int = 1) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position - ((dir * knockback_override) / 1.5), 0.2)	
	
func _on_attack_timer_timeout() -> void:
	is_attacking = false
	combo_counter = 0
	animation_tree.set("parameters/move_attack/blend_amount", 0)
		

func _on_death_timer_timeout() -> void:
	emit_signal("player_dead")
	
func dead() -> void:
	hp_bar.value = 0
	animation_tree.set("parameters/hit_death/blend_amount",1)
	death_timer.start()
