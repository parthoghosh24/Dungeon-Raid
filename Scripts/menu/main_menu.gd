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
@onready var select_audio_2 = $SFX/Select2

func _ready():
	if !Global.has_game_started():
		press_to_start_button.visible = true
		continue_button.visible = false
		start_game_button.visible = false
		options_button.visible = false
		quit_button.visible = false
	else:
		show_menu_buttons()
			
	

func _on_continue_pressed():
	press_to_start_audio.play()
	Global.load_level(level)


func _on_start_game_pressed():
	press_to_start_audio.play()
	get_tree().change_scene_to_file("res://Scenes/intro.tscn")


func _on_options_pressed():
	select_audio_2.play()
	get_tree().change_scene_to_file("res://Scenes/Menu/options_menu.tscn")

func _on_quit_pressed():
	select_audio_2.play()
	get_tree().quit()

func show_menu_buttons():
	press_to_start_button.visible = false
	start_game_button.visible = true
	options_button.visible = true
	quit_button.visible = true
	
	continue_button.visible = false
	level = Global.load_game()
	if level != null and level >= 0:
		continue_button.visible = true

func _on_press_to_start_pressed():
	
	press_to_start_audio.play()
	
	Global.set_game_started()
	show_menu_buttons()
	

func _on_start_game_focus_entered():
	if hover_audio and !hover_audio.is_playing():
		hover_audio.play()


func _on_start_game_mouse_entered():
	hover_audio.play()


func _on_options_mouse_entered():
	hover_audio.play()


func _on_quit_mouse_entered():
	hover_audio.play()
