extends Control

@onready var continue_button = $MarginContainer/Main/Continue
@onready var level

func _ready():
	continue_button.visible = false
	level = Global.load_game()
	if level != null and level >= 0:
		continue_button.visible = true

func _on_continue_pressed():
	Global.load_level(level)


func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/intro.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/options_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()
