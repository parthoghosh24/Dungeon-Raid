extends CharacterBody3D

@export var player_path : NodePath
@onready var animation_tree = $AnimationTree
@onready var nav_agent = $NavigationAgent3D
@onready var health_bar = $HealthBar/EnemyHealthBar
@onready var idle_timer = $Timers/IdleTimer
@onready var attack_timer = $Timers/AttackTimer
@onready var player_attack = $PlayerAttack
@onready var hurt_box = $HurtBox/CollisionShape3D
@onready var aim = $Aim
@onready var fireball = preload("res://Scenes/Monsters/fireball.tscn")

var attacking = false
var player_in_range = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var run_speed = 45
var dir
var speed
var player

# Algo for phased boss behaviour
# 100 - 75% health, attack
# 75 -50% health, block, attack
# 50-0% health, block,dodge, taunt, attack

func _ready():
	player = get_node(player_path)
	animation_tree.state = animation_tree.IDLE
	
func _physics_process(delta):
	if not is_on_floor():
			velocity.y -=  gravity * delta

	if animation_tree.state == animation_tree.IDLE and idle_timer.is_stopped():
		animation_tree.get("parameters/playback").travel("Idle")
		look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
		idle_timer.start()
	
	if animation_tree.state == animation_tree.ATTACK and !attacking:
		attacking = true
		shoot()
		attack_timer.start()
	

func shoot():
	look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
	animation_tree.get("parameters/playback").travel("Attack")
	await get_tree().create_timer(0.3).timeout
	print("aim global position")
	print(aim.global_position)
	var firing_position = aim.global_position
	print("firing_position")
	print(firing_position)
	print("player_position")
	print(player.global_position)
	var target_position = (player.global_position - firing_position).normalized()
	#create fireball
	var fireball_object = fireball.instantiate()
	fireball_object.speed = 10
	fireball_object.direction = target_position
	fireball_object.global_position = firing_position
	fireball_object.global_rotation = aim.global_rotation
	fireball_object.look_at(player.global_position)
	self.get_parent().add_child(fireball_object)
	await get_node("AnimationTree").animation_finished
		
func deplete_health():
	var health_left = health_left()
	if health_left >= 0.75 and health_left() <= 1:
		return 5
	if health_left >= 0.50 and health_left() < 0.75:
		return 4
	if health_left >= 0.25 and health_left() < 0.50:
		return 3
	if health_left >= 0 and health_left() < 0.25:
		return 2

func attack_timer_wait():
	var health_left = health_left()
	if health_left >= 0.75 and health_left() <= 1:
		return 5
	if health_left >= 0.50 and health_left() < 0.75:
		return 2
	if health_left >= 0 and health_left() < 0.50:
		return 1
		

func knockback(dir):
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position - (dir/2), 0.2)

	
func damage():
	knockback(dir)
	animation_tree.state = animation_tree.HIT

func dead():
	health_bar.value = 0
	player_attack.process_mode = Node.PROCESS_MODE_DISABLED
	animation_tree.state = animation_tree.DEAD


func _on_hurt_box_area_entered(area):
	if area == null or area.name != "HaiyaHitBox" or animation_tree.state == animation_tree.BLOCK:
		return
	if area.name == "HaiyaHitBox" and has_method("damage"):
		get_viewport().get_camera_3d().shake_camera()
		damage()

func health_left():
	return health_bar.value/(health_bar.max_value * 1.0	)


func _on_idle_timer_timeout():
	animation_tree.state = animation_tree.ATTACK


func _on_attack_timer_timeout():
	attacking = false
	animation_tree.state = animation_tree.IDLE
	
