extends Control

@onready var back_audio: AudioStreamPlayer = $SFX/Back
@onready var hover_audio: AudioStreamPlayer = $SFX/Hover
@onready var back_button: Button = $Panel/VBoxContainer/Back
@onready var back_timer: Timer = $Panel/VBoxContainer/BackTimer


func _ready() -> void:
	get_tree().paused = true

func _on_back_pressed() -> void:
	if back_timer.is_stopped():
		back_timer.start()
		back_audio.play()
		back_button.disabled = true
		get_tree().paused = true

func _on_back_mouse_entered() -> void:
	hover_audio.play()

func _on_back_timer_timeout() -> void:
	queue_free()
