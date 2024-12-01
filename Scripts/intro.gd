extends Node3D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var char_anim_player: AnimationPlayer = $Haiya/Rogue/AnimationPlayer
@onready var intro_camera: Camera3D = $Camera1
@onready var reveal_dungeon_camera: Camera3D = $Camera2
@onready var audio_anim_player: AnimationPlayer = $AudioAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED	
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


func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "FadeOut":
		Global.load_level(0)
		
