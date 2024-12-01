extends Control

@onready var press_to_start_audio: AudioStreamPlayer = $SFX/PressToStart
@onready var hover_audio: AudioStreamPlayer = $SFX/Hover
@onready var select_audio: AudioStreamPlayer = $SFX/Select

#Timers
@onready var next_level_timer: Timer = $Panel/NextLevelTimer
@onready var quit_timer: Timer = $Panel/QuitTimer

#Buttons
@onready var next_level_button: Button = $Panel/NextLevel
@onready var quit_button: Button = $Panel/Quit


#Ranks
@onready var rank_value_s: Label = $Panel/RankValueS
@onready var rank_value_a: Label = $Panel/RankValueA
@onready var rank_value_b: Label = $Panel/RankValueB
@onready var rank_value_c: Label = $Panel/RankValueC
@onready var rank_value_d: Label = $Panel/RankValueD

@onready var time_value: Label = $Panel/TimeValue
@onready var hits_taken_value: Label = $Panel/HitsTakenValue
@onready var retries_value: Label = $Panel/RetriesValue
@onready var seen_value: Label = $Panel/SeenValue
@onready var kills_value: Label = $Panel/KillsValue
@onready var stealth_kills_value: Label = $Panel/StealthKillsValue
@onready var exploration_bonus_value: Label = $Panel/ExplorationBonusValue
@onready var stealth_kill_bonus_value: Label = $Panel/StealthKillBonusValue
@onready var retry_bonus_value: Label = $Panel/RetryBonusValue
@onready var not_seem_bonus_value: Label = $Panel/NotSeenBonusValue
@onready var total_value: Label = $Panel/TotalValue


# Called when the node enters the scene tree for the first time.
func _ready()  -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	assign_scores_and_calculate_rank()
	

func assign_scores_and_calculate_rank()  -> void:
	var level_score: Dictionary = Global.get_player_score()
		
		
	time_value.text = str(level_score[Global.TIME_TAKEN])
	hits_taken_value.text = str(level_score[Global.HITS_TAKEN])
	retries_value.text = str(level_score[Global.RETRIES])
	seen_value.text = str(level_score[Global.SEEN])
	kills_value.text = str(level_score[Global.KILLS])
	stealth_kills_value.text = str(level_score[Global.STEALTH_KILLS])
	exploration_bonus_value.text = str(level_score[Global.EXPLORATION_BONUS])
	stealth_kill_bonus_value.text = str(level_score[Global.STEALTH_KILL_BONUS])
	retry_bonus_value.text = str(level_score[Global.RETRY_BONUS])
	not_seem_bonus_value.text = str(level_score[Global.NOT_SEEN_BONUS])
	total_value.text = str(level_score[Global.TOTAL])
	
	match level_score[Global.RANK]:
		"S":
			rank_value_s.visible = true
		"A":
			rank_value_a.visible = true
		"B":
			rank_value_b.visible = true
		"C":
			rank_value_c.visible = true
		"D":
			rank_value_d.visible = true
	

func _on_quit_pressed() -> void:
	if quit_timer.is_stopped():
		quit_timer.start()
		select_audio.play()
		quit_button.disabled = true
		get_tree().paused = true


func _on_next_level_pressed()  -> void:
	if next_level_timer.is_stopped():
		next_level_timer.start()
		press_to_start_audio.play()
		next_level_button.disabled = true
		get_tree().paused = true


func _on_quit_mouse_entered()  -> void:
	hover_audio.play()


func _on_next_level_mouse_entered()  -> void:
	hover_audio.play()


func _on_next_level_timer_timeout()  -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	next_level_button.disabled = false
	get_tree().paused = false
	Global.switch_to_next_level()


func _on_quit_timer_timeout() -> void:
	quit_button.disabled = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
