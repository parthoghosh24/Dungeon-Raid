extends Node3D

@onready var anim_player: AnimationPlayer = $MetaIntroAnimation
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	anim_player.queue("Game_by")
	anim_player.queue("Powered_by")
	await anim_player.animation_finished	


func _on_meta_intro_animation_animation_finished(anim_name: String) -> void:
	if anim_name == "Powered_by":
		Global.load_level(-1)
