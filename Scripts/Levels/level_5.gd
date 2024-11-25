extends Node3D

@onready var player_detected: bool
@onready var battle_music = $SFX/BossMusic
@onready var player = $Haiya
@onready var boss = $SkellyBoss
@onready var knight = $Knight
@onready var level_timer: Timer = $LevelTimer
@onready var cutscene_trigger_collision = $CutsceneTrigger/CollisionShape3D
var level_time_spent: int = 0

var interactions = {
	"CutsceneTrigger": false,
}

var cutscene_playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	level_timer.start()
	player_detected = false
	Global.clear_player_inventory()
	Global.set_level(4)
	Global.save_game(4)
	boss.process_mode = Node.PROCESS_MODE_DISABLED
	boss.visible = false
	knight.visible = false

func _physics_process(delta):
	if Global.level_cutscene_playing() == true and !cutscene_playing:
		trigger_cutscene()
	
	if Global.level_cutscene_playing() == false and cutscene_playing:
		resume_game()	

func update_interactions(key):
	interactions[key] = true
	
	#Award player with Exploration bonus if player has interacted has explored
	#everything
	if interactions.values().all(func(interaction): return interaction == true):
		Global.update_player_score(Global.EXPLORATION_BONUS, 1000)
 

func _on_haiya_player_dead():
	get_tree().change_scene_to_file("res://Scenes/Menu/game_over.tscn")

func stop_level_timer():
	level_timer.stop()

	# if it is more than 5 minutes then award min 1000 points
	if level_time_spent >=300:
		Global.update_player_score(Global.TIME_TAKEN, 1000)
	elif level_time_spent <= 30:
		Global.update_player_score(Global.TIME_TAKEN, 8000)
	else:
		Global.update_player_score(Global.TIME_TAKEN, 2500)
		
func _on_level_timer_timeout():
	level_time_spent += 1
	
func trigger_cutscene():
	update_interactions("CutsceneTrigger")
	cutscene_playing = true
	get_tree().paused = true
	player.visible = false
	boss.visible = false
	var level_5_cutscene_intro = preload("res://Scenes/LevelCutscenes/level_5_cutscene_intro.tscn").instantiate()
	get_tree().root.add_child(level_5_cutscene_intro)

func resume_game():
	cutscene_playing = false
	player.visible = true
	boss.visible = true
	knight.visible = true
	player.global_position = player.global_position + Vector3(0,0,10)
	boss.process_mode = Node.PROCESS_MODE_INHERIT
	cutscene_trigger_collision.disabled = true
	battle_music.play()


func _on_cutscene_trigger_body_entered(body):
	if body.is_in_group("player"):
		trigger_cutscene()
