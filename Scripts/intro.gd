extends Node3D

@onready var anim_player = $AnimationPlayer
@onready var char_anim_player = $Haiya/Rogue/AnimationPlayer
@onready var intro_camera = $Camera1
@onready var reveal_dungeon_camera = $Camera2
# Called when the node enters the scene tree for the first time.
func _ready():
	intro_camera.make_current()
	anim_player.queue("IntroScene")
	char_anim_player.play("Walking_A")
	await anim_player.animation_finished
	reveal_dungeon_camera.make_current()
	char_anim_player.play("Idle")
	anim_player.queue("RevealDungeonScene")
	await anim_player.animation_finished
	anim_player.stop(true)
