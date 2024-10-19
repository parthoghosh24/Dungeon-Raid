extends Control

@onready var hover_audio = $SFX/Hover
@onready var select_audio = $SFX/Select
@onready var resume_button = $Panel/MarginContainer/Main/Resume
@onready var quit_button = $Panel/MarginContainer/Main/Quit
@onready var resume_timer = $Panel/MarginContainer/Main/ResumeTimer
@onready var quit_timer = $Panel/MarginContainer/Main/QuitTimer

func _on_resume_pressed():
	if resume_timer.is_stopped():
		resume_timer.start()
		select_audio.play()
		resume_button.disabled = true
		get_tree().paused = true

func _on_quit_pressed():
	if quit_timer.is_stopped():
		quit_timer.start()
		select_audio.play()
		quit_button.disabled = true
		get_tree().paused = true

func _on_quit_timer_timeout():
	quit_button.disabled = false
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")

func _on_resume_timer_timeout():
	resume_button.disabled = false
	get_tree().paused = false
	queue_free()	


func _on_try_again_mouse_entered():
	hover_audio.play()


func _on_quit_mouse_entered():
	hover_audio.play()


func _on_resume_mouse_entered():
	hover_audio.play()
