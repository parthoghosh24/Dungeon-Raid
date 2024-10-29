extends Node3D

@onready var cutscene = $Cutscene
@onready var char_anim_player = $Haiya/Rogue/AnimationPlayer
@onready var cam1 = $Cameras/Cam1
@onready var cam2 = $Cameras/Cam2
@onready var speech = $Speeches/Speech

# Called when the node enters the scene tree for the first time.

func _input(event):
	return null
	
func _ready():
	get_tree().paused = true
	cam2.make_current()
	speech.set_text("Hmph...Hmph...Hmph..... AAAAAHH!!!!")
	cutscene.queue("ACT1")
	await cutscene.animation_finished
	cam1.make_current()
	cutscene.queue("ACT2")
	await cutscene.animation_finished


func _on_cutscene_animation_finished(anim_name):
	if anim_name == "ACT2":
		get_tree().paused = false
		Global.stop_level_cutscene()
		queue_free()
