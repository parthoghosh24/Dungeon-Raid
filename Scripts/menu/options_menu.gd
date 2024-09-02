extends Control

func _on_check_button_toggled(toggled_on):
	print(toggled_on)


func _on_reset_pressed():
	pass # Replace with function body.


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
