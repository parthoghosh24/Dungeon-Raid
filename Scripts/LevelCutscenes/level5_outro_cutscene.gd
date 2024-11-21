extends Node3D

@onready var cutscene = $Cutscene
@onready var cam1 = $Cameras/Cam1
@onready var cam2 = $Cameras/Cam2
@onready var speech = $Speeches/Speech
@onready var boss_entry = $SFX/BossEntry

# Called when the node enters the scene tree for the first time.

func _input(event):
	return null
	
func _ready():
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
	


func _on_cutscene_animation_finished(anim_name):
	if anim_name == "ACT2":
		var end_cutscene = load("res://Scenes/end_cutscene.tscn")
		get_tree().change_scene_to_packed(end_cutscene)
