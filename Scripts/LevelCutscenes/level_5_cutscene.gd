extends Node3D

@onready var cutscene = $Cutscene
@onready var cam1 = $Cameras/Cam1
@onready var cam2 = $Cameras/Cam2
@onready var cam3 = $Cameras/Cam3
@onready var cam4 = $Cameras/Cam4
@onready var speech = $Speeches/Speech
@onready var boss_entry = $SFX/BossEntry

# Called when the node enters the scene tree for the first time.

func _input(event):
	return null
	
func _ready():
	get_tree().paused = true
	cam1.make_current()
	speech.set_text("Hmph...Hmph...Hmph.....!!!!")
	cutscene.queue("ACT1")
	await cutscene.animation_finished
	cam2.make_current()
	speech.set_text("...Huh???")
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	cam3.make_current()
	speech.set_text("YAY!... AT LAST!")
	cutscene.queue("ACT3")
	await cutscene.animation_finished
	cam3.shake_camera()
	boss_entry.play()


func _on_cutscene_animation_finished(anim_name):
	if anim_name == "ACT4":
		get_tree().paused = false
		Global.stop_level_cutscene()
		queue_free()


func _on_boss_entry_finished():
	cam4.make_current()
	speech.set_text("RAAAAAARR!!")
	cutscene.queue("ACT4")
	await cutscene.animation_finished
