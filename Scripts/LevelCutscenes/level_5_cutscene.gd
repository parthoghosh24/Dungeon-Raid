extends Node3D

@onready var cutscene: AnimationPlayer = $Cutscene
@onready var cam1: Camera3D = $Cameras/Cam1
@onready var cam2: Camera3D = $Cameras/Cam2
@onready var cam3: Camera3D = $Cameras/Cam3
@onready var cam4: Camera3D = $Cameras/Cam4
@onready var speech: Control = $Speeches/Speech
@onready var boss_entry: AudioStreamPlayer = $SFX/BossEntry

# Called when the node enters the scene tree for the first time.

func _input(_event: InputEvent) -> void:
	return
	
func _ready() -> void:
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


func _on_cutscene_animation_finished(anim_name: String) -> void:
	if anim_name == "ACT4":
		get_tree().paused = false
		Global.stop_level_cutscene()
		queue_free()


func _on_boss_entry_finished() -> void:
	cam4.make_current()
	speech.set_text("RAAAAAARR!!")
	cutscene.queue("ACT4")
	await cutscene.animation_finished
