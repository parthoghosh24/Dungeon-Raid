extends CharacterBody3D

var player = null
var player_detected = false
var walk_speed = 15
var run_speed = 25

var speed

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var patrol_timer = $"../PatrolTimer"
@onready var skelly_warrior_anim_tree = $AnimationTree

@onready var player_detection = $PlayerDetection
var waypoints = []
var waypoint_index

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


enum States {
	patrol,
	wait,
	chase,
}

var current_state : States

func _ready():
	waypoint_index = 0
	player = get_node(player_path)
	current_state = States.patrol
	for node in $"../MarkersToVisit".get_children():
		waypoints.append(node.global_position + Vector3.UP)
	nav_agent.target_position = waypoints[waypoint_index]
	skelly_warrior_anim_tree.set("parameters/idle_walk_run_blend/blend_amount", 0)
	
func _physics_process(delta):
	
	match current_state:
		States.patrol:
			pass
			patrol(delta)
		States.wait:
			pass
			wait()
		States.chase:
			chase_player(delta)	
	
	
func patrol(delta):
	await get_tree().process_frame
	if not is_on_floor():
		velocity.y -=  gravity * delta
	
	speed = walk_speed
	skelly_warrior_anim_tree.set("parameters/idle_walk_run_blend/blend_amount", -1)
	if nav_agent.is_navigation_finished():
		patrol_timer.start()
		current_state = States.wait
		return
	var target_pos = nav_agent.get_next_path_position() - global_position
	target_pos.y = 0
	var dir = target_pos.normalized()
	velocity.y =0 
	velocity = velocity.lerp(dir * speed * delta * gravity, 1.0)
	
	
	look_at(global_transform.origin + dir)
	
	move_and_slide()
	
func wait():
	skelly_warrior_anim_tree.set("parameters/idle_walk_run_blend/blend_amount", 0)
	
func chase_player(delta):
	if not is_on_floor():
		velocity.y -=  gravity * delta
	patrol_timer.stop()
	speed = run_speed
	skelly_warrior_anim_tree.set("parameters/idle_walk_run_blend/blend_amount", 1)
	
	nav_agent.target_position = player.global_position
	var next_nav_point = nav_agent.get_next_path_position()
	var dir = next_nav_point - global_position
	velocity = dir.normalized() * speed * delta * gravity
	velocity.y =  velocity.y - (gravity * delta)
	look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
	
	move_and_slide()
	

func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		player_detected = true
		current_state = States.chase


func _on_player_detection_body_exited(body):
	if body.is_in_group("player"):
		player_detected = false
		nav_agent.target_position = waypoints[waypoint_index]
		current_state = States.patrol


func _on_navigation_agent_3d_target_reached():
	#print("attack player")
	pass


func _on_patrol_timer_timeout():
	current_state = States.patrol
	waypoint_index += 1
	if waypoint_index > waypoints.size() - 1 :
		waypoint_index = 0
	nav_agent.target_position = waypoints[waypoint_index]
