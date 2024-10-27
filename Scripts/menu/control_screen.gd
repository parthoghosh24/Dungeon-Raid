extends Control

@onready var back_audio = $SFX/Back
@onready var hover_audio = $SFX/Hover
@onready var back_button = $Panel/VBoxContainer/Back
@onready var back_timer = $Panel/VBoxContainer/BackTimer


func _ready():
	get_tree().paused = true

func _on_back_pressed():
	if back_timer.is_stopped():
		back_timer.start()
		back_audio.play()
		back_button.disabled = true
		get_tree().paused = true

func _on_back_mouse_entered():
	hover_audio.play()

func _on_back_timer_timeout():
	queue_free()
