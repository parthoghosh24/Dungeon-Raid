extends CharacterBody3D

@export var player_path : NodePath
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var health_bar: TextureProgressBar = $HealthBar/EnemyHealthBar
@onready var death_timer: Timer = $Timers/DeathTimer
@onready var idle_timer: Timer = $Timers/IdleTimer
@onready var dodge_timer: Timer = $Timers/DodgeTimer
@onready var attack_timer: Timer = $Timers/AttackTimer
@onready var player_attack: Area3D = $PlayerAttack
@onready var hurt_box: CollisionShape3D = $HurtBox/CollisionShape3D
@onready var health_vial: PackedScene = preload("res://Scenes/Environment/health_vial.tscn")
@onready var keyring: PackedScene = preload("res://Scenes/Environment/keyring_hanging.tscn")

var attacking: bool = false
var player_in_range: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var run_speed: int = 35
var dir: Vector3
var speed: float
var player: Node

# Algo for phased boss behaviour
# 100 - 75% health, attack
# 75 -50% health, block, attack
# 50-0% health, block,dodge, taunt, attack

func _ready() -> void:
	player = get_node(player_path)
	animation_tree.state = animation_tree.RUN
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
			velocity.y -=  gravity * delta
	if animation_tree.state == animation_tree.RUN and !attacking:
		speed = run_speed
		animation_tree.get("parameters/playback").travel("Run")
		nav_agent.target_position = player.global_position
		var next_nav_point = nav_agent.get_next_path_position()
		dir = next_nav_point - global_position
		velocity = dir.normalized() * speed * delta * gravity
		velocity.y = velocity.y - (gravity * delta)
		look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
		move_and_slide()

	if animation_tree.state == animation_tree.HIT:
		animation_tree.get("parameters/playback").travel("Hit")
		if health_bar.value <=0:
			dead()
		else:
			health_bar.value -= deplete_health()
			animation_tree.state = animation_tree.IDLE
	
	if animation_tree.state == animation_tree.ATTACK1 and !attacking:
		attacking = true
		animation_tree.get("parameters/playback").travel("Attack1")
		attack_timer.wait_time = attack_timer_wait()
		attack_timer.start()
		
	
	if animation_tree.state == animation_tree.ATTACK2 and !attacking:
		attacking = true
		animation_tree.get("parameters/playback").travel("Attack2")
		attack_timer.wait_time = attack_timer_wait()
		attack_timer.start()
		
	if animation_tree.state == animation_tree.ATTACK3 and !attacking:
		attacking = true
		animation_tree.get("parameters/playback").travel("Attack3")
		attack_timer.wait_time = attack_timer_wait()
		attack_timer.start()
	
	if animation_tree.state == animation_tree.COMBO and !attacking:
		attacking = true
		animation_tree.get("parameters/playback").travel("Attack1")
		animation_tree.get("parameters/playback").travel("Attack2")
		animation_tree.get("parameters/playback").travel("Attack3")
		attack_timer.wait_time = 4
		attack_timer.start()

	if animation_tree.state == animation_tree.IDLE and idle_timer.is_stopped():
		animation_tree.get("parameters/playback").travel("Idle")
		look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
		idle_timer.start()
	
	if animation_tree.state == animation_tree.DEAD:
		animation_tree.get("parameters/playback").travel("Dead")
		
		
func deplete_health() -> int:
	var health_left = health_left()
	if health_left >= 0.75 and health_left() <= 1:
		return 5
	if health_left >= 0.50 and health_left() < 0.75:
		return 4
	if health_left >= 0.25 and health_left() < 0.50:
		return 3
	if health_left >= 0 and health_left() < 0.25:
		return 2
	return 0	

func attack_timer_wait() -> int:
	var health_left = health_left()
	if health_left >= 0.75 and health_left() <= 1:
		return 5
	if health_left >= 0.50 and health_left() < 0.75:
		return 2
	if health_left >= 0 and health_left() < 0.50:
		return 1
	return 0	

func knockback(dir: Vector3) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position - (dir/2), 0.2)

	
func damage() -> void:
	knockback(dir)
	animation_tree.state = animation_tree.HIT

func dead() -> void:
	health_bar.value = 0
	player_attack.process_mode = Node.PROCESS_MODE_DISABLED
	animation_tree.state = animation_tree.DEAD
	death_timer.start()

func _on_player_attack_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		animation_tree.state = rand_attack()
		

func _on_player_attack_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		animation_tree.state = animation_tree.RUN

func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area == null or area.name != "HaiyaHitBox" or animation_tree.state == animation_tree.BLOCK:
		return
	if area.name == "HaiyaHitBox" and has_method("damage"):
		get_viewport().get_camera_3d().shake_camera()
		damage()

func health_left() -> float:
	return health_bar.value/(health_bar.max_value * 1.0	)


func _on_death_timer_timeout() -> void:
	#Spawn health and keyring
	var large_health = health_vial.instantiate()
	large_health.global_position = self.global_position
	self.get_parent().add_child(large_health)
	large_health.activate_vial("large_health")
	var keyring_pickup = keyring.instantiate()
	keyring_pickup.global_position = self.global_position +Vector3(0.7, 1, 0)
	self.get_parent().add_child(keyring_pickup)
	Global.update_player_score(Global.KILLS, 2000)
	
	# Free memory
	queue_free()


func _on_idle_timer_timeout() -> void:
	animation_tree.state = rand_attack()
	

func rand_attack() -> int:
	if health_left() <= 0.25:
		return animation_tree.COMBO
 
	var attack_index = (randi() % 3) + 1	
	match attack_index:
		1:
			return animation_tree.ATTACK1
		2:	
			return animation_tree.ATTACK2
		3:
			return animation_tree.ATTACK3	
	return animation_tree.ATTACK1
	
func _on_dodge_timer_timeout() -> void:
	animation_tree.state = animation_tree.RUN


func _on_attack_timer_timeout() -> void:
	attacking = false
	if player_in_range:
		animation_tree.state = rand_attack()
	else:
		animation_tree.state = animation_tree.RUN
