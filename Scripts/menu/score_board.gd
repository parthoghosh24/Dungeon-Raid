extends Control

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
	
	init_scores()
	

func init_scores():
	time_value.text = "0"
	hits_taken_value.text = "0"
	retries_value.text = "0"
	seen_value.text = "0"
	kills_value.text = "0"
	stealth_kills_value.text = "0"
	exploration_bonus_value.text = "0"
	stealth_kill_bonus_value.text = "0"
	retry_bonus_value.text = "0"
	not_seem_bonus_value.text = "0"
	total_value.text = "0"
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	pass # Replace with function body.


func _on_next_level_pressed():
	pass # Replace with function body.
