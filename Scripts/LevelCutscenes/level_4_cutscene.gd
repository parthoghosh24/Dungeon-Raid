extends Node3D

@onready var cutscene: AnimationPlayer = $Cutscene
@onready var char_anim_player: AnimationPlayer = $Haiya/Rogue/AnimationPlayer
@onready var cam1: Camera3D = $Cameras/Cam1
@onready var cam2: Camera3D = $Cameras/Cam2
@onready var speech: Control = $Speeches/Speech

# Called when the node enters the scene tree for the first time.

func _input(_event: InputEvent) -> void:
	return
	
func _ready() -> void:
	get_tree().paused = true
	cam2.make_current()
	speech.set_text("Hmph...Hmph...Hmph..... AAAAAHH!!!!")
	cutscene.queue("ACT1")
	await cutscene.animation_finished
	cam1.make_current()
	cutscene.queue("ACT2")
	await cutscene.animation_finished


func _on_cutscene_animation_finished(anim_name: String) -> void:
	if anim_name == "ACT2":
		get_tree().paused = false
		Global.stop_level_cutscene()
		queue_free()
