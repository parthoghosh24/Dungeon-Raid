extends CharacterBody3D

var player = null
var player_detected = false
var walk_speed = 10
var run_speed = 20
var hp = 20
var dir
var speed

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var patrol_timer = $"../PatrolTimer"
@onready var anim_tree = $AnimationTree
@onready var player_detection = $PlayerDetection
@onready var death_timer = $DeathTimer
@onready var player_attack = $PlayerAttack
@onready var visual_cast = $VisualCast

var waypoints = []
var waypoint_index
var player_in_attack_range = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


enum States {
	patrol,
	wait,
	chase,
	attack,
	damaged,
}

var current_state : States

func _ready():
	waypoint_index = 0
	player = get_node(player_path)
	current_state = States.patrol
	for node in $"../MarkersToVisit".get_children():
		waypoints.append(node.global_position + Vector3.UP)	
	nav_agent.target_position = waypoints[waypoint_index]
	anim_tree.set("parameters/idle_walk_run_blend/blend_amount", 0)
	anim_tree.set("parameters/death_attack/blend_amount", 0)
	
func _physics_process(delta):
	
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
	
	
func patrol(delta):
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
	
func chase_player(delta):
	if visual_cast.is_colliding() and visual_cast.get_collider().is_in_group("player"):
		if not is_on_floor():
			velocity.y -=  gravity * delta
		patrol_timer.stop()
		speed = run_speed
		anim_tree.set("parameters/idle_walk_run_blend/blend_amount", 1)
		
		nav_agent.target_position = player.global_position
		var next_nav_point = nav_agent.get_next_path_position()
		dir = next_nav_point - global_position
		velocity = dir.normalized() * speed * delta * gravity
		velocity.y =  velocity.y - (gravity * delta)
		look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
		
	move_and_slide()
	
func damaged():
	hp -= 2
	print(hp)
	
	knockback(dir)
	
	if (hp <= 0):
		dead()
	if player_in_attack_range:	
		current_state = States.attack  
	else: 
		current_state = States.chase

func attack_player(delta):
	look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
	anim_tree.set("parameters/idle_walk_run_blend/blend_amount", 0)
	anim_tree.set("parameters/death_attack/blend_amount", 1)

func damage():
	current_state = States.damaged	

func knockback(dir):
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position - (dir / 1.5), 0.2)		

func dead():
	anim_tree.set("parameters/death_attack/blend_amount", 0)
	anim_tree.set("parameters/death_shot/active", true)
	anim_tree.set("parameters/death_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	death_timer.start()	

func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		player_detected = true
		current_state = States.chase


func _on_player_detection_body_exited(body):
	if body.is_in_group("player"):
		player_detected = false
		nav_agent.target_position = waypoints[waypoint_index]
		current_state = States.patrol


func _on_patrol_timer_timeout():
	current_state = States.patrol
	waypoint_index += 1
	if waypoint_index > waypoints.size() - 1 :
		waypoint_index = 0
	nav_agent.target_position = waypoints[waypoint_index]


func _on_right_hand_hitbox_body_entered(body):
	if body.is_in_group("player") and current_state == States.attack:
		body.damage()


func _on_death_timer_timeout():
	queue_free()


func _on_player_attack_body_entered(body):
	if body.is_in_group("player"):
		player_in_attack_range = true
		current_state = States.attack


func _on_player_attack_body_exited(body):
	if body.is_in_group("player"):
		player_in_attack_range = false
		anim_tree.set("parameters/death_attack/blend_amount", 0)
		current_state = States.chase
