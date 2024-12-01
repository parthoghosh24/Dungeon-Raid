extends Control

@onready var hover_audio: AudioStreamPlayer = $SFX/Hover
@onready var select_audio: AudioStreamPlayer = $SFX/Select
@onready var try_again_button: Button = $MarginContainer/Main/TryAgain
@onready var quit_button: Button = $MarginContainer/Main/Quit
@onready var try_again_timer: Timer = $MarginContainer/Main/TryAgainTimer
@onready var quit_timer: Timer = $MarginContainer/Main/QuitTimer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_try_again_pressed() -> void:
	if try_again_timer.is_stopped():
		try_again_timer.start()
		select_audio.play()
		try_again_button.disabled = true
		get_tree().paused = true
	

func _on_quit_pressed() -> void:
	if quit_timer.is_stopped():
		quit_timer.start()
		select_audio.play()
		quit_button.disabled = true
		get_tree().paused = true


func _on_try_again_timer_timeout() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	try_again_button.disabled = false
	get_tree().paused = false
	Global.update_player_score(Global.RETRIES, -100)
	Global.load_level(Global.get_level())


func _on_quit_timer_timeout() -> void:
	quit_button.disabled = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")


func _on_try_again_mouse_entered() -> void:
	hover_audio.play()


func _on_quit_mouse_entered() -> void:
	hover_audio.play()
