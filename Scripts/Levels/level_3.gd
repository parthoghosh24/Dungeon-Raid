extends Node3D


@onready var player_detected: bool
@onready var chase_music: AudioStreamPlayer = $Music/Chase
@onready var music_animation: AnimationPlayer = $Music/MusicAnimation
@onready var player: CharacterBody3D = $Haiya
@onready var barbarian: Node3D = $NavigationRegion3D/StaticAssets/Rooms/Barbarian
@onready var barbarian_bed_collision: CollisionShape3D  = $NavigationRegion3D/StaticAssets/Rooms/Room1/bed_decorated3/bed_decorated/BarbarianBed/CollisionShape3D
@onready var level_timer: Timer = $LevelTimer
var level_time_spent: int = 0

var interactions: Dictionary = {
	"BarbarianBed": false,
	"NextLevelDoor": false,
}
var cutscene_playing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	level_timer.start()
	player_detected = false
	Global.clear_player_inventory()
	Global.set_level(2)
	Global.save_game(2)
	
func _process(_delta) -> void:
	if player_detected:
		music_animation.play("FadeIn")
	
	if Global.level_cutscene_playing() == true and !cutscene_playing:
		trigger_cutscene()
	
	if Global.level_cutscene_playing() == false and cutscene_playing:
		resume_game()
		
			
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
	
func trigger_cutscene() -> void:
	cutscene_playing = true
	get_tree().paused = true
	barbarian_bed_collision.disabled = true
	player.visible = false
	barbarian.queue_free()
	var level_3_cutscene = preload("res://Scenes/LevelCutscenes/level_3_cutscene.tscn").instantiate()
	get_tree().root.add_child(level_3_cutscene)

func resume_game() -> void:
	cutscene_playing = false
	player.visible = true
	
