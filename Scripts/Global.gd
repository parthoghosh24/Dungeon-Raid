extends Node


# Called when the node enters the scene tree for the first time.

enum PLAYER_INVENTORY_ITEMS { DOOR_KEY }
enum INPUT_SCHEMES { MOUSE_AND_KEYBOARD, GAMEPAD }
static var INPUT_SCHEME: INPUT_SCHEMES = INPUT_SCHEMES.MOUSE_AND_KEYBOARD

var levels: Array = ["res://Scenes/Levels/level_1.tscn", 
			  "res://Scenes/Levels/level_2.tscn",
			  "res://Scenes/Levels/level_3.tscn",
			  "res://Scenes/Levels/level_4.tscn",
			  "res://Scenes/Levels/level_5.tscn"]

#Player score keys
const RETRIES: String = "retries"
const TIME_TAKEN: String = "time_taken"
const HITS_TAKEN: String = "hits_taken"
const SEEN: String = "seen"
const KILLS: String = "kills"
const STEALTH_KILLS: String = "stealth_kills"
const EXPLORATION_BONUS: String = "exploration_bouns"
const STEALTH_KILL_BONUS: String = "stealth_kill_bonus"
const RETRY_BONUS: String = "retry_bonus"
const NOT_SEEN_BONUS: String = "not_seen_bonus"
const TOTAL: String = "total"
const RANK: String = "rank"

var player_inventory
var current_level: int
var file: FileAccess
var game_started: bool = false
var player_score: Dictionary = {RETRIES: 0,
					TIME_TAKEN: 0,
					HITS_TAKEN: 0,
					SEEN: 0,
					KILLS: 0,
					STEALTH_KILLS: 0,
					EXPLORATION_BONUS: 0,
					STEALTH_KILL_BONUS: 0,
					RETRY_BONUS: 0,
					NOT_SEEN_BONUS: 0,
					TOTAL: 0,
					RANK: "",}
					
var playing_level_cutscene: bool = false					

func update_player_score(key: String, score: int) -> void:
	player_score[key] += score

func get_player_score() -> Dictionary:
	return player_score	
	
func set_level(level: int) -> void:
	current_level = level
	
func get_level() -> int:
	return current_level
	
func set_game_started() -> void:
	game_started = true
	
func has_game_started() -> bool:
	return game_started	

func set_player_inventory(item: PLAYER_INVENTORY_ITEMS) -> void:
	player_inventory = item

func get_player_inventory() -> PLAYER_INVENTORY_ITEMS:
	return player_inventory

func clear_player_inventory() -> void:
	player_inventory = null
	
func evaluate_input_scheme(event: InputEvent) -> void:
	if event is InputEventJoypadMotion or event is InputEventJoypadButton and INPUT_SCHEME != INPUT_SCHEMES.GAMEPAD:
		return
	
	if (event is InputEventMouseMotion or event is InputEventMouseButton or event is InputEventKey) and  INPUT_SCHEME != INPUT_SCHEMES.MOUSE_AND_KEYBOARD:
		return

func calculate_final_player_score() -> void:
	player_score[STEALTH_KILL_BONUS] = 2000 if player_score[STEALTH_KILLS] == 0 else 0
	player_score[RETRY_BONUS] = 2000 if player_score[RETRIES] == 0 else 0
	player_score[NOT_SEEN_BONUS] = 5000 if player_score[SEEN] == 0 else 0
	
	# calculate total score
	for score_item in player_score:
		if score_item != TOTAL and score_item != RANK:
			player_score[TOTAL] += player_score[score_item]	
	
	if player_score[TOTAL] >= 15000:
		player_score[RANK] = "S"
	elif player_score[TOTAL] >= 10000 and player_score[TOTAL] < 15000:
		player_score[RANK] = "A"
	elif player_score[TOTAL] >= 8000 and player_score[TOTAL] < 10000:
		player_score[RANK] = "B"
	elif player_score[TOTAL] >= 5000 and player_score[TOTAL] < 8000:
		player_score[RANK] = "C"
	elif player_score[TOTAL] < 5000:
		player_score[RANK] = "D"
	
		
						
func reset_score_board() -> void:
	player_score = {RETRIES: 0,
					TIME_TAKEN: 0,
					HITS_TAKEN: 0,
					SEEN: 0,
					KILLS: 0,
					STEALTH_KILLS: 0,
					EXPLORATION_BONUS: 0,
					STEALTH_KILL_BONUS: 0,
					RETRY_BONUS: 0,
					NOT_SEEN_BONUS: 0,
					TOTAL: 0,
					RANK: "",}
	
func switch_to_score_board() -> void:
	calculate_final_player_score()
	var grand_total = load_grand_total()
	save_grand_total(grand_total + player_score[TOTAL])
	save_game(current_level + 1)
	var score_board = load("res://Scenes/Menu/score_board.tscn")
	get_tree().change_scene_to_packed(score_board)	

func switch_to_next_level() -> void:
	reset_score_board()
	# last level
	if current_level == 4:
		var end_cutscene = load("res://Scenes/end_cutscene.tscn")
		get_tree().change_scene_to_packed(end_cutscene)
	else:
		var level = load(levels[current_level + 1])
		get_tree().change_scene_to_packed(level)
	
func load_level(index: int) -> void:
	var level
	if index == -1:
		level = load("res://Scenes/Menu/main_menu.tscn")
	else:
		level = load(levels[index])
	get_tree().change_scene_to_packed(level)
		

func knockback(mesh_global_position: Vector3, direction: Vector3) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", mesh_global_position - (direction / 1.5), 0.2)
	
func save_grand_total(grand_total: int)-> void:
	file = FileAccess.open("user://grand_total.data", FileAccess.WRITE)
	file.store_var(grand_total)
	file.close()

func load_grand_total() -> int:
	file = FileAccess.open("user://grand_total.data", FileAccess.READ)
	if not file:
		return 0
	var grand_total = file.get_var()
	if grand_total == null:
		grand_total = 0
	file.close()
	return grand_total	
	
func save_game(data: int) -> void:
	file = FileAccess.open("user://savegame.data", FileAccess.WRITE)
	file.store_var(data)
	file.close()
	

func load_game() -> int:
	file = FileAccess.open("user://savegame.data", FileAccess.READ)
	if not file:
		return -1
	var level = file.get_var()
	file.close()
	return level

func delete_save() -> void:
	DirAccess.remove_absolute("user://savegame.data")
	DirAccess.remove_absolute("user://grand_total.data")
		

func play_level_cutscene() -> void:
	playing_level_cutscene = true

func level_cutscene_playing() -> bool:
	return 	playing_level_cutscene

func stop_level_cutscene() -> void:
	playing_level_cutscene = false
	
	
