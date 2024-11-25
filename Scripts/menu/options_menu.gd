extends Control

@onready var back_audio = $SFX/Back
@onready var hover_audio = $SFX/Hover
@onready var select_audio = $SFX/Select
@onready var reset_button = $MarginContainer/Options/Reset
@onready var back_button = $MarginContainer/Options/Back
@onready var controls_button = $MarginContainer/Options/Controls
@onready var controls_timer = $MarginContainer/Options/ControlsTimer
@onready var reset_timer = $MarginContainer/Options/ResetTimer
@onready var back_timer = $MarginContainer/Options/BackTimer
@onready var credits_button = $MarginContainer/Options/Credits
@onready var credits_timer = $MarginContainer/Options/CreditsTimer
@onready var help_button = $MarginContainer/Options/Help
@onready var help_timer = $MarginContainer/Options/HelpTimer
@onready  var reset_game_confirm = $MarginContainer/Options/ResetGameConfirm

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
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
	Global.delete_save()


func _on_reset_game_confirm_canceled():
	reset_button.disabled = false
	get_tree().paused = false


func _on_controls_timer_timeout():
	controls_button.disabled = false
	get_tree().paused = false
	var controls_screen = preload("res://Scenes/Menu/control_screen.tscn").instantiate()
	get_tree().root.add_child(controls_screen)


func _on_controls_pressed():
	if controls_timer.is_stopped():
		controls_timer.start()
		select_audio.play()
		controls_button.disabled = true
		get_tree().paused = true


func _on_controls_mouse_entered():
	hover_audio.play()


func _on_help_pressed():
	if help_timer.is_stopped():
		help_timer.start()
		select_audio.play()
		help_button.disabled = true
		get_tree().paused = true


func _on_help_mouse_entered():
	hover_audio.play()


func _on_credits_pressed():
	if credits_timer.is_stopped():
		credits_timer.start()
		select_audio.play()
		credits_button.disabled = true
		get_tree().paused = true


func _on_credits_mouse_entered():
	hover_audio.play()


func _on_credits_timer_timeout():
	credits_button.disabled = false
	get_tree().paused = false
	var credits_screen = preload("res://Scenes/Menu/options_menu_credits.tscn").instantiate()
	get_tree().root.add_child(credits_screen)


func _on_help_timer_timeout():
	help_button.disabled = false
	get_tree().paused = false
