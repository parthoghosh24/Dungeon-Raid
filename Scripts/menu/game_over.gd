extends Control

func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/intro.tscn")

func _on_try_again_pressed():
	var level1 = load("res://Scenes/Levels/level_1.tscn")
	get_tree().change_scene_to_packed(level1)

	


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
