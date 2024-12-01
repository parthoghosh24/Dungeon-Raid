extends Control

@onready var back_audio: AudioStreamPlayer = $SFX/Back
@onready var hover_audio: AudioStreamPlayer = $SFX/Hover
@onready var select_audio: AudioStreamPlayer = $SFX/Select
@onready var reset_button: Button = $MarginContainer/Options/Reset
@onready var back_button: Button = $MarginContainer/Options/Back
@onready var controls_button: Button = $MarginContainer/Options/Controls
@onready var controls_timer: Timer = $MarginContainer/Options/ControlsTimer
@onready var reset_timer: Timer = $MarginContainer/Options/ResetTimer
@onready var back_timer: Timer = $MarginContainer/Options/BackTimer
@onready var credits_button: Button = $MarginContainer/Options/Credits
@onready var credits_timer: Timer = $MarginContainer/Options/CreditsTimer
@onready  var reset_game_confirm: ConfirmationDialog = $MarginContainer/Options/ResetGameConfirm

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	reset_game_confirm.hide()
	
func _on_check_button_toggled(toggled_on: bool)  -> void:
	if toggled_on:
		Global.INPUT_SCHEME = Global.INPUT_SCHEMES.GAMEPAD
	else:
		Global.INPUT_SCHEME = Global.INPUT_SCHEMES.MOUSE_AND_KEYBOARD


func _on_reset_pressed() -> void:
	if reset_timer.is_stopped():
		reset_timer.start()
		select_audio.play()
		reset_button.disabled = true
		get_tree().paused = true
		reset_game_confirm.show()


func _on_back_pressed() -> void:
	if back_timer.is_stopped():
		back_timer.start()
		back_audio.play()
		back_button.disabled = true
		get_tree().paused = true


func _on_check_button_mouse_entered() -> void:
	hover_audio.play()


func _on_reset_mouse_entered() -> void:
	hover_audio.play()


func _on_back_mouse_entered() -> void:
	hover_audio.play()


func _on_reset_timer_timeout() -> void:
	pass


func _on_back_timer_timeout() -> void:
	Global.set_game_started()
	back_button.disabled = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")


func _on_reset_game_confirm_confirmed() -> void:
	reset_button.disabled = false
	get_tree().paused = false
	Global.delete_save()


func _on_reset_game_confirm_canceled() -> void:
	reset_button.disabled = false
	get_tree().paused = false


func _on_controls_timer_timeout() -> void:
	controls_button.disabled = false
	get_tree().paused = false
	var controls_screen = preload("res://Scenes/Menu/control_screen.tscn").instantiate()
	get_tree().root.add_child(controls_screen)


func _on_controls_pressed() -> void:
	if controls_timer.is_stopped():
		controls_timer.start()
		select_audio.play()
		controls_button.disabled = true
		get_tree().paused = true


func _on_controls_mouse_entered() -> void:
	hover_audio.play()

func _on_credits_pressed() -> void:
	if credits_timer.is_stopped():
		credits_timer.start()
		select_audio.play()
		credits_button.disabled = true
		get_tree().paused = true


func _on_credits_mouse_entered() -> void:
	hover_audio.play()


func _on_credits_timer_timeout() -> void:
	credits_button.disabled = false
	get_tree().paused = false
	var credits_screen = preload("res://Scenes/Menu/options_menu_credits.tscn").instantiate()
	get_tree().root.add_child(credits_screen)
