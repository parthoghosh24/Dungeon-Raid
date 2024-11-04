extends CharacterBody3D

@export var player_path : NodePath
@onready var animation_tree = $AnimationTree
@onready var nav_agent = $NavigationAgent3D
@onready var health_bar = $HealthBar/EnemyHealthBar

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var run_speed = 50
var dir
var speed
var player

func _ready():
	player = get_node(player_path)
	animation_tree.state = animation_tree.RUN
	
func _physics_process(delta):
	
	if not is_on_floor():
			velocity.y -=  gravity * delta
	if animation_tree.state == animation_tree.RUN:
		speed = run_speed
		animation_tree.get("parameters/playback").travel("Run")
		nav_agent.target_position = player.global_position
		var next_nav_point = nav_agent.get_next_path_position()
		dir = next_nav_point - global_position
		velocity = dir.normalized() * speed * delta * gravity
		velocity.y = velocity.y - (gravity * delta)
		look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)

	if animation_tree.state == animation_tree.HIT:
		animation_tree.get("parameters/playback").travel("Hit")
		if health_bar.value <=0:
			pass
		else:	
			health_bar.value -= 2
			animation_tree.state = animation_tree.ATTACK
	
	if animation_tree.state == animation_tree.IDLE:
		animation_tree.get("parameters/playback").travel("Idle")
		
	move_and_slide()	
			
 	

func knockback(dir):
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position - (dir / 1.5), 0.2)

	
func damage():
	knockback(dir)
	animation_tree.state = animation_tree.HIT
		

func _on_player_attack_body_entered(body):
	if body.is_in_group("player"):
		animation_tree.state = animation_tree.IDLE


func _on_player_attack_body_exited(body):
	if body.is_in_group("player"):
		animation_tree.state = animation_tree.RUN

# Algo for phased boss behaviour
# 100 - 75% health, attack
# 75 -50% health, block, attack
# 50-0% health, block,dodge, taunt, attack

func _on_hurt_box_area_entered(area):
	if area == null or area.name != "HaiyaHitBox":
		return
	
	if area.name == "HaiyaHitBox" and has_method("damage"):
		print(health_lost())
		get_viewport().get_camera_3d().shake_camera()
		damage()

func health_lost():
	return health_bar.value/(health_bar.max_value * 1.0	)
