extends Control

@onready var cutscene = $Cutscene
@onready var heading = $Panel/Heading
@onready var person_name = $Panel/PersonName
@onready var music = $SFX/Music

# Called when the node enters the scene tree for the first time.

func _input(event):
	return null
	
func _ready():
	await get_tree().create_timer(1).timeout
	music.play()
	get_tree().paused = true
	cutscene.queue("ACT1")
	await cutscene.animation_finished
	heading.text = "A game by"
	person_name.text = "PorthorisNaagu"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Haiya voice"
	person_name.text = "Cici Fyre (cicifyre.itch.io)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Bork the barbarian voice"
	person_name.text = "mieki256 (opengameart.org/users/mieki256)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Knight voice"
	person_name.text = "Little Robot Sound Factory (www.littlerobotsoundfactory.com)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Skelly monsters voice"
	person_name.text = "artisticdude (opengameart.org/users/artisticdude)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Skelly mini boss voice"
	person_name.text = "Little Robot Sound Factory (www.littlerobotsoundfactory.com)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Final boss voice"
	person_name.text = "Little Robot Sound Factory (www.littlerobotsoundfactory.com)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Final boss sfx"
	person_name.text = "Joth (opengameart.org/users/joth)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "SFX"
	person_name.text = "tarfmagougou (opengameart.org/users/tarfmagougou)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Fireball SFX"
	person_name.text = "spookymodem (opengameart.org/users/spookymodem)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Menu SFX"
	person_name.text = "David McKee \"ViRiX\" (soundcloud.com/virix)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Programmer, story, gameplay & levels"
	person_name.text = "Partho Ghosh"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "3d characters & environment assets"
	person_name.text = "Kay Lousberg (kaykit)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Castle assets"
	person_name.text = "Blender Nightmares (www.turbosquid.com/Search/Artists/Blender_Nightmares)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Tree asset"
	person_name.text = "medo_544 (free3d.com/user/medo_544)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Mountain asset"
	person_name.text = "bajtix (free3d.com/user/bajtix)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Wall texture"
	person_name.text = "ambientcg (ambientcg.com)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Healthbar texture"
	person_name.text = "Markiro (markiro.itch.io)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Fonts"
	person_name.text = "Chequered Ink, UkiyoMoji Fonts (dafont.com)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Keyboard button textures"
	person_name.text = "bajtix (free3d.com/user/bajtix)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Particles"
	person_name.text = "Kenney Vleugels (Kenney.nl)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Intro theme"
	person_name.text = "\"Wipe away those tears\" by Jonathan Shaw (www.jshaw.co.uk)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Chase theme"
	person_name.text = "Michael Robinson Homingstar (opengameart.org/users/michael-robinson)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Mini boss theme"
	person_name.text = "\"The Rush\" by tebruno99 (opengameart.org/users/tebruno99)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Final boss theme"
	person_name.text = "\"Colossal Boss Battle\" by Matthew Pablo (matthewpablo.com)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Scoreboard theme"
	person_name.text = "Joth (opengameart.org/users/joth)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "End credits theme"
	person_name.text = "Igor Gundarev (opengameart.org/users/igor-gundarev)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "Powered by"
	person_name.text = "Godot Engine (4.3)"
	cutscene.queue("ACT2")
	await cutscene.animation_finished
	heading.text = "And finally"
	person_name.text = "My family, friends and well-wishers"
	cutscene.queue("ACT2")
	await cutscene.animation_finished


func _on_cutscene_animation_finished(anim_name):
	if anim_name == "ACT2" and heading.text == "And finally":
		await get_tree().create_timer(1).timeout
		get_tree().paused = false
		self.queue_free()
