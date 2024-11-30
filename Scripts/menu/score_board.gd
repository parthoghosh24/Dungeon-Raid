extends Control

@onready var press_to_start_audio = $SFX/PressToStart
@onready var hover_audio = $SFX/Hover
@onready var select_audio = $SFX/Select

#Timers
@onready var next_level_timer = $Panel/NextLevelTimer
@onready var quit_timer = $Panel/QuitTimer

#Buttons
@onready var next_level_button = $Panel/NextLevel
@onready var quit_button = $Panel/Quit


#Ranks
@onready var rank_value_s = $Panel/RankValueS
@onready var rank_value_a = $Panel/RankValueA
@onready var rank_value_b = $Panel/RankValueB
@onready var rank_value_c = $Panel/RankValueC
@onready var rank_value_d = $Panel/RankValueD

@onready var time_value = $Panel/TimeValue
@onready var hits_taken_value = $Panel/HitsTakenValue
@onready var retries_value = $Panel/RetriesValue
@onready var seen_value = $Panel/SeenValue
@onready var kills_value = $Panel/KillsValue
@onready var stealth_kills_value = $Panel/StealthKillsValue
@onready var exploration_bonus_value = $Panel/ExplorationBonusValue
@onready var stealth_kill_bonus_value = $Panel/StealthKillBonusValue
@onready var retry_bonus_value = $Panel/RetryBonusValue
@onready var not_seem_bonus_value = $Panel/NotSeenBonusValue
@onready var total_value = $Panel/TotalValue
var level_scores


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	assign_scores_and_calculate_rank()
	

func assign_scores_and_calculate_rank():
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
	

func _on_quit_pressed():
	if quit_timer.is_stopped():
		quit_timer.start()
		select_audio.play()
		quit_button.disabled = true
		get_tree().paused = true


func _on_next_level_pressed():
	if next_level_timer.is_stopped():
		next_level_timer.start()
		press_to_start_audio.play()
		next_level_button.disabled = true
		get_tree().paused = true


func _on_quit_mouse_entered():
	hover_audio.play()


func _on_next_level_mouse_entered():
	hover_audio.play()


func _on_next_level_timer_timeout():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	next_level_button.disabled = false
	get_tree().paused = false
	Global.switch_to_next_level()


func _on_quit_timer_timeout():
	quit_button.disabled = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
