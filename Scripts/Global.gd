extends Node


# Called when the node enters the scene tree for the first time.

enum PLAYER_INVENTORY_ITEMS { DOOR_KEY }
enum INPUT_SCHEMES { MOUSE_AND_KEYBOARD, GAMEPAD }
static var INPUT_SCHEME: INPUT_SCHEMES = INPUT_SCHEMES.MOUSE_AND_KEYBOARD

var levels = ["res://Scenes/Levels/level_1.tscn", "res://Scenes/Levels/level_2.tscn"]

var player_inventory
var current_level
var file
		
		
func set_level(level):
	current_level = level
	
func get_level():
	return current_level

func set_player_inventory(item: PLAYER_INVENTORY_ITEMS):
	player_inventory = item

func get_player_inventory():
	return player_inventory	
	
func evaluate_input_scheme(event):
	if event is InputEventJoypadMotion or event is InputEventJoypadButton and INPUT_SCHEME != INPUT_SCHEMES.GAMEPAD:
		return
	
	if (event is InputEventMouseMotion or event is InputEventMouseButton or event is InputEventKey) and  INPUT_SCHEME != INPUT_SCHEMES.MOUSE_AND_KEYBOARD:
		return

func switch_to_next_level():
	var level = load(levels[current_level + 1])
	get_tree().change_scene_to_packed(level)
	
func load_level(index):
	print(index)
	var level = load(levels[index])
	get_tree().change_scene_to_packed(level)
		

func knockback(mesh_global_position, direction):
	var tween = create_tween()
	tween.tween_property(self, "global_position", mesh_global_position - (direction / 1.5), 0.2)
	

func save_game(data):
	print("save data is")
	print(data)
	file = FileAccess.open("res://savegame.data", FileAccess.WRITE)
	file.store_var(data)
	file.close()
	

func load_game():
	file = FileAccess.open("res://savegame.data", FileAccess.READ)
	if not file:
		return
	var level = file.get_var()
	file.close()
	return level
	
	
