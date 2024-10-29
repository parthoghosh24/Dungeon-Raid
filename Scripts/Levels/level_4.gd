extends Node3D

@onready var player_detected: bool
@onready var chase_music = $Music/Chase
@onready var music_animation = $Music/MusicAnimation
@onready var battle_music = $Music/BattleMusic
@onready var player = $Haiya
@onready var warrior = $Enemies/Warrior/SkellyWarrior
@onready var level_timer: Timer = $LevelTimer
var level_time_spent: int = 0

var interactions = {
	"MiniBossFightDoor": false,
	"KeyRingHanging": false,
	"NextLevelDoor": false,
}

var cutscene_playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	level_timer.start()
	player_detected = false
	Global.set_level(3)
	Global.save_game(3)

func _physics_process(delta):
	if player_detected:
		music_animation.play("FadeIn")
	
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
	cutscene_playing = true
	get_tree().paused = true
	player.visible = false
	warrior.visible = false
	var level_4_cutscene = preload("res://Scenes/LevelCutscenes/level_4_cutscene.tscn").instantiate()
	get_tree().root.add_child(level_4_cutscene)

func resume_game():
	cutscene_playing = false
	player.visible = true
	warrior.visible = true
	if chase_music and chase_music.is_playing():
		chase_music.stop()
	battle_music.play()
