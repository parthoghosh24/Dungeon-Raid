extends Control

@onready var cutscene: AnimationPlayer = $Cutscene

@onready var main_menu_timer: Timer = $Panel/MainMenuTimer

@onready var hover_audio: AudioStreamPlayer = $SFX/Hover
@onready var select_audio: AudioStreamPlayer = $SFX/Select

@onready var main_menu_button: Button = $Panel/MainMenu

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	main_menu_button.disabled = true
	calc_final_rank()
	

func calc_final_rank() -> void:
	var grand_total = Global.load_grand_total()
	var avg_score = grand_total / 5
	if avg_score >= 15000:
		cutscene.queue("RankS")
		await cutscene.animation_finished
	elif avg_score >= 10000 and avg_score < 15000:
		cutscene.queue("RankA")
		await cutscene.animation_finished
	elif avg_score >= 8000 and avg_score < 10000:
		cutscene.queue("RankB")
		await cutscene.animation_finished
	elif avg_score >= 5000 and avg_score < 8000:
		cutscene.queue("RankC")
		await cutscene.animation_finished
	elif avg_score < 5000:
		cutscene.queue("RankD")
		await cutscene.animation_finished
	main_menu_button.disabled = false	


func _on_main_menu_timer_timeout() -> void:
	Global.delete_save()
	main_menu_button.disabled = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")


func _on_main_menu_pressed() -> void:
	if main_menu_timer.is_stopped():
		main_menu_timer.start()
		select_audio.play()
		main_menu_button.disabled = true
		get_tree().paused = true


func _on_main_menu_mouse_entered() -> void:
	hover_audio.play()
