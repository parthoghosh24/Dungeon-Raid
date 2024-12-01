extends Node3D


@onready var player_detected: bool
@onready var chase_music: AudioStreamPlayer = $Music/Chase
@onready var music_animation: AnimationPlayer = $Music/MusicAnimation
@onready var player: CharacterBody3D = $Haiya
@onready var level_timer: Timer = $LevelTimer
var level_time_spent: int = 0
var interactions: Dictionary = {
	"ChestGoldArea": false,
	"Tree": false,
	"Chest": false,
	"KeyRingHanging": false,
	"NextLevelDoor": false,
	"Axe": false,
	"Stool": false,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	level_timer.start()
	player_detected = false
	Global.clear_player_inventory()
	Global.set_level(1)
	Global.save_game(1)
	
func _process(_delta) -> void:
	if player_detected:
		music_animation.play("FadeIn")
			
func _on_haiya_player_dead() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/game_over.tscn")
	
func stop_level_timer() -> void:
	level_timer.stop()

	# if it is more than 5 minutes then award min 1000 points
	if level_time_spent >=300:
		Global.update_player_score(Global.TIME_TAKEN, 1000)
	elif level_time_spent <= 30:
		Global.update_player_score(Global.TIME_TAKEN, 8000)
	else:
		Global.update_player_score(Global.TIME_TAKEN, 2500)

func update_interactions(key: String) -> void:
	interactions[key] = true
	
	#Award player with Exploration bonus if player has interacted has explored
	#everything
	if interactions.values().all(func(interaction): return interaction == true):
		Global.update_player_score(Global.EXPLORATION_BONUS, 1000)


func _on_level_timer_timeout() -> void:
	level_time_spent += 1
