extends Control

@onready var continue_button = $MarginContainer/Main/Continue
@onready var press_to_start_button = $MarginContainer/Main/PressToStart
@onready var start_game_button = $MarginContainer/Main/StartGame
@onready var options_button = $MarginContainer/Main/Options
@onready var quit_button = $MarginContainer/Main/Quit
@onready var level
@onready var press_to_start_audio = $SFX/PressToStart
@onready var hover_audio = $SFX/Hover
@onready var select_audio = $SFX/Select
@onready var press_to_start_timer =$MarginContainer/Main/PressToStartTimer
@onready var continue_timer =$MarginContainer/Main/ContinueTimer
@onready var start_game_timer =$MarginContainer/Main/StartGameTimer
@onready var options_timer =$MarginContainer/Main/OptionsTimer
@onready var quit_timer =$MarginContainer/Main/QuitTimer

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if !Global.has_game_started():
		press_to_start_button.visible = true
		continue_button.visible = false
		start_game_button.visible = false
		options_button.visible = false
		quit_button.visible = false
	else:
		show_menu_buttons()	

func _on_continue_pressed():
	if continue_timer.is_stopped():
		continue_timer.start()
		press_to_start_audio.play()
		continue_button.disabled = true
		get_tree().paused = true

func _on_start_game_pressed():
	if start_game_timer.is_stopped():
		start_game_timer.start()
		press_to_start_audio.play()
		start_game_button.disabled = true
		get_tree().paused = true

func _on_options_pressed():
	if options_timer.is_stopped():
		options_timer.start()
		options_button.disabled = true
		select_audio.play()
		options_button.disabled = true
		get_tree().paused = true

func _on_quit_pressed():
	if quit_timer.is_stopped():
		quit_timer.start()
		select_audio.play()
		quit_button.disabled = true
		get_tree().paused = true

func _on_press_to_start_pressed():
	if press_to_start_timer.is_stopped():
		press_to_start_timer.start()
		press_to_start_audio.play()	
		press_to_start_button.disabled = true
		get_tree().paused = true

func show_menu_buttons():
	press_to_start_button.visible = false
	start_game_button.visible = true
	options_button.visible = true
	quit_button.visible = true
	
	continue_button.visible = false
	level = Global.load_game()
	if level != null and level >= 0:
		continue_button.visible = true
	

func _on_start_game_focus_entered():
	if hover_audio and !hover_audio.is_playing():
		hover_audio.play()


func _on_start_game_mouse_entered():
	hover_audio.play()


func _on_options_mouse_entered():
	hover_audio.play()


func _on_quit_mouse_entered():
	hover_audio.play()

func _on_continue_focus_entered():
	if hover_audio and !hover_audio.is_playing():
		hover_audio.play()


func _on_continue_mouse_entered():
	hover_audio.play()	


func _on_press_to_start_timer_timeout():
	press_to_start_button.disabled = false
	get_tree().paused = false
	Global.set_game_started()
	show_menu_buttons()


func _on_start_game_timer_timeout():
	start_game_button.disabled = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/intro.tscn")


func _on_options_timer_timeout():
	options_button.disabled = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/options_menu.tscn")


func _on_quit_timer_timeout():
	quit_button.disabled = false
	get_tree().paused = false
	get_tree().quit()


func _on_continue_timer_timeout():
	continue_button.disabled = false
	get_tree().paused = false
	Global.load_level(level)
