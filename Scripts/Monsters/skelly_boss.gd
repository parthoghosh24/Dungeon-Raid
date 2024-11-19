extends CharacterBody3D

@export var player_path : NodePath
@onready var animation_tree = $AnimationTree
@onready var nav_agent = $NavigationAgent3D
@onready var health_bar = $HealthBar/BossHealthBar
@onready var idle_timer = $Timers/IdleTimer
@onready var attack_timer = $Timers/AttackTimer
@onready var jump_attack_timer = $Timers/JumpAttackTimer
@onready var jump_attack_wait_timer = $Timers/JumpAttackWaitTimer
@onready var hurt_box = $HurtBox/CollisionShape3D
@onready var aim = $Skeleton_Mage/Aim
@onready var fireball = preload("res://Scenes/Monsters/fireball.tscn")
@onready var attack_ray = $AttackRay

var attacking = false
var jump_attacking = false
var player_in_range = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dir
var speed
var player
var period = 0.3
var magnitude = 0.1
var vertical_velocity = Vector3()

# Algo for phased boss behaviour
# 100 - 75% health, attack
# 75 -50% health, block, attack
# 50-0% health, block,dodge, taunt, attack

func _ready():
	player = get_node(player_path)
	animation_tree.state = animation_tree.ATTACK
	
func _physics_process(delta):

	look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
	
	if attack_ray.is_colliding() and attack_ray.get_collider().is_in_group("player") and jump_attack_wait_timer.is_stopped():
		attacking = false
		jump_attacking = false
		jump_attack_wait_timer.start()

	if animation_tree.state == animation_tree.IDLE and idle_timer.is_stopped():
		attacking = false
		jump_attacking = false
		animation_tree.get("parameters/playback").travel("Idle")
		idle_timer.start()
	
	if animation_tree.state == animation_tree.ATTACK and !attacking:
		attacking = true
		shoot(delta)
		attack_timer.start()
	
	if animation_tree.state == animation_tree.JUMP_ATTACK and !attacking and !jump_attacking:
		animation_tree.get("parameters/playback").travel("Jump_attack")
		attacking = true
		jump_attacking = true
		jump_attack_timer.start()
	
	if animation_tree.state == animation_tree.HIT:
		shake_camera()
		if health_bar.value <=0:
			pass
		else:
			health_bar.value -= deplete_health()
			animation_tree.state = animation_tree.IDLE
		

func jump_attack_damage():
	if player.is_on_floor():
		player.damage(10,15)

func shoot(delta):
	animation_tree.get("parameters/playback").travel("Attack")
	var firing_position = aim.global_position
	aim.look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
	var target_position = (player.global_position - firing_position).normalized()
	#create fireball
	var fireball_object = fireball.instantiate()
	fireball_object.speed = 5
	fireball_object.direction = target_position
	fireball_object.global_position = aim.global_position
	fireball_object.global_rotation = aim.global_rotation
	fireball_object.look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
	
	aim.add_child(fireball_object)
	await get_node("AnimationTree").animation_finished
		
func deplete_health():
	var health_left = health_left()
	if health_left >= 0.75 and health_left() <= 1:
		return 10
	if health_left >= 0.50 and health_left() < 0.75:
		return 5
	if health_left >= 0.25 and health_left() < 0.50:
		return 4
	if health_left >= 0 and health_left() < 0.25:
		return 2
	
func damage():
	animation_tree.state = animation_tree.HIT

func dead():
	health_bar.value = 0
	# Trigger end cutscene
	pass

func health_left():
	return health_bar.value/(health_bar.max_value * 1.0	)


func _on_idle_timer_timeout():
	animation_tree.state = animation_tree.ATTACK


func _on_attack_timer_timeout():
	attacking = false
	animation_tree.state = animation_tree.IDLE

func apply_shake():
	var initial_transform = self.transform 
	var elapsed_time = 0.0

	while elapsed_time < period:
		var offset = Vector3(
			randf_range(-magnitude, magnitude),
			randf_range(-magnitude, magnitude),
			0.0
		)

		self.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.transform = initial_transform


func shake_camera():
	get_viewport().get_camera_3d().apply_shake()


func _on_jump_attack_timer_timeout():
	if !is_on_floor():
		velocity.y -=  gravity * 2
	else:
		velocity = Vector3.DOWN * gravity/10
	attacking = false
	jump_attacking = false
	animation_tree.state = animation_tree.IDLE

func _on_hurt_box_area_entered(area):
	if area == null or area.name != "HaiyaHitBox":
		return
	if area.name == "HaiyaHitBox" and has_method("damage") and !jump_attacking:
		damage()


func _on_jump_attack_wait_timer_timeout():
	animation_tree.state = animation_tree.JUMP_ATTACK
