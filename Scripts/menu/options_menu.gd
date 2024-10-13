extends Control

@onready var back_audio = $SFX/Back
@onready var hover_audio = $SFX/Hover
@onready var select_audio = $SFX/Select
@onready var reset_button = $MarginContainer/Options/Reset
@onready var back_button = $MarginContainer/Options/Back
@onready var reset_timer = $MarginContainer/Options/ResetTimer
@onready var back_timer = $MarginContainer/Options/BackTimer
@onready  var reset_game_confirm = $MarginContainer/Options/ResetGameConfirm

func _ready():
	reset_game_confirm.hide()
	
func _on_check_button_toggled(toggled_on):
	if toggled_on:
		Global.INPUT_SCHEME = Global.INPUT_SCHEMES.GAMEPAD
	else:
		Global.INPUT_SCHEME = Global.INPUT_SCHEMES.MOUSE_AND_KEYBOARD


func _on_reset_pressed():
	if reset_timer.is_stopped():
		reset_timer.start()
		select_audio.play()
		reset_button.disabled = true
		get_tree().paused = true
		reset_game_confirm.show()


func _on_back_pressed():
	if back_timer.is_stopped():
		back_timer.start()
		back_audio.play()
		back_button.disabled = true
		get_tree().paused = true


func _on_check_button_mouse_entered():
	hover_audio.play()


func _on_reset_mouse_entered():
	hover_audio.play()


func _on_back_mouse_entered():
	hover_audio.play()


func _on_reset_timer_timeout():
	pass
	


func _on_back_timer_timeout():
	Global.set_game_started()
	back_button.disabled = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")


func _on_reset_game_confirm_confirmed():
	reset_button.disabled = false
	get_tree().paused = false
	DirAccess.remove_absolute("res://savegame.data")


func _on_reset_game_confirm_canceled():
	reset_button.disabled = false
	get_tree().paused = false
