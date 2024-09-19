extends Node3D

@onready var anim_player = $AnimationPlayer
@onready var char_anim_player = $Haiya/Rogue/AnimationPlayer
@onready var intro_camera = $Camera1
@onready var reveal_dungeon_camera = $Camera2
@onready var audio_anim_player = $AudioAnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	audio_anim_player.play("Play")
	anim_player.queue("FadeIn")
	intro_camera.make_current()
	anim_player.queue("IntroScene")
	char_anim_player.play("Walking_A")
	await anim_player.animation_finished
	reveal_dungeon_camera.make_current()
	char_anim_player.play("Idle")
	anim_player.queue("RevealDungeonScene")
	await anim_player.animation_finished
	anim_player.queue("FadeOut")

func switch_to_level1():
	var level1 = load("res://Scenes/Levels/level_1.tscn")
	get_tree().change_scene_to_packed(level1)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "FadeOut":
		switch_to_level1()
		
