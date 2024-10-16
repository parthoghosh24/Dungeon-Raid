extends Node3D


@onready var player_detected: bool
@onready var chase_music = $Music/Chase
@onready var music_animation = $Music/MusicAnimation
@onready var player = $Haiya
@onready var level_timer: Timer = $LevelTimer
var level_time_spent: int = 0


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


func _on_level_timer_timeout():
	level_time_spent += 1
