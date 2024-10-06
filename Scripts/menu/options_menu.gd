extends Control

@onready var back_audio = $SFX/Back
@onready var hover_audio = $SFX/Hover

func _on_check_button_toggled(toggled_on):
	if toggled_on:
		Global.INPUT_SCHEME = Global.INPUT_SCHEMES.GAMEPAD
	else:
		Global.INPUT_SCHEME = Global.INPUT_SCHEMES.MOUSE_AND_KEYBOARD


func _on_reset_pressed():
	pass # Replace with function body.


func _on_back_pressed():
	back_audio.play()
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")


func _on_check_button_mouse_entered():
	hover_audio.play()


func _on_reset_mouse_entered():
	hover_audio.play()


func _on_back_mouse_entered():
	hover_audio.play()
