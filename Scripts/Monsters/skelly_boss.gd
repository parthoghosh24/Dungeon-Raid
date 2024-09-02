extends CharacterBody3D

var player = null
var player_detected = false
var hp = 20
var dir

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree
@onready var player_detection = $PlayerDetection
@onready var death_timer = $DeathTimer
@onready var player_attack = $PlayerAttack
@onready var visual_cast = $VisualCast

var player_in_attack_range = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


enum States {
	wait,
	attack,
	damaged,
	warp,
}

var current_state : States

func _ready():
	player = get_node(player_path)
	current_state = States.wait
	
	
func _physics_process(delta):
	
	match current_state:
		States.wait:
			wait()
		States.attack:
			attack_player(delta)
		States.damaged:
			damaged()	
	
func wait():
	anim_tree.set("parameters/move_death/blend_amount", 0)
	
func damaged():
	hp -= 2
	print(hp)
	
	knockback(dir)
	
	if (hp <= 0):
		dead()
	if player_in_attack_range:	
		current_state = States.attack  
	else: 
		current_state = States.wait

func attack_player(delta):
	if visual_cast.is_colliding() and visual_cast.get_collider().is_in_group("player"):
		look_at(Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z), Vector3.UP)
		anim_tree.set("parameters/death_attack/active", true)
		anim_tree.set("parameters/death_attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

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
		current_state = States.attack


func _on_player_detection_body_exited(body):
	if body.is_in_group("player"):
		player_detected = false
		current_state = States.wait

func _on_death_timer_timeout():
	queue_free()


func _on_hand_hit_box_body_entered(body):
	if body.is_in_group("player"):
		body.damage()
