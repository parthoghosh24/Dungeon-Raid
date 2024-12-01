extends Node3D

@onready var cutscene: AnimationPlayer = $Cutscene
@onready var cam1: Camera3D = $Cameras/Cam1
@onready var cam2: Camera3D = $Cameras/Cam2
@onready var speech: Control = $Speeches/Speech

# Called when the node enters the scene tree for the first time.

func _input(_event: InputEvent) -> void:
	return
	
func _ready() -> void:
	get_tree().paused = true
	cam1.make_current()
	speech.set_text("AAARRRGGGHHHH!!!!")
	cutscene.queue("ACT1")
	await cutscene.animation_finished
	cam2.make_current()
	speech.visible = false
	speech.set_text("")
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	


func _on_cutscene_animation_finished(anim_name: String) -> void:
	if anim_name == "ACT2":
		Global.switch_to_score_board()
