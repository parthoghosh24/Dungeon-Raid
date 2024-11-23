extends Node3D

@onready var cutscene = $Cutscene
@onready var cam1 = $Cameras/Cam1
@onready var cam2 = $Cameras/Cam2
@onready var cam3 = $Cameras/Cam3
@onready var speech = $Speeches/Speech
@onready var boss_entry = $SFX/BossEntry

# Called when the node enters the scene tree for the first time.

func _input(event):
	return null
	
func _ready():
	get_tree().paused = true
	speech.visible = false
	speech.set_text("")
	cam1.make_current()
	cutscene.queue("ACT1")
	await cutscene.animation_finished
	speech.visible = true
	speech.set_text("")
	cam2.make_current()
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	speech.set_text("Huzzah! Congratulations, fair warrior, thou hast passed the test!")
	cutscene.queue("ACT3")
	await cutscene.animation_finished
	speech.set_text("Test? Pray, what madness dost thou speak of, tin can?")
	cutscene.queue("ACT4")
	await cutscene.animation_finished
	speech.set_text("Verily, `twas a test! A trial to seek the mightiest of warriors for a dire threat on yon horizon!")
	cutscene.queue("ACT5")
	await cutscene.animation_finished
	speech.set_text("A TEST?! Thou meanest to tell me I nearly lost mine precious hide for some fool's errand? Where is my reward, knave? My coin purse doth weep for mercy!")
	cutscene.queue("ACT6")
	await cutscene.animation_finished
	speech.set_text("Calm thy fiery spirit, oh blade-weilding tempest! Thou shalt be richly rewarded! Though, tell me, what became of Bork the Barbarian?")
	cutscene.queue("ACT7")
	await cutscene.animation_finished
	speech.set_text("Bork? That mead-guzzling oaf? He supped on roasted fowl, snored like a wyvern, and, lo, fled with naught but a grunt after giving me the key! Truly, a lion-hearted champion, that one.")
	cutscene.queue("ACT8")
	await cutscene.animation_finished
	speech.set_text("Alas! I had pinned too many hopes upon that barrel-chested dolt. Yet his strength is legendary, my lady.")
	cutscene.queue("ACT9")
	await cutscene.animation_finished
	speech.set_text("Strength, mayhap. But I've yet to see him lift aught heavier than his tankard of ale.")
	cutscene.queue("ACT10")
	await cutscene.animation_finished
	speech.set_text("Haha! Trust me, fair lady, thou shalt yet behold his strength in all its glory... someday. But enough of that! Let us return to the castle, where the finest warriors gather for the coming storm.")
	cutscene.queue("ACT11")
	await cutscene.animation_finished
	cam3.make_current()
	speech.visible = false
	speech.set_text("")
	cutscene.queue("ACT12")
	await cutscene.animation_finished
	


func _on_cutscene_animation_finished(anim_name):
	if anim_name == "ACT12":
		var credits = load("res://Scenes/credits.tscn")
		get_tree().change_scene_to_packed(credits)
