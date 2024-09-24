extends Node3D


@export var player_detected: bool
@onready var chase_music = $Music/Chase
@onready var music_animation = $Music/MusicAnimation
# Called when the node enters the scene tree for the first time.
func _ready():
	player_detected = false	
	
func _physics_process(delta):
	if player_detected:
		music_animation.play("FadeIn")
			
func _on_haiya_player_dead():
	get_tree().change_scene_to_file("res://Scenes/Menu/game_over.tscn")
