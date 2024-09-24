extends Control

@onready var continue_button = $MarginContainer/Main/Continue

func _ready():
	continue_button.visible = false

func _on_continue_pressed():
	pass # Replace with function body.


func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/intro.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/options_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()
