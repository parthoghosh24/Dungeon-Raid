extends Control

@onready var hover_audio: AudioStreamPlayer = $SFX/Hover
@onready var select_audio: AudioStreamPlayer = $SFX/Select
@onready var resume_button: Button = $Panel/MarginContainer/Main/Resume
@onready var quit_button: Button = $Panel/MarginContainer/Main/Quit
@onready var resume_timer: Timer = $Panel/MarginContainer/Main/ResumeTimer
@onready var quit_timer: Timer = $Panel/MarginContainer/Main/QuitTimer
@onready var controls_button: Button = $Panel/MarginContainer/Main/Controls
@onready var controls_timer: Timer = $Panel/MarginContainer/Main/ControlsTimer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func _on_resume_pressed() -> void:
	if resume_timer.is_stopped():
		resume_timer.start()
		select_audio.play()
		resume_button.disabled = true
		get_tree().paused = true

func _on_quit_pressed() -> void:
	if quit_timer.is_stopped():
		quit_timer.start()
		select_audio.play()
		quit_button.disabled = true
		get_tree().paused = true

func _on_quit_timer_timeout() -> void:
	quit_button.disabled = false
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")

func _on_resume_timer_timeout() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	resume_button.disabled = false
	get_tree().paused = false
	queue_free()	


func _on_try_again_mouse_entered() -> void:
	hover_audio.play()


func _on_quit_mouse_entered() -> void:
	hover_audio.play()


func _on_resume_mouse_entered() -> void:
	hover_audio.play()


func _on_controls_pressed() -> void:
	if controls_timer.is_stopped():
		controls_timer.start()
		select_audio.play()
		controls_button.disabled = true
		get_tree().paused = true


func _on_controls_mouse_entered() -> void:
	hover_audio.play()


func _on_controls_timer_timeout() -> void:
	controls_button.disabled = false
	get_tree().paused = false
	var controls_screen = preload("res://Scenes/Menu/control_screen.tscn").instantiate()
	get_tree().root.add_child(controls_screen)
