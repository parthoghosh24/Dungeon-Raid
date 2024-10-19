extends Control

@onready var hover_audio = $SFX/Hover
@onready var select_audio = $SFX/Select
@onready var try_again_button = $MarginContainer/Main/TryAgain
@onready var quit_button = $MarginContainer/Main/Quit
@onready var try_again_timer = $MarginContainer/Main/TryAgainTimer
@onready var quit_timer = $MarginContainer/Main/QuitTimer

func _on_try_again_pressed():
	if try_again_timer.is_stopped():
		try_again_timer.start()
		select_audio.play()
		try_again_button.disabled = true
		get_tree().paused = true
	

func _on_quit_pressed():
	if quit_timer.is_stopped():
		quit_timer.start()
		select_audio.play()
		quit_button.disabled = true
		get_tree().paused = true


func _on_try_again_timer_timeout():
	try_again_button.disabled = false
	get_tree().paused = false
	Global.update_player_score(Global.RETRIES, -100)
	var level1 = load("res://Scenes/Levels/level_1.tscn")
	get_tree().change_scene_to_packed(level1)


func _on_quit_timer_timeout():
	quit_button.disabled = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")


func _on_try_again_mouse_entered():
	hover_audio.play()


func _on_quit_mouse_entered():
	hover_audio.play()
