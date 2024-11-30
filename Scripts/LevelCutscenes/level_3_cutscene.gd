extends Node3D

@onready var cutscene = $Cutscene
@onready var char_anim_player = $Haiya/Rogue/AnimationPlayer
@onready var cam1 = $Cameras/Cam1
@onready var cam2 = $Cameras/Cam2
@onready var cam3 = $Cameras/Cam3
@onready var cam4 = $Cameras/Cam4
@onready var speech1 = $Speeches/Speech1

# Called when the node enters the scene tree for the first time.

func _input(_event):
	return
func _ready():
	get_tree().paused = true
	speech1.set_text("I knew it... HEY!!!")
	cutscene.queue("ACT1")
	cam1.make_current()
	await cutscene.animation_finished
	cutscene.queue("ACT2")
	cam2.make_current()
	await cutscene.animation_finished
	cam3.make_current()
	speech1.set_text("How, in all realms, are ye sleeping here instead of saving the knight?")
	cutscene.queue("ACT3")
	await cutscene.animation_finished
	speech1.set_text("Well... I lost my axe, ye see, and the blasted door on this floor locked itself. Then I stumbled upon this fine bed with meat and ale at its side, and, well, who am I to deny such bounty?")
	cutscene.queue("ACT4")
	await cutscene.animation_finished
	speech1.set_text("Of all the reasons... fine, lets haste! We've a knight to save.")
	cutscene.queue("ACT5")
	await cutscene.animation_finished
	speech1.set_text("Er... actually, I reckon I'd rather head back. 'Tis surely a sight more dangerous up yonder. But, uh, I can give ye the key to the next floor if ye fancy it.")
	cutscene.queue("ACT6")
	await cutscene.animation_finished
	speech1.set_text("You were meant to be a mighty barbarian, not a blubbering cow! Very well, hand it over!")
	cutscene.queue("ACT7")
	await cutscene.animation_finished
	speech1.set_text("Much obliged! Here you go!")
	cutscene.queue("ACT8")
	await cutscene.animation_finished
	cam4.make_current()
	cutscene.queue("ACT9")
	await cutscene.animation_finished


func _on_cutscene_animation_finished(anim_name):
	if anim_name == "ACT9":
		get_tree().paused = false
		Global.set_player_inventory(Global.PLAYER_INVENTORY_ITEMS.DOOR_KEY)
		Global.stop_level_cutscene()
		queue_free()
