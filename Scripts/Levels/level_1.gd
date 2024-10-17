extends Node3D


@onready var player_detected: bool
@onready var chase_music = $Music/Chase
@onready var music_animation = $Music/MusicAnimation
@onready var player = $Haiya
@onready var level_timer: Timer = $LevelTimer
var level_time_spent: int = 0
var interactions = {
	"ChestGoldArea": false,
	"SwordShieldGold": false,
	"TableLongBroken": false,
	"KeyRingHanging": false,
	"FoodTable": false,
	"BarrelLarge": false,
	"BedDecorated": false,
	"NextLevelDoor": false
}


func _input(event):
	Global.evaluate_input_scheme(event)

# Called when the node enters the scene tree for the first time.
func _ready():
	level_timer.start()
	player_detected = false
	Global.set_level(0)
	Global.save_game(0)
	
func _physics_process(delta):
	if player_detected:
		music_animation.play("FadeIn")
			
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

func update_interactions(key):
	interactions[key] = true
	
	#Award player with Exploration bonus if player has interacted has explored
	#everything
	if interactions.values().all(func(interaction): return interaction == true):
		Global.update_player_score(Global.EXPLORATION_BONUS, 1000)


func _on_level_timer_timeout():
	level_time_spent += 1
