extends CharacterBody3D

var player = null
var walk_speed = 12
var run_speed = 40
var dir
var speed

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var patrol_timer = $PatrolTimer
@onready var anim_tree = $AnimationTree
@onready var player_detection = $PlayerDetection
@onready var attack_detection = $AttackDetection
@onready var death_timer = $DeathTimer
@onready var attack_timer = $AttackTimer
@onready var visual_cast =$VisualCast
@onready var health_bar = $HealthBar/EnemyHealthBar
@onready var stealth_prompt = $StealthHit/TextureRect
@onready var health_vial = preload("res://Scenes/Environment/health_vial.tscn")
@onready var keyring = preload("res://Scenes/Environment/keyring_hanging.tscn")
@onready var chase_timer = $ChaseTimer
@export var has_key: bool
@onready var keyring_attached = $Skeleton_Rogue/Rig/Skeleton3D/Key/keyring2

var player_in_attack_range = false
var looking_at_player = false
var level

var waypoints = []
var waypoint_index
var player_body

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


enum States {
	patrol,
	wait,
	chase,
	attack,
	damaged,
	die
}

var current_state : States

signal skelly_dead

func _ready():
	if has_key && has_key == true:
		keyring_attached.visible = true
	else:
		keyring_attached.visible = false	
	stealth_prompt.visible = false
	level = get_parent().get_parent().get_parent()
	waypoint_index = 0
	player = get_node(player_path)
	current_state = States.patrol
	for node in $"../MarkersToVisit".get_children():
		waypoints.append(node.global_position + Vector3.UP)
	nav_agent.target_position = waypoints[waypoint_index]
	anim_tree.set("parameters/idle_walk_run_blend/blend_amount", 0)
	anim_tree.set("parameters/move_attack/blend_amount", 0)
	
func _physics_process(delta):
	show_stealth_prompt()
	
	match current_state:
		States.patrol:
			patrol(delta)
		States.wait:
			wait()
		States.chase:
			chase_player(delta)
		States.attack:
			attack_player(delta)
		States.damaged:
			damaged()
		States.die:
			pass	
	
	
func patrol(delta):
	anim_tree.set("parameters/move_attack/blend_amount", 0)
	await get_tree().process_frame
	if not is_on_floor():
		velocity.y -=  gravity * delta
	
	speed = walk_speed
	anim_tree.set("parameters/idle_walk_run_blend/blend_amount", -1)
	if nav_agent.is_navigation_finished():
		patrol_timer.start()
		current_state = States.wait
		return
	var target_pos = nav_agent.get_next_path_position() - global_position
	target_pos.y = 0
	dir = target_pos.normalized()
	velocity.y =0 
	velocity = velocity.lerp(dir * speed * delta * gravity, 1.0)
	
	
	look_at(global_transform.origin + dir)
	
	move_and_slide()
	
func wait():
	anim_tree.set("parameters/idle_walk_run_blend/blend_amount", 0)
	anim_tree.set("parameters/move_attack/blend_amount", 0)
	
func chase_player(delta):
	anim_tree.set("parameters/move_attack/blend_amount", 0)
	if (current_state != States.damaged or current_state != States.die) and level.player_detected == true or (visual_cast and visual_cast.is_colliding() and visual_cast.get_collider().is_in_group("player")) :
		if not is_on_floor():
			velocity.y -=  gravity * delta
		if level.player_detected == true and not (visual_cast and visual_cast.is_colliding() and visual_cast.get_collider().is_in_group("player")):
			if not is_on_floor():
				velocity.y -=  gravity * delta
			chase_timer.start()	
		patrol_timer.stop()
		speed = run_speed
		anim_tree.set("parameters/idle_walk_run_blend/blend_amount", 1)
		
		nav_agent.target_position = player.global_position
		var next_nav_point = nav_agent.get_next_path_position()
		dir = next_nav_point - global_position
		velocity = dir.normalized() * speed * delta * gravity
		velocity.y = velocity.y - (gravity * delta)
		look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
		
	move_and_slide()

func damaged():
	anim_tree.set("parameters/move_attack/blend_amount", 0)
	health_bar.value -= 2
	knockback(dir)
	anim_tree.set("parameters/hit_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	if (health_bar.value <= 0):
		Global.update_player_score(Global.KILLS, 100)
		current_state = States.die
		dead()
		
	if current_state != States.die:	
		if player_in_attack_range:	
			current_state = States.attack  
		else: 
			current_state = States.chase
	

func stealth_kill():
	knockback(-dir)
	Global.update_player_score(Global.STEALTH_KILLS, 200)
	dead()
		
	
func dead():
	health_bar.value = 0
	player_detection.process_mode = Node.PROCESS_MODE_DISABLED
	attack_detection.process_mode = Node.PROCESS_MODE_DISABLED
	anim_tree.set("parameters/death_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	death_timer.start()

func attack_player(delta):
	look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
	
	if current_state != States.damaged or current_state != States.die:
		anim_tree.set("parameters/idle_walk_run_blend/blend_amount", 0)
		anim_tree.set("parameters/move_attack/blend_amount", 1)
		Global.update_player_score(Global.HITS_TAKEN, -50)
	

func knockback(dir):
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position - (dir / 1.5), 0.2)
	

func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		level.player_detected = true
		signal_start_chase_player()
		

func _on_player_detection_body_exited(body):
	if body.is_in_group("player"):
		level.player_detected = false
		stop_chase_player()

func is_waiting():
	return current_state == States.wait
	
func show_stealth_prompt():
	if !looking_at_player and 	is_waiting():
		stealth_prompt.visible = true
	else:
		stealth_prompt.visible = false	

func stealth_prompt_visible():
	return stealth_prompt.visible		

func damage():
	current_state = States.damaged
	

func _on_patrol_timer_timeout():
	current_state = States.patrol
	waypoint_index += 1
	if waypoint_index > waypoints.size() - 1 :
		waypoint_index = 0
	nav_agent.target_position = waypoints[waypoint_index]


func _on_death_timer_timeout():
	#Spawn health
	var medium_health = health_vial.instantiate()
	medium_health.global_position = self.global_position
	self.get_parent().add_child(medium_health)
	medium_health.activate_vial("medium_health")
	if has_key && has_key == true:
		var keyring_pickup = keyring.instantiate()
		keyring_pickup.global_position = self.global_position +Vector3(0, 1, 0)
		self.get_parent().add_child(keyring_pickup)
	Global.update_player_score(Global.KILLS, 200)
	
	# Free memory
	queue_free()

func _on_player_attack_body_exited(body):
	if body.is_in_group("player"):
		player_in_attack_range = false
		anim_tree.set("parameters/move_attack/blend_amount", 0)
		current_state = States.chase

func signal_start_chase_player():
	Global.update_player_score(Global.SEEN, -50)
	get_tree().call_group("monster", "start_chase_player")

func signal_stop_chase_player():
	get_tree().call_group("monster", "stop_chase_player")	

func start_chase_player():	
	looking_at_player = true
	current_state = States.chase	
	
func stop_chase_player():
	looking_at_player = false
	nav_agent.target_position = waypoints[waypoint_index]
	current_state = States.patrol


func _on_attack_detection_body_entered(body):
	if body.is_in_group("player"):
		player_in_attack_range = true
		current_state = States.attack


func _on_attack_detection_body_exited(body):
	if body.is_in_group("player"):
		player_in_attack_range = false
		anim_tree.set("parameters/idle_walk_run_blend/blend_amount", 1)
		anim_tree.set("parameters/move_attack/blend_amount", 0)
		current_state = States.chase


func _on_chase_timer_timeout():
	if not (visual_cast and visual_cast.is_colliding() and visual_cast.get_collider().is_in_group("player")):
		stop_chase_player()
