extends Control

func _on_check_button_toggled(toggled_on):
	if toggled_on:
		Global.INPUT_SCHEME = Global.INPUT_SCHEMES.GAMEPAD
	else:
		Global.INPUT_SCHEME = Global.INPUT_SCHEMES.MOUSE_AND_KEYBOARD


func _on_reset_pressed():
	pass # Replace with function body.


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
